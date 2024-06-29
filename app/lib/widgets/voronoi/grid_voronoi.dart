import 'dart:math';
import 'dart:typed_data';

import 'package:app/delaunay/delaunay.dart';
import 'package:app/delaunay/voronoi.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';

class GridVoronoi extends StatelessWidget {
  const GridVoronoi({
    super.key,
    required this.size,
    this.cellIncrementFactor = 0.1,
    this.cellSize = 50,
  }) : assert(cellIncrementFactor <= 1.0 && cellIncrementFactor > 0);

  final Size size;
  final double cellIncrementFactor;
  final double cellSize;

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
        ),
      ),
    );
  }
}

class GridVoronoiPainter extends CustomPainter {
  GridVoronoiPainter({
    required this.seedPoints,
  });

  final Float32List seedPoints;

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
          ..strokeWidth = 3
          ..color = Colors.black,
      );
    }

    // canvas.drawRawPoints(
    //   PointMode.points,
    //   delaunay.coords,
    //   Paint()
    //     ..strokeWidth = 12
    //     ..strokeCap = StrokeCap.round
    //     ..color = Colors.black,
    // );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
