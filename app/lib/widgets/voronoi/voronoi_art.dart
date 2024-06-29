import 'dart:math';

import 'package:app/delaunay/delaunay.dart';
import 'package:app/delaunay/voronoi.dart';
import 'package:app/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VoronoiArtPage extends StatelessWidget {
  const VoronoiArtPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: VoronoiArt(size: screenSize),
    );
  }
}

class VoronoiArt extends StatefulWidget {
  const VoronoiArt({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<VoronoiArt> createState() => _VoronoiArtState();
}

class _VoronoiArtState extends State<VoronoiArt> {
  late Float32List _seedPoints;
  late List<Color> _colors;
  final random = Random(5);

  void _generatePoints() {
    _seedPoints = generateRandomPoints(
      random: random,
      canvasSize: widget.size,
      count: 20,
    );
    _colors = generateRandomColors(
      random,
      _seedPoints.length,
      randomHue: false,
      randomLightness: true,
      initialHue: 310,
    );
  }

  @override
  void initState() {
    super.initState();
    _generatePoints();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: VoronoiPainter(
          seedPoints: _seedPoints,
          colors: _colors,
        ),
      ),
    );
  }
}

class VoronoiPainter extends CustomPainter {
  VoronoiPainter({
    required this.seedPoints,
    this.colors,
  });

  final Float32List seedPoints;
  final List<Color>? colors;

  @override
  void paint(Canvas canvas, Size size) {
    final delaunay = Delaunay(seedPoints);
    delaunay.update();

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

      // if (paintVoronoiPolygonFills && colors != null) {
      //   canvas.drawPath(
      //     path,
      //     Paint()..color = colors![j],
      //   );
      // }

      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = Colors.black,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
