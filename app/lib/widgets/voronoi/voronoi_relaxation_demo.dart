import 'dart:math';
import 'dart:ui';

import 'package:app/algorithms/voronoi_relaxation.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class VoronoiRelaxationDemo extends StatefulWidget {
  const VoronoiRelaxationDemo({
    super.key,
    required this.size,
    this.pointsCount = 100,
    this.animate = false,
    this.showCentroids = true,
    this.showPolygons = true,
  });

  final Size size;
  final int pointsCount;
  final bool animate;
  final bool showCentroids;
  final bool showPolygons;

  @override
  State<VoronoiRelaxationDemo> createState() => _VoronoiRelaxationDemoState();
}

class _VoronoiRelaxationDemoState extends State<VoronoiRelaxationDemo>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final random = Random(3);

  VoronoiRelaxation? _relaxation;

  void _update() {
    _relaxation?.update(0.1);
    setState(() {});
  }

  void _init() {
    final points = generateRandomPoints(
      random: random,
      canvasSize: widget.size,
      count: widget.pointsCount,
    );
    _relaxation = VoronoiRelaxation(
      points,
      min: const Point(0, 0),
      max: Point(widget.size.width, widget.size.height),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
    _ticker = createTicker((_) => _update());
    if (widget.animate) {
      _ticker.start();
    }
  }

  @override
  void didUpdateWidget(covariant VoronoiRelaxationDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_relaxation == null) {
      return Container();
    }
    return CustomPaint(
      painter: VoronoiCustomPainter(
        relaxation: _relaxation!,
        showCentroids: widget.showCentroids,
        showPolygons: widget.showPolygons,
      ),
    );
  }
}

class VoronoiCustomPainter extends CustomPainter {
  VoronoiCustomPainter({
    required this.relaxation,
    this.showCentroids = false,
    this.showPolygons = false,
  });

  final VoronoiRelaxation relaxation;
  final bool showCentroids;
  final bool showPolygons;

  final random = Random(3);

  @override
  void paint(Canvas canvas, Size size) {
    // Original points
    canvas.drawRawPoints(
      PointMode.points,
      relaxation.coords,
      Paint()
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..color = Colors.black,
    );

    // Voronoi cells
    if (showPolygons) {
      final cells = relaxation.voronoi.cells;
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
      final centroids = relaxation.centroids;
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
