import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app/delaunay/delaunay.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';

class VoronoiPainter extends CustomPainter {
  VoronoiPainter({
    required this.random,
    required this.seedPoints,
    this.showSeedPoints = false,
    this.showDelaunayTriangles = false,
    this.showCircumcircles = false,
    this.showVoronoiPolygons = false,
    this.fillVoronoiPolygons = false,
  });

  final Random random;
  final Float32List seedPoints;
  final bool showSeedPoints;
  final bool showDelaunayTriangles;
  final bool showCircumcircles;
  final bool showVoronoiPolygons;
  final bool fillVoronoiPolygons;

  @override
  void paint(Canvas canvas, Size size) {
    final delaunay = Delaunay(seedPoints);
    delaunay.update();
    final coords = delaunay.coords;
    final triangles = delaunay.triangles;

    for (int i = 0; i < triangles.length; i += 3) {
      final t1 = triangles[i];
      final t2 = triangles[i + 1];
      final t3 = triangles[i + 2];

      final x = delaunay.getPoint(t1);
      final y = delaunay.getPoint(t2);
      final z = delaunay.getPoint(t3);

      if (showDelaunayTriangles) {
        canvas.drawPath(
          Path()
            ..moveTo(x.x, x.y)
            ..lineTo(y.x, y.y)
            ..lineTo(z.x, z.y)
            ..close(),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = Colors.black,
        );
      }

      if (showCircumcircles) {
        final (circumcenter, circumradius) =
            calculateCircumcenterAndRadius(x.x, x.y, y.x, y.y, z.x, z.y);
        canvas.drawCircle(
          Offset(circumcenter.x, circumcenter.y),
          circumradius,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1
            ..color = Colors.red,
        );
      }
    }

    final voronoi = delaunay.voronoi(
      const Point(0, 0),
      Point(size.width, size.height),
    );

    if (showVoronoiPolygons) {
      for (int j = 0; j < voronoi.cells.length; j++) {
        final path = Path()
          ..moveTo(voronoi.cells[j][0].dx, voronoi.cells[j][0].dy);
        for (int i = 1; i < voronoi.cells[j].length; i++) {
          path.lineTo(voronoi.cells[j][i].dx, voronoi.cells[j][i].dy);
        }
        path.close();

        if (fillVoronoiPolygons) {
          canvas.drawPath(
            path,
            Paint()..color = Colors.pink.shade100,
          );
        }

        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..color = Colors.pink,
        );
      }
    }

    if (showSeedPoints) {
      canvas.drawRawPoints(
        PointMode.points,
        coords,
        Paint()
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round
          ..color = Colors.black,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
