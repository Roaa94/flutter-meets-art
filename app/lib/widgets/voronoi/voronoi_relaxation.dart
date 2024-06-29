import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app/delaunay/delaunay.dart';
import 'package:app/delaunay/voronoi.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class VoronoiRelaxation extends StatefulWidget {
  const VoronoiRelaxation({
    super.key,
    required this.size,
    this.pointsCount = 100,
    this.animate = false,
    this.showCentroids = false,
    this.showPolygons = true,
  });

  final Size size;
  final int pointsCount;
  final bool animate;
  final bool showCentroids;
  final bool showPolygons;

  @override
  State<VoronoiRelaxation> createState() => _VoronoiRelaxationState();
}

class _VoronoiRelaxationState extends State<VoronoiRelaxation>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final random = Random(3);

  late Float32List points;
  late Float32List centroids;
  late Delaunay delaunay;
  late Voronoi voronoi;

  void _calculate() {
    delaunay = Delaunay(points);
    delaunay.update();
    voronoi = delaunay.voronoi(
      const Point(0, 0),
      Point(widget.size.width, widget.size.height),
    );
    centroids = calcCentroids(voronoi.cells);
  }

  void _update() {
    points = lerpPoints(points, centroids, 0.01);
    _calculate();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    points = generateRandomPoints(
      random: random,
      canvasSize: widget.size,
      count: widget.pointsCount,
    );
    _calculate();
    _ticker = createTicker((_) => _update());
    if (widget.animate) {
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: VoronoiCustomPainter(
        delaunay: delaunay,
        voronoi: voronoi,
        centroids: centroids,
        points: points,
        showCentroids: widget.showCentroids,
        showPolygons: widget.showPolygons,
      ),
    );
  }
}

class VoronoiCustomPainter extends CustomPainter {
  VoronoiCustomPainter({
    required this.points,
    required this.centroids,
    required this.voronoi,
    required this.delaunay,
    this.showCentroids = false,
    this.showPolygons = false,
  });

  final Float32List points;
  final Float32List centroids;
  final Delaunay delaunay;
  final Voronoi voronoi;
  final bool showCentroids;
  final bool showPolygons;

  final random = Random(3);

  @override
  void paint(Canvas canvas, Size size) {
    final coords = delaunay.coords;
    final cells = voronoi.cells;

    // Original points
    canvas.drawRawPoints(
      PointMode.points,
      coords,
      Paint()
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..color = Colors.black,
    );

    // Voronoi cells
    if (showPolygons) {
      for (int j = 0; j < cells.length; j++) {
        final path = Path()..moveTo(cells[j][0].dx, cells[j][0].dy);
        for (int i = 1; i < cells[j].length; i++) {
          path.lineTo(cells[j][i].dx, cells[j][i].dy);
        }
        path.close();
        canvas.drawPath(
          path,
          Paint()
            ..strokeWidth = 3
            ..style = PaintingStyle.stroke
            ..color = Colors.black,
        );
      }
    }

    if (showCentroids) {
      for (int i = 0; i < centroids.length; i += 2) {
        final centroid = Offset(centroids[i], centroids[i + 1]);
        canvas.drawCircle(
          centroid,
          7,
          Paint()..color = Colors.red,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
