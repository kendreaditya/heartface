import 'dart:async';
import 'dart:math';
import 'dart:core';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';

import 'package:mic_stream/mic_stream.dart';
import './pages/record/widgets/wavePainter.dart';
import './pages/record/widgets/analyzer.dart';
import './constants.dart';
import './pages/library/library.dart';

enum Command {
  start,
  stop,
  change,
}

const AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT;

void main() => runApp(MicStreamExampleApp());

class MicStreamExampleApp extends StatefulWidget {
  @override
  _MicStreamExampleAppState createState() => _MicStreamExampleAppState();
}

class _MicStreamExampleAppState extends State<MicStreamExampleApp>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  Stream<List<int>> stream;
  StreamSubscription<List<int>> listener;
  List<int> currentSamples = [];
  List<int> rawSamples = [];

  Library libraryCards = new Library();

  // Refreshes the Widget for every possible tick to force a rebuild of the sound wave
  AnimationController controller;

  bool isRecording = false;
  bool memRecordingState = false;
  bool isActive;
  DateTime startTime;

  Prediction predicitonResponse = Prediction(prediction: "-", confidence: 0);

  int page = 0;
  List state = ["SoundWavePage", "InformationPage"];

  @override
  void initState() {
    print("Init application");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setState(() {
      initPlatformState();
    });
  }

  void _controlPage(int index) => setState(() {
        _pageIdx = index;
        _pageController.animateToPage(
          index,
          curve: Curves.linear,
          duration: Duration(milliseconds: 400),
        );
      });

  var _pageController = PageController(initialPage: 1);

  // Responsible for switching between recording / idle state
  void _controlMicStream({Command command: Command.change}) async {
    _controlPage(1);
    switch (command) {
      case Command.change:
        _changeListening();
        break;
      case Command.start:
        _startListening();
        break;
      case Command.stop:
        _stopListening();
        break;
    }
  }

  bool _changeListening() =>
      !isRecording ? _startListening() : _stopListening();

  bool _startListening() {
    if (isRecording) return false;
    stream = microphone(
        audioSource: AudioSource.DEFAULT,
        sampleRate: 8000,
        channelConfig: ChannelConfig.CHANNEL_IN_MONO,
        audioFormat: AUDIO_FORMAT);

    setState(() {
      isRecording = true;
      startTime = DateTime.now();
    });

    print("Start Listening to the microphone");
    setState(() {
      currentSamples = [];
    });
    listener = stream.listen((samples) {
      if (currentSamples != null) {
        List<int> resampledSamples = [];
        var window = samples.length ~/ 10;
        for (var i = 0; i < samples.length; i = i + window) {
          var windowSamples = samples.getRange(i, i + window);
          resampledSamples.add((windowSamples.fold(0, (p, c) => p + c)) *
              10 ~/
              windowSamples.length);
        }
        rawSamples.addAll(samples);
        if (currentSamples.length > 350) {
          analyzeSamples(rawSamples)
              .then((value) => setState(() => predicitonResponse = value));
          setState(() => currentSamples = []);
          rawSamples = [];
        }
        setState(() => currentSamples.addAll(resampledSamples));
      } else {
        setState(() => currentSamples = []);
        rawSamples = [];
      }
    });
    return true;
  }

  bool _stopListening() {
    if (!isRecording) return false;
    print("Stop Listening to the microphone");
    listener.cancel();

    setState(() {
      isRecording = false;
      //currentSamples = null;
      startTime = null;
    });
    return true;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;
    isActive = true;

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this)
          ..addListener(() {
            if (isRecording) setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed)
              controller.reverse();
            else if (status == AnimationStatus.dismissed) controller.forward();
          })
          ..forward();
  }

  Icon _getIcon() => (isRecording)
      ? Icon(Icons.pause, size: 32)
      : Icon(Icons.fiber_manual_record, size: 32);

  int _pageIdx = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: colors["light-grey"],
      appBar: AppBar(
        centerTitle: true,
        title: Text("Heart AI"),
        elevation: 0,
        backgroundColor: colors["red"],
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: colors["white"],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => null),
              );
            },
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 68,
        height: 68,
        child: FloatingActionButton(
          onPressed: _controlMicStream,
          child: _getIcon(),
          foregroundColor: colors["white"],
          backgroundColor: colors["red"],
          tooltip: (isRecording) ? "Stop recording" : "Start recording",
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          currentIndex: _pageIdx,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.reorder,
                color: colors["gray"],
              ),
              label: "Library",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.mic_external_off), label: ""),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.mic,
                color: colors["gray"],
              ),
              label: "Source",
            )
          ],
          backgroundColor: colors["white"],
          elevation: 20,
          onTap: _controlPage,
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) => setState(() => _pageIdx = page),
        children: [
          Center(child: libraryCards),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            //child: Recor(currentSamples, context))
            children: [
              Container(
                color: colors["red"],
                alignment: Alignment.topCenter,
                child: Text(
                  '${predicitonResponse.prediction}',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 36,
                      color: colors["white"]),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: colors["red"],
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50))),
                padding: EdgeInsets.only(bottom: 15.0),
                alignment: Alignment.topCenter,
                child: Text(
                  '${predicitonResponse.confidence}% confidence',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: colors["white"],
                  ),
                ),
              ),
              CustomPaint(
                  painter: WavePainter(currentSamples, colors["red"], context)),
              Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  //'Please keep the microphone close to your chest',
                  "",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                    color: colors["grey"],
                  ),
                ),
              ),
            ],
          ),
          Text("Source"),
        ],
      ),
    ));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      isActive = true;
      print("Resume app");

      _controlMicStream(
          command: memRecordingState ? Command.start : Command.stop);
    } else if (isActive) {
      memRecordingState = isRecording;
      _controlMicStream(command: Command.stop);

      print("Pause app");
      isActive = false;
    }
  }

  @override
  void dispose() {
    listener.cancel();
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
