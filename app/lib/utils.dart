import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app/delaunay/delaunay.dart';
import 'package:flutter/material.dart';

int rgbaToArgb(int rgbaColor) {
  return ((rgbaColor & 0x000000FF) << 24) | ((rgbaColor & 0xFFFFFF00) >> 8);
}

List<HSLColor> generateRandomHSLColors(
  Random random,
  int n, {
  bool randomHue = true,
  bool randomSaturation = false,
  bool randomLightness = false,
  double initialHue = 360.0,
}) {
  return List<HSLColor>.generate(n, (index) {
    return HSLColor.fromAHSL(
      1.0, // Opacity
      // from 0 to 360
      randomHue ? random.nextDouble() * initialHue : initialHue,
      // from 0 to 1, default should be 1
      randomSaturation ? random.nextDouble() : 1.0,
      // from 0 to 1, default should be 0.5
      randomLightness ? random.nextDouble() : 0.5,
    );
  });
}

List<Color> generateIncrementalHSLColors(
  int n, {
  double initialHue = 360.0,
  double saturation = 1.0,
}) {
  return List<Color>.generate(n, (index) {
    return HSLColor.fromAHSL(
      1.0, // Opacity
      // from 0 to 360
      initialHue * (1 - (index / n)),
      // from 0 to 1, default should be 1
      saturation,
      // from 0 to 1, default should be 0.5
      // 0.5 * (1 - (index / n)),
      0.5,
    ).toColor();
  });
}

List<Color> generateAlternatingColors(
  int n,
  Color color1,
  Color color2,
) {
  final list = <Color>[];
  for (int i = 0; i < n; i += 2) {
    list.addAll([color1, color2]);
  }
  return list;
}

List<Color> generateIncrementalColors(int n, {double initialHue = 360.0}) {
  return List<Color>.generate(n, (index) {
    return Color.fromARGB(
      255,
      (255 * (index / n)).toInt(),
      0,
      0,
    );
  });
}

List<Color> generateRandomColors(
  Random random,
  int n, {
  bool randomHue = true,
  bool randomSaturation = false,
  bool randomLightness = false,
  double initialHue = 360.0,
}) {
  return List<Color>.generate(n, (index) {
    return HSLColor.fromAHSL(
      1.0, // Opacity
      // from 0 to 360
      randomHue ? random.nextDouble() * initialHue : initialHue,
      // from 0 to 1, default should be 1
      randomSaturation ? random.nextDouble() : 1.0,
      // from 0 to 1, default should be 0.5
      randomLightness ? random.nextDouble() : 0.5,
    ).toColor();
  });
}

List<Offset> generateVertexOffsets(
  int length,
  double width, {
  bool transposed = false,
}) {
  final offsets = List<Offset>.filled(length * 6, Offset.zero);
  for (int i = 0; i < length; i++) {
    double x = i % width;
    double y = i / width;
    const pixelSize = 1.0;
    final left = transposed ? y : x;
    final top = transposed ? x : y;
    final bottom = top + pixelSize;
    final right = left + pixelSize;

    final topLeft = Offset(left, top);
    final topRight = Offset(right, top);
    final bottomRight = Offset(right, bottom);
    final bottomLeft = Offset(left, bottom);

    offsets[6 * i] = topLeft;
    offsets[6 * i + 1] = topRight;
    offsets[6 * i + 2] = bottomRight;
    offsets[6 * i + 3] = bottomRight;
    offsets[6 * i + 4] = bottomLeft;
    offsets[6 * i + 5] = topLeft;
  }
  return offsets;
}

Float32List generateVerticesRaw(
  int length,
  int width, {
  bool transposed = false,
}) {
  final coords = Float32List(length * 6 * 2);
  for (int i = 0; i < length; i++) {
    int col = i % width;
    int row = i ~/ width;
    const pixelSize = 1.0;
    final left = transposed ? row.toDouble() : col.toDouble();
    final top = transposed ? col.toDouble() : row.toDouble();
    final bottom = top + pixelSize;
    final right = left + pixelSize;

    final topLeft = Offset(left, top);
    final topRight = Offset(right, top);
    final bottomRight = Offset(right, bottom);
    final bottomLeft = Offset(left, bottom);

    coords[12 * i + 0] = topLeft.dx;
    coords[12 * i + 1] = topLeft.dy;
    coords[12 * i + 2] = topRight.dx;
    coords[12 * i + 3] = topRight.dy;
    coords[12 * i + 4] = bottomRight.dx;
    coords[12 * i + 5] = bottomRight.dy;
    coords[12 * i + 6] = bottomRight.dx;
    coords[12 * i + 7] = bottomRight.dy;
    coords[12 * i + 8] = bottomLeft.dx;
    coords[12 * i + 9] = bottomLeft.dy;
    coords[12 * i + 10] = topLeft.dx;
    coords[12 * i + 11] = topLeft.dy;
  }
  return coords;
}

Float32List generateRandomPoints({
  required Random random,
  required Size canvasSize,
  required int count,
  double padding = 10,
}) {
  final points = Float32List(count * 2);
  for (int i = 0; i < points.length; i += 2) {
    points[i] =
        padding + random.nextDouble() * (canvasSize.width - padding * 2);
    points[i + 1] =
        padding + random.nextDouble() * (canvasSize.height - padding * 2);
  }
  return points;
}

void paintDelaunay({
  required Canvas canvas,
  required Size size,
  required Random random,
  required int pointsCount,
}) {
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

(Point<double>, double) calculateCircumcenterAndRadius(
  double x1,
  double y1,
  double x2,
  double y2,
  double x3,
  double y3,
) {
  final double dx = x2 - x1;
  final double dy = y2 - y1;
  final double ex = x3 - x1;
  final double ey = y3 - y1;

  final ab = (dx * ey - dy * ex) * 2;

  if (ab.abs() < 1e-9) {
    final cx = (x1 + x2 + x3) / 3;
    final cy = (y1 + y2 + y3) / 3;
    return (Point<double>(cx, cy), 0);
  }

  final double bl = dx * dx + dy * dy;
  final double cl = ex * ex + ey * ey;
  final double d = 0.5 / (dx * ey - dy * ex);

  final double x = x1 + (ey * bl - dy * cl) * d;
  final double y = y1 + (dx * cl - ex * bl) * d;

  // Circumradius: Calculate the distance from the circumcenter
  // to one of the vertices
  final double dx1 = x - x1;
  final double dy1 = y - y1;

  final circumradius = sqrt(dx1 * dx1 + dy1 * dy1);

  return (Point<double>(x, y), circumradius);
}

Float32List reflectRawPoints({
  required Float32List originalPoints,
  required Size bounds,
}) {
  final int length = originalPoints.length;
  final Float32List reflectedPoints = Float32List(length * 5);

  for (int i = 0; i < length; i += 2) {
    final double x = originalPoints[i];
    final double y = originalPoints[i + 1];

    // Original point
    reflectedPoints[i] = x;
    reflectedPoints[i + 1] = y;

    // Top reflection
    reflectedPoints[length + i] = x;
    reflectedPoints[length + i + 1] = -y;

    // Bottom reflection
    reflectedPoints[2 * length + i] = x;
    reflectedPoints[2 * length + i + 1] = 2 * bounds.height - y;

    // Left reflection
    reflectedPoints[3 * length + i] = -x;
    reflectedPoints[3 * length + i + 1] = y;

    // Right reflection
    reflectedPoints[4 * length + i] = 2 * bounds.width - x;
    reflectedPoints[4 * length + i + 1] = y;
  }

  return reflectedPoints;
}

Point<double> calculateCircumcenter(
  double x1,
  double y1,
  double x2,
  double y2,
  double x3,
  double y3,
) {
  final double dx = x2 - x1;
  final double dy = y2 - y1;
  final double ex = x3 - x1;
  final double ey = y3 - y1;

  final ab = (dx * ey - dy * ex) * 2;

  if (ab.abs() < 1e-9) {
    final cx = (x1 + x2 + x3) / 3;
    final cy = (y1 + y2 + y3) / 3;
    return Point<double>(cx, cy);
  }

  final double bl = dx * dx + dy * dy;
  final double cl = ex * ex + ey * ey;
  final double d = 0.5 / (dx * ey - dy * ex);

  final double x = x1 + (ey * bl - dy * cl) * d;
  final double y = y1 + (dx * cl - ex * bl) * d;

  return Point<double>(x, y);
}

Float32List generateSpiralPoints({
  int pointsCount = 10,
  double radiusIncrement = 1,
  double angleIncrement = 1,
  Offset center = Offset.zero,
  required Size bounds,
}) {
  final List<double> points = [];
  double radius = 0.0;
  double angle = 0.0;

  for (int i = 0; i < pointsCount; i++) {
    final double x = center.dx + radius * cos(angle);
    final double y = center.dy + radius * sin(angle);

    // Check if the point is within the bounds
    if (x >= 0 && x <= bounds.width && y >= 0 && y <= bounds.height) {
      points.add(x);
      points.add(y);
    }

    radius += radiusIncrement;
    angle += angleIncrement;
  }

  return Float32List.fromList(points);
}

Float32List generateGridPoints({
  required Size canvasSize,
  double cellSize = 50,
  double cellIncrementFactor = 0.1,
}) {
  final list = <double>[];
  final cols = (canvasSize.width / cellSize).floor();
  final rows = (canvasSize.height / cellSize).floor();

  for (int row = 0; row < rows; row++) {
    for (int col = 0; col < cols; col++) {
      final centerX = col * cellSize +
          cellSize / 2 +
          (row.isOdd ? cellSize * cellIncrementFactor : 0);
      final centerY = row * cellSize +
          cellSize / 2 +
          (col.isOdd ? cellSize * cellIncrementFactor : 0);
      list.addAll([centerX, centerY]);
    }
  }

  return Float32List.fromList(list);
}

Float32List calcCentroids(List<List<Offset>> cells, {bool precise = true}) {
  final centroids = Float32List(cells.length * 2);
  for (int i = 0; i < cells.length * 2; i += 2) {
    final centroid = calcCentroid(cells[i ~/ 2]);
    centroids[i] = centroid.dx;
    centroids[i + 1] = centroid.dy;
  }
  return centroids;
}

Offset calcCentroid(List<Offset> cell, {bool precise = true}) {
  Offset centroid = Offset.zero;
  double area = 0.0;
  for (int i = 0; i < cell.length; i++) {
    if (precise) {
      final v0 = cell[i];
      final v1 = cell[(i + 1) % cell.length];
      final crossValue = v0.dx * v1.dy - v1.dx * v0.dy;
      area += crossValue;
      centroid += Offset(
        (v0.dx + v1.dx) * crossValue,
        (v0.dy + v1.dy) * crossValue,
      );
    } else {
      centroid += Offset(cell[i].dx, cell[i].dy);
    }
  }
  if (precise) {
    area /= 2;
    centroid = Offset(
      centroid.dx / (6 * area),
      centroid.dy / (6 * area),
    );

    if (centroid.dx.isInfinite ||
        centroid.dx.isNaN ||
        centroid.dy.isInfinite ||
        centroid.dy.isNaN) {
      centroid = Offset.zero;
    }
  } else {
    centroid = Offset(
      centroid.dx / cell.length,
      centroid.dy / cell.length,
    );
  }
  return centroid;
}

Float32List lerpPoints(Float32List a, Float32List b, double value) {
  assert(a.length == b.length);
  final newPoints = Float32List(a.length);
  for (int i = 0; i < a.length; i++) {
    final lerp = lerpDouble(
      a[i],
      b[i],
      value,
    );
    newPoints[i] = lerp ?? a[i];
  }
  return newPoints;
}
