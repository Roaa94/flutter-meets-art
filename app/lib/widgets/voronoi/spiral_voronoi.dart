import 'dart:math';
import 'dart:typed_data';

import 'package:app/algorithms/delaunay.dart';
import 'package:app/algorithms/voronoi.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';

class SpiralVoronoi extends StatelessWidget {
  const SpiralVoronoi({
    super.key,
    required this.size,
    this.pointsCount = 1400,
    this.angleIncrement = 18,
    this.radiusIncrement = 1,
  });

  final Size size;
  final int pointsCount;
  final double angleIncrement;
  final double radiusIncrement;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: SpiralVoronoiPainter(
          seedPoints: generateSpiralPoints(
            pointsCount: pointsCount,
            angleIncrement: angleIncrement,
            radiusIncrement: radiusIncrement,
            center: Offset(size.width / 2, size.height / 2),
            bounds: size,
          ),
        ),
      ),
    );
  }
}

class SpiralVoronoiPainter extends CustomPainter {
  SpiralVoronoiPainter({
    required this.seedPoints,
  });

  final Float32List seedPoints;

  @override
  void paint(Canvas canvas, Size size) {
    final delaunay = Delaunay(seedPoints);
    delaunay.update();

    final colors = generateIncrementalHSLColors(
      seedPoints.length,
      initialHue: 350,
      saturation: 0.6,
    );

    final Voronoi voronoi = delaunay.voronoi(
      const Point(0, 0),
      Point(size.width, size.height),
    );

    final cells = voronoi.cells;
    for (int j = 0; j < cells.length; j++) {
      final path = Path()..moveTo(cells[j][0].dx, cells[j][0].dy);
      for (int i = 1; i < cells[j].length; i++) {
        path.lineTo(cells[j][i].dx, cells[j][i].dy);
      }
      path.close();

      canvas.drawPath(
        path,
        Paint()..color = colors[j],
      );

      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = colors[j],
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
