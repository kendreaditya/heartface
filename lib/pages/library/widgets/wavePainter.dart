import 'package:flutter/material.dart';
import 'dart:math';
import './../../../constants.dart';

class WavePainter extends CustomPainter {
  List<int> samples;
  List<Offset> points;
  Size size;

  final int absMax = 5000;

  WavePainter(this.samples);

  @override
  void paint(Canvas canvas, Size size) {
    this.size = size;

    Paint paint = new Paint()
      ..color = colors["red"]
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    points = toPoints(samples);

    Path path = new Path();
    path.addPolygon(points, false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldPainting) => false;

  // Maps a list of ints and their indices to a list of points on a cartesian grid
  List<Offset> toPoints(List<int> samples) {
    List<Offset> points = [];
    for (int i = 0; i < min(size.width, samples.length).toInt(); i++) {
      points.add(
          new Offset(i.toDouble(), project(samples[i], absMax, size.height)));
    }
    return points;
  }

  double project(int val, int max, double height) {
    double waveHeight =
        (max == 0) ? val.toDouble() : (val / max) * 0.5 * height;
    return waveHeight + 0.5 * height;
  }
}
