const express = require('express');
const Prediction = require('../../models/Prediction.js');
const router = express.Router();
var ObjectId = require('mongodb').ObjectID;

var torch = require('@idn/torchjs');
var model = new torch.ScriptModule('./../../model-jit.pt');

router.post("/create", async (req, res)=> {
    const samples = req.body.samples;

    if (samples) {
        const input = torch.tensor(samples)

        // Python -> convert to JS
        // secs = len(request.samples)/8000
        // num_samples = int(secs*500)
        // data = signal.resample(request.samples, num_samples).tolist()

        // data = torch.tensor(data+data)[:2500].reshape(1, 1, 2500)
        // # data = (data - torch.mean(data))/torch.std(data)
        // output = net(data)

        // label_idx = torch.argmax(output)
        // pred, confidence = labels[label_idx], int(
        //     (softmax(output)[0][label_idx])*100)

        let output = model.forward(data)


        const newPrediction = new Prediction(
            {
                id: undefined,
                date_created: Date.now(),
                prediction: prediction,
                samples: samples,
            }
        )
        
        newPrediction.save().catch(err => console.log(err))
        return res.status(201).send(prediction);

    }
    else {
        return res.status(404).send({
            message: "Please include a recording of samples!"
        })
    }
})

module.exports = router;
