import 'dart:math';
import 'dart:typed_data';

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
