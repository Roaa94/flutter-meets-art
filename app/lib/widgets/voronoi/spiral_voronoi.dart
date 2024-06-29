import 'dart:math';
import 'dart:typed_data';

import 'package:app/delaunay/delaunay.dart';
import 'package:app/delaunay/voronoi.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';

class SpiralVoronoi extends StatelessWidget {
  const SpiralVoronoi({
    super.key,
    required this.size,
    this.pointsCount = 1400,
    this.angelIncrement = 18,
    this.radiusIncrement = 1,
  });

  final Size size;
  final int pointsCount;
  final double angelIncrement;
  final double radiusIncrement;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: SpiralVoronoiPainter(
          seedPoints: generateSpiralPoints(
            pointsCount: pointsCount,
            angleIncrement: angelIncrement,
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
      initialHue: 360,
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

      // canvas.drawPath(
      //   path,
      //   Paint()
      //     ..style = PaintingStyle.stroke
      //     ..strokeWidth = 3
      //     ..color = Colors.black,
      // );
    }

    // canvas.drawRawPoints(
    //   PointMode.points,
    //   delaunay.coords,
    //   Paint()
    //     ..strokeWidth = 12
    //     ..strokeCap = StrokeCap.round
    //     ..color = Colors.black,
    // );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
