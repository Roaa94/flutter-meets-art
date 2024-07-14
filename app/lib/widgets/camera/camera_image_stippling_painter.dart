import 'dart:typed_data';

import 'package:app/algorithms/voronoi_relaxation.dart';
import 'package:app/enums.dart';
import 'package:app/utils/math_utils.dart';
import 'package:flutter/material.dart';

class CameraImageStipplingDemoPainter extends CustomPainter {
  CameraImageStipplingDemoPainter({
    required this.relaxation,
    this.paintColors = false,
    this.mode = StippleMode.dots,
    this.pointStrokeWidth = 5,
    this.minStroke = 4,
    this.maxStroke = 15,
  }) {
    bgPaint.color = Colors.black;
    stipplePaints = <Paint>[];
    secondaryStipplePaints = <Paint>[];
    weightedStrokes = Float32List(relaxation.coords.length ~/ 2);
    for (int i = 0; i < relaxation.colors.length; i++) {
      final color = Color(relaxation.colors[i]);
      final paint = Paint()..color = paintColors ? color : Colors.white;
      double stroke = pointStrokeWidth;
      if (relaxation.weighted) {
        stroke = map(relaxation.strokeWeights[i], 0, 1, minStroke, maxStroke);
        weightedStrokes[i] = stroke;
      }
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
        ..strokeWidth = 2
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

  final circlesPaint = Paint();
  late final List<Paint> stipplePaints;
  late final List<Paint> secondaryStipplePaints;
  late final Float32List weightedStrokes;
  final bgPaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPaint(bgPaint);
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
