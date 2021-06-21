from fastapi import FastAPI
from pydantic import BaseModel
from scipy import signal
import time
import torch
import numpy as np

net = torch.load("./model-jit.pt").forward

try:
    net(torch.rand(1, 1, 2500))
    print("Model is working!")
except:
    print("Model is not working")


softmax = torch.nn.Softmax()
labels = ["nomral", "murmur", "gallop", "noisy"]

app = FastAPI()


class SampleStack(BaseModel):
    samples: list


@app.post("/api/v1/prediction")
async def root(request: SampleStack):

    time_stamp = time.time()
    torch.save(request.samples, f"./recordings/POST_{time_stamp}.pt")

    secs = len(request.samples)/8000
    num_samples = int(secs*500)
    data = signal.resample(request.samples, num_samples).tolist()

    data = torch.tensor(data+data)[:2500].reshape(1, 1, 2500)
    # data = (data - torch.mean(data))/torch.std(data)
    output = net(data)

    label_idx = torch.argmax(output)
    pred, confidence = labels[label_idx], int(
        (softmax(output)[0][label_idx])*100)

    if np.std(request.samples) > 35 and pred == "noisy":
        pred = "nomral"

    return {"prediction": pred,
            "confidence": confidence}
