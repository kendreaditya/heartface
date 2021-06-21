import 'package:flutter/material.dart';
import 'package:mic_stream_example/main.dart';
import './widgets/wavePainter.dart';
import './../../constants.dart';

class Record extends StatefulWidget {
  List<int> currentSamples;
  BuildContext mainContext;
  Record(this.currentSamples, this.mainContext);

  @override
  _RecordState createState() => _RecordState(currentSamples, mainContext);
}

class _RecordState extends State<Record> {
  List<int> currentSamples;
  BuildContext mainContext;
  _RecordState(this.currentSamples, this.mainContext);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WavePainter(currentSamples, colors["red"], mainContext),
    );
  }
}
