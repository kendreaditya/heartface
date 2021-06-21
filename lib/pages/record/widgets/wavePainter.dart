import 'dart:math';
import 'dart:core';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './../../../constants.dart';

class WavePainter extends CustomPainter {
  List<int> samples;
  List<Offset> points;
  Color color;
  BuildContext context;
  Size size;

  // Set max val possible in stream, depending on the config
  final int absMax = 5000;
  // (AUDIO_FORMAT == AudioFormat.ENCODING_PCM_8BIT) ? 127 : 32767;

  WavePainter(this.samples, this.color, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    //this.size = context.size;
    this.size = Size(500, 500);
    size = this.size;

    Paint paint = new Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    points = toPoints(samples);

    Path path = new Path();
    path.addPolygon(points, false);

    canvas.drawPath(path, paint);
    if (samples != null) {
      final offset = Offset(min(size.width, samples.length).toDouble(),
          project(samples[samples.length - 1], absMax, size.height));
      canvas.drawCircle(
        offset,
        2,
        Paint()
          ..strokeWidth = 2
          ..color = colors["grey"]
          ..style = PaintingStyle.fill,
        //opacity
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldPainting) => true;

  // Maps a list of ints and their indices to a list of points on a cartesian grid
  List<Offset> toPoints(List<int> samples) {
    List<Offset> points = [];
    if (samples == null) {
      samples =
          List<int>.filled(size.width.toInt(), (0.5 * size.height).toInt());
    }
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
