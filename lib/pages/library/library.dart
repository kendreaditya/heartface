import 'dart:math';

import 'package:flutter/material.dart';
import './widgets/recordingCard.dart';

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  List<Container> _recordings;

  @override
  Widget build(BuildContext context) {
    List<int> exampleRecording = [];

    for (var i = 0; i < 350; i++) {
      exampleRecording.add((sin(i) * 1000).toInt());
    }
    _recordings = [
      RecordingCard("Wednesday at 4:04 PM", "normal", 97, "May 12",
              exampleRecording, "2:34")
          .getCard()
    ];
    return Container(
      child: Column(
        children: _recordings,
      ),
    );
  }
}
