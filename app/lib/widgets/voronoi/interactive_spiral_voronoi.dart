import 'dart:math';
import 'dart:typed_data';

import 'package:app/algorithms/delaunay.dart';
import 'package:app/algorithms/voronoi.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';

class InteractiveSpiralVoronoi extends StatefulWidget {
  const InteractiveSpiralVoronoi({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<InteractiveSpiralVoronoi> createState() =>
      _InteractiveSpiralVoronoiState();
}

class _InteractiveSpiralVoronoiState extends State<InteractiveSpiralVoronoi> {
  Offset _mouseOffset = Offset.zero;
  final pointsCount = 1400;
  final radiusIncrement = 1.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: MouseRegion(
        onEnter: (event) => setState(() => _mouseOffset = event.localPosition),
        onHover: (event) => setState(() => _mouseOffset = event.localPosition),
        child: CustomPaint(
          painter: InteractiveSpiralVoronoiPainter(
            seedPoints: generateSpiralPoints(
              pointsCount: pointsCount,
              angleIncrement: 10,
              radiusIncrement: 1,
              center: _mouseOffset,
              bounds: widget.size,
            ),
          ),
        ),
      ),
    );
  }
}

class InteractiveSpiralVoronoiPainter extends CustomPainter {
  InteractiveSpiralVoronoiPainter({
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
    return true;
  }
}
