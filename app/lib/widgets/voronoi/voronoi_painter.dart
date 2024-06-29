import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app/delaunay/delaunay.dart';
import 'package:app/delaunay/voronoi.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';

class VoronoiPainter extends CustomPainter {
  VoronoiPainter({
    required this.seedPoints,
    this.colors,
    this.showSeedPoints = false,
    this.paintDelaunayTriangles = false,
    this.paintCircumcircles = false,
    this.paintVoronoiPolygonEdges = false,
    this.paintVoronoiPolygonFills = false,
  });

  final Float32List seedPoints;
  final List<Color>? colors;
  final bool showSeedPoints;
  final bool paintDelaunayTriangles;
  final bool paintCircumcircles;
  final bool paintVoronoiPolygonEdges;
  final bool paintVoronoiPolygonFills;

  @override
  void paint(Canvas canvas, Size size) {
    final delaunay = Delaunay(seedPoints);
    delaunay.update();

    final Voronoi voronoi = delaunay.voronoi(
      const Point(0, 0),
      Point(size.width, size.height),
    );

    final coords = delaunay.coords;
    final triangles = delaunay.triangles;

    for (int i = 0; i < triangles.length; i += 3) {
      final t1 = triangles[i];
      final t2 = triangles[i + 1];
      final t3 = triangles[i + 2];

      final x = delaunay.getPoint(t1);
      final y = delaunay.getPoint(t2);
      final z = delaunay.getPoint(t3);

      if (paintDelaunayTriangles) {
        canvas.drawPath(
          Path()
            ..moveTo(x.x, x.y)
            ..lineTo(y.x, y.y)
            ..lineTo(z.x, z.y)
            ..close(),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = paintVoronoiPolygonEdges ? Colors.pink : Colors.black,
        );
      }

      if (paintCircumcircles) {
        final (circumcenter, circumradius) =
            calculateCircumcenterAndRadius(x.x, x.y, y.x, y.y, z.x, z.y);
        canvas.drawCircle(
          Offset(circumcenter.x, circumcenter.y),
          circumradius,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4
            ..color = Colors.pink,
        );
      }
    }

    if (paintVoronoiPolygonEdges || paintVoronoiPolygonFills) {
      final cells = voronoi.cells;
      for (int j = 0; j < cells.length; j++) {
        final path = Path()..moveTo(cells[j][0].dx, cells[j][0].dy);
        for (int i = 1; i < cells[j].length; i++) {
          path.lineTo(cells[j][i].dx, cells[j][i].dy);
        }
        path.close();

        if (paintVoronoiPolygonFills && colors != null) {
          canvas.drawPath(
            path,
            Paint()..color = colors![j],
          );
        }

        if (paintVoronoiPolygonEdges) {
          canvas.drawPath(
            path,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = Colors.black,
          );
        }
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
    return false;
  }
}
