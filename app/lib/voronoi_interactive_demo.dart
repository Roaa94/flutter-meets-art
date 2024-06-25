import 'dart:math';
import 'dart:ui';

import 'package:app/utils.dart';
import 'package:flutter/material.dart';

import 'delaunay.dart';

class VoronoiInteractiveDemo extends StatelessWidget {
  const VoronoiInteractiveDemo({
    super.key,
    this.pointsCount = 100,
    this.showPoints = false,
    this.showDelaunayTriangles = false,
    this.showCircumcircles = false,
    this.showVoronoiPolygons = false,
    this.fillVoronoiPolygons = false,
  });

  final int pointsCount;
  final bool showPoints;
  final bool showDelaunayTriangles;
  final bool showCircumcircles;
  final bool showVoronoiPolygons;
  final bool fillVoronoiPolygons;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class VoronoiInteractiveDemoPainter extends CustomPainter {
  VoronoiInteractiveDemoPainter({
    required this.random,
    this.pointsCount = 100,
  });

  final Random random;
  final int pointsCount;

  @override
  void paint(Canvas canvas, Size size) {
    final seedPoints = generateRandomPoints(
      random: random,
      canvasSize: size,
      count: pointsCount,
    );
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

      canvas.drawPath(
        Path()
          ..moveTo(x.x, x.y)
          ..lineTo(y.x, y.y)
          ..lineTo(z.x, z.y)
          ..close(),
        Paint()..color = Colors.black,
      );

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

    canvas.drawRawPoints(
      PointMode.points,
      coords,
      Paint()
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round
        ..color = Colors.black,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
