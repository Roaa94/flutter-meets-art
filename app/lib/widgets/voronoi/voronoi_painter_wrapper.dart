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
    this.paintDelaunayTriangles = false,
    this.paintCircumcircles = false,
    this.paintVoronoiPolygonEdges = false,
    this.paintVoronoiPolygonFills = false,
  });

  final Size size;
  final int pointsCount;
  final bool showSeedPoints;
  final bool paintDelaunayTriangles;
  final bool paintCircumcircles;
  final bool paintVoronoiPolygonEdges;
  final bool paintVoronoiPolygonFills;

  @override
  State<VoronoiPainterWrapper> createState() => _VoronoiPainterWrapperState();
}

class _VoronoiPainterWrapperState extends State<VoronoiPainterWrapper> {
  late Float32List _seedPoints;
  late List<Color> _colors;
  final random = Random(5);

  void _generatePoints() {
    _seedPoints = generateRandomPoints(
      random: random,
      canvasSize: widget.size,
      count: widget.pointsCount,
    );
    _colors = generateRandomColors(
      random,
      _seedPoints.length,
      randomHue: false,
      randomLightness: true,
      initialHue: 310,
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
          colors: _colors,
          seedPoints: _seedPoints,
          showSeedPoints: widget.showSeedPoints,
          paintDelaunayTriangles: widget.paintDelaunayTriangles,
          paintCircumcircles: widget.paintCircumcircles,
          paintVoronoiPolygonEdges: widget.paintVoronoiPolygonEdges,
          paintVoronoiPolygonFills: widget.paintVoronoiPolygonFills,
        ),
      ),
    );
  }
}
