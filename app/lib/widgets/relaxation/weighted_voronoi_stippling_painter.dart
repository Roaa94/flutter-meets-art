import 'dart:typed_data';

import 'package:app/algorithms/voronoi_relaxation.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';

class WeightedVoronoiStipplingPainter extends CustomPainter {
  WeightedVoronoiStipplingPainter({
    required this.relaxation,
    required this.bytes,
    this.paintColors = true,
    this.showVoronoiPolygons = true,
    this.showPoints = true,
    this.pointStrokeWidth = 2,
    this.strokePaintingStyle = false,
    this.weightedStrokes = false,
    this.minStroke = 4,
    this.maxStroke = 8,
    this.pointsColor = Colors.black,
  });

  final VoronoiRelaxation relaxation;
  final ByteData bytes;
  final bool paintColors;
  final bool showPoints;
  final bool showVoronoiPolygons;
  final double pointStrokeWidth;
  final bool strokePaintingStyle;
  final bool weightedStrokes;
  final double minStroke;
  final double maxStroke;
  final Color pointsColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (showVoronoiPolygons) {
      final cells = relaxation.voronoi.cells;
      for (int j = 0; j < cells.length; j++) {
        final path = Path()..moveTo(cells[j][0].dx, cells[j][0].dy);
        for (int i = 1; i < cells[j].length; i++) {
          path.lineTo(cells[j][i].dx, cells[j][i].dy);
        }
        path.close();

        if (paintColors) {
          canvas.drawPath(
            path,
            Paint()..color = Color(relaxation.colors[j]),
          );
        }
        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.black,
        );
      }
    }

    if (showPoints && !showVoronoiPolygons) {
      for (int i = 0; i < relaxation.coords.length; i += 2) {
        double stroke = pointStrokeWidth;
        if (weightedStrokes) {
          stroke =
              map(relaxation.strokeWeights[i ~/ 2], 0, 1, minStroke, maxStroke);
        }
        final color =
            paintColors ? Color(relaxation.colors[i ~/ 2]) : pointsColor;
        final paint = Paint()..color = color;
        if (strokePaintingStyle) {
          paint
            ..style = PaintingStyle.stroke
            ..strokeWidth = stroke * 0.15;
        }
        canvas.drawCircle(
          Offset(relaxation.coords[i], relaxation.coords[i + 1]),
          stroke / 2,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
