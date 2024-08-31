import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:playground/algorithms/delaunay.dart';
import 'package:playground/algorithms/voronoi.dart';
import 'package:playground/utils/math_utils.dart';

class VoronoiPainter extends CustomPainter {
  VoronoiPainter({
    required this.seedPoints,
    this.colors,
    this.showSeedPoints = false,
    this.paintDelaunayTriangles = false,
    this.paintCircumcircles = false,
    this.paintVoronoiPolygonEdges = false,
    this.paintVoronoiPolygonFills = false,
    this.useVertexMode = false,
  });

  final Float32List seedPoints;
  final List<Color>? colors;
  final bool showSeedPoints;
  final bool paintDelaunayTriangles;
  final bool paintCircumcircles;
  final bool paintVoronoiPolygonEdges;
  final bool paintVoronoiPolygonFills;
  final bool useVertexMode;

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
            ..color = Colors.black,
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

    final cells = voronoi.cells;
    if (paintVoronoiPolygonFills && useVertexMode) {
      final (colorsRaw, vertices) = getVoronoiVertices(cells, colors);

      final verticesRaw = Vertices.raw(
        VertexMode.triangles,
        vertices,
        colors: colorsRaw,
      );
      canvas.drawVertices(verticesRaw, BlendMode.src, Paint());
    }

    if (paintVoronoiPolygonEdges ||
        (paintVoronoiPolygonFills && !useVertexMode)) {
      for (int j = 0; j < cells.length; j++) {
        final path = Path()..moveTo(cells[j][0].dx, cells[j][0].dy);
        for (int i = 1; i < cells[j].length; i++) {
          path.lineTo(cells[j][i].dx, cells[j][i].dy);
        }
        path.close();

        if (!useVertexMode && paintVoronoiPolygonFills && colors != null) {
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
              ..color = paintDelaunayTriangles
                  ? const Color(0xff35aee7)
                  : Colors.black,
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

(Int32List colors, Float32List vertices) getVoronoiVertices(
  List<List<Offset>> cells,
  List<Color>? colors,
) {
  List<Offset> triangles = [];
  List<int> verticesColors = [];
  // Loop through each cell and color
  for (int cellIndex = 0; cellIndex < cells.length; cellIndex++) {
    List<Offset> cell = cells[cellIndex];
    Color color = colors != null ? colors[cellIndex] : Colors.pink;

    if (cell.length < 3) {
      continue; // Skip if not enough points to form a triangle
    }

    // Take the first point as the common point in the fan
    Offset first = cell[0];

    // Create triangles and assign color
    for (int i = 1; i < cell.length - 1; i++) {
      triangles.add(first);
      triangles.add(cell[i]);
      triangles.add(cell[i + 1]);

      // Assign the same color to each vertex of the triangle
      int colorValue = color.value;
      verticesColors.add(colorValue);
      verticesColors.add(colorValue);
      verticesColors.add(colorValue);
    }
  }
  // Convert the list of Offsets to Float32List
  final vertices = Float32List(triangles.length * 2);
  for (int i = 0; i < triangles.length; i++) {
    vertices[i * 2] = triangles[i].dx;
    vertices[i * 2 + 1] = triangles[i].dy;
  }

  // Create color data for each vertex
  final colorsRaw = Int32List.fromList(verticesColors);
  return (colorsRaw, vertices);
}
