<p align="center"><img src="assets/logo.png" width=150></p> 
<h2 align="center">Heart Face</h2>
<h4 align="center">A heart sound abnormality detection system.</h4>

<p align="center">
	<img src="assets/phoneScreenRecording_1.gif" width=300>
</p>

## Description
Heart Face is an app that detects cardiac abnormalities like gallops and murmurs from heart sounds just from a smartphone microphone. The app uses the microphone to record the sounds created by the mechanical movements of the heart. From the recording, the app predicts the probability of an abnormality and notifies the user of potential gallops or murmurs using AI.

## Structure

| Codebase              |      Description          |
| :-------------------- | :-----------------------: |
| [app]()        	|	Flutter App	    |
| [fastAPI](backend)  	|	fastAPI Backend     |
| [node](backend-node)  |	Node.js Backend     |


## Dependencies
App (frontend)
```
cupertino_icons: 0.1.2
mic_stream: 0.2.0+2
http: 0.13.1
charts_flutter: 0.10.0
```

Backend
```
pydantic==1.8.1
scipy==1.5.4
torch==1.8.1+cu102
fastapi==0.65.2
numpy==1.20.3
```

## Installation
You can install Heart Face the following method:

1. Clone the Repo and cd into it
	```
	git clone https://github.com/kendreaditya/heartface.git
	cd heartface
	```
2. Install Dependencies
	```
	flutter packages get
	```
3. Run the app
	```
	flutter run
	```
## TODO List
- Implament a Computer Vision (CV) based system for cardiac landmark detection
	- Based on the Jugular Notch and Xiphoid Process 
- Heart rate algorithm

## Contribution
Whether you have ideas, translations, design changes, code cleaning, or real heavy code changes, help is always welcome.
The more is done the better it gets!
