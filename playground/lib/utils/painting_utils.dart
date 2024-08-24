import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

Float32List generateGridPoints({
  required Size canvasSize,
  double cellSize = 50,
  double cellIncrementFactor = 0.1,
}) {
  final coords = <double>[];
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
      coords.addAll([centerX, centerY]);
    }
  }

  return Float32List.fromList(coords);
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
