import 'dart:ui';

import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final Color pointerColor;

  DrawingPainter(this.points,this.pointerColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = pointerColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[i]!], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
