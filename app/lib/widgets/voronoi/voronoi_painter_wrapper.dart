import 'dart:math';
import 'dart:typed_data';

import 'package:app/utils.dart';
import 'package:app/widgets/voronoi/voronoi_painter.dart';
import 'package:flutter/material.dart';

class VoronoiPainterWrapper extends StatefulWidget {
  const VoronoiPainterWrapper({
    super.key,
    required this.size,
    this.pointsCount = 5,
    this.showSeedPoints = false,
    this.showDelaunayTriangles = false,
    this.showCircumcircles = false,
    this.showVoronoiPolygons = false,
    this.fillVoronoiPolygons = false,
  });

  final Size size;
  final int pointsCount;
  final bool showSeedPoints;
  final bool showDelaunayTriangles;
  final bool showCircumcircles;
  final bool showVoronoiPolygons;
  final bool fillVoronoiPolygons;

  @override
  State<VoronoiPainterWrapper> createState() => _VoronoiPainterWrapperState();
}

class _VoronoiPainterWrapperState extends State<VoronoiPainterWrapper> {
  late Float32List _seedPoints;
  final random = Random(3);

  void _generatePoints() {
    _seedPoints = generateRandomPoints(
      random: random,
      canvasSize: widget.size,
      count: widget.pointsCount,
    );
  }

  void _handlePointsCountChange() {
    _generatePoints();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _generatePoints();
  }

  @override
  void didUpdateWidget(covariant VoronoiPainterWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pointsCount != oldWidget.pointsCount) {
      _handlePointsCountChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: CustomPaint(
        painter: VoronoiPainter(
          random: random,
          seedPoints: _seedPoints,
          showSeedPoints: widget.showSeedPoints,
          showDelaunayTriangles: widget.showDelaunayTriangles,
          showCircumcircles: widget.showCircumcircles,
          showVoronoiPolygons: widget.showVoronoiPolygons,
          fillVoronoiPolygons: widget.fillVoronoiPolygons,
        ),
      ),
    );
  }
}
