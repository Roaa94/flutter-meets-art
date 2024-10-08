import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:playground/algorithms/voronoi_relaxation.dart';
import 'package:playground/enums.dart';
import 'package:playground/utils/math_utils.dart';

class StipplingPainter extends CustomPainter {
  StipplingPainter({
    required this.relaxation,
    this.paintColors = false,
    this.mode = StippleMode.dots,
    this.pointStrokeWidth = 5,
    this.minStroke = 4,
    this.maxStroke = 15,
    this.weightedPoints = true,
    this.pointsColor = Colors.white,
    this.bgColor = Colors.black,
  }) {
    stipplePaints = <Paint>[];
    secondaryStipplePaints = <Paint>[];
    weightedStrokes = Float32List(relaxation.coords.length ~/ 2);
    for (int i = 0; i < relaxation.colors.length; i++) {
      final color = Color(relaxation.colors[i]);
      final paint = Paint()
        ..color = paintColors
            ? color
            : mode == StippleMode.polygons
                ? bgColor
                : pointsColor;
      double stroke = pointStrokeWidth;
      if (relaxation.weighted && weightedPoints) {
        stroke = map(relaxation.strokeWeights[i], 0, 1, minStroke, maxStroke);
      }
      weightedStrokes[i] = stroke;
      if (mode == StippleMode.circles) {
        paint
          ..strokeWidth = stroke * 0.1
          ..style = PaintingStyle.stroke;
      }

      stipplePaints.add(paint);

      final secondaryPaint = Paint()
        ..color = paintColors
            ? color
            : mode == StippleMode.polygons
                ? Colors.black
                : Colors.white
        ..strokeWidth = mode == StippleMode.polygonsOutlined ? 2 : 1
        ..style = PaintingStyle.stroke;
      secondaryStipplePaints.add(secondaryPaint);
    }
  }

  final VoronoiRelaxation relaxation;
  final bool paintColors;
  final StippleMode mode;
  final double pointStrokeWidth;
  final double minStroke;
  final double maxStroke;
  final bool weightedPoints;
  final Color pointsColor;
  final Color bgColor;

  final circlesPaint = Paint();
  late final List<Paint> stipplePaints;
  late final List<Paint> secondaryStipplePaints;
  late final Float32List weightedStrokes;
  final bgPaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPaint(bgPaint..color = bgColor);
    if (mode == StippleMode.polygons || mode == StippleMode.polygonsOutlined) {
      final cells = relaxation.voronoi.cells;
      for (int j = 0; j < cells.length; j++) {
        final path = Path()..moveTo(cells[j][0].dx, cells[j][0].dy);
        for (int i = 1; i < cells[j].length; i++) {
          path.lineTo(cells[j][i].dx, cells[j][i].dy);
        }
        path.close();

        if (mode != StippleMode.polygonsOutlined) {
          canvas.drawPath(path, stipplePaints[j]);
        }

        canvas.drawPath(
          path,
          secondaryStipplePaints[j],
        );
      }
    }

    if (mode == StippleMode.dots || mode == StippleMode.circles) {
      for (int i = 0; i < relaxation.coords.length; i += 2) {
        canvas.drawCircle(
          Offset(relaxation.coords[i], relaxation.coords[i + 1]),
          weightedStrokes[i ~/ 2] / 2,
          stipplePaints[i ~/ 2],
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
