import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app/algorithms/delaunay.dart';
import 'package:app/algorithms/voronoi.dart';
import 'package:app/utils/color_utils.dart';
import 'package:app/utils/painting_utils.dart';
import 'package:flutter/material.dart';

class GridVoronoi extends StatelessWidget {
  const GridVoronoi({
    super.key,
    required this.size,
    this.cellIncrementFactor = 0.1,
    this.cellSize = 50,
    this.colored = false,
    this.paintSeedPoints = true,
    this.paintVoronoiEdges = true,
  }) : assert(cellIncrementFactor <= 1.0 && cellIncrementFactor > 0);

  final Size size;
  final double cellIncrementFactor;
  final double cellSize;
  final bool colored;
  final bool paintSeedPoints;
  final bool paintVoronoiEdges;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: GridVoronoiPainter(
          seedPoints: generateGridPoints(
            canvasSize: size,
            cellSize: cellSize,
            cellIncrementFactor: cellIncrementFactor,
          ),
          colored: colored,
          paintSeedPoints: paintSeedPoints,
          paintVoronoiEdges: paintVoronoiEdges,
        ),
      ),
    );
  }
}

class GridVoronoiPainter extends CustomPainter {
  GridVoronoiPainter({
    required this.seedPoints,
    this.colored = false,
    this.paintSeedPoints = true,
    this.paintVoronoiEdges = true,
  });

  final Float32List seedPoints;
  final bool colored;
  final bool paintSeedPoints;
  final bool paintVoronoiEdges;

  @override
  void paint(Canvas canvas, Size size) {
    final delaunay = Delaunay(seedPoints);
    delaunay.update();

    final colors = generateIncrementalHSLColors(
      seedPoints.length,
      initialHue: 360,
      saturation: 0.5,
    );

    final Voronoi voronoi = delaunay.voronoi(
      const Point(0, 0),
      Point(size.width, size.height),
    );

    if (paintVoronoiEdges) {
      final cells = voronoi.cells;
      for (int j = 0; j < cells.length; j++) {
        final path = Path()..moveTo(cells[j][0].dx, cells[j][0].dy);
        for (int i = 1; i < cells[j].length; i++) {
          path.lineTo(cells[j][i].dx, cells[j][i].dy);
        }
        path.close();

        if (colored) {
          canvas.drawPath(
            path,
            Paint()..color = colors[j],
          );
        }

        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..color = Colors.black,
        );
      }
    }

    if (paintSeedPoints) {
      canvas.drawRawPoints(
        PointMode.points,
        delaunay.coords,
        Paint()
          ..strokeWidth = 10
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
