import 'package:flutter/material.dart';
import './wavePainter.dart';
import './../../../constants.dart';

class RecordingCard {
  final String name;
  final String prediciton;
  final int confidence;
  final String date;
  final List<int> samples;
  String recordingTime;

  RecordingCard(this.name, this.prediciton, this.confidence, this.date,
      this.samples, this.recordingTime);

  Container getCard() {
    return Container(
      decoration: BoxDecoration(
          color: colors['white'],
          borderRadius: BorderRadius.all(Radius.circular(10))),
      margin: EdgeInsets.all(26),
      padding: EdgeInsets.all(17),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: colors["black"],
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
                Icon(
                  Icons.ios_share,
                  color: colors["red"],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 3, top: 3),
            child: Row(
              children: [
                Text(
                  prediciton,
                  style: TextStyle(
                      color: colors["grey"],
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                ),
                Container(
                  margin: EdgeInsets.all(6),
                  child: Icon(
                    Icons.fiber_manual_record,
                    size: 7,
                    color: colors["grey"],
                  ),
                ),
                Text(
                  '$confidence%',
                  style: TextStyle(
                      color: colors["grey"],
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                ),
                Container(
                  margin: EdgeInsets.all(6),
                  child: Icon(
                    Icons.fiber_manual_record,
                    size: 7,
                    color: colors["grey"],
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                      color: colors["grey"],
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            width: 300,
            height: 50,
            child: FittedBox(
              child: CustomPaint(
                painter: WavePainter(samples),
                child: Container(
                  width: 300,
                  height: 50,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.play_arrow,
                color: colors["red"],
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: LinearProgressIndicator(
                      value: .7, backgroundColor: colors["grey"]),
                ),
              ),
              Text(recordingTime),
            ],
          ),
        ],
      ),
    );
  }
}
