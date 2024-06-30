import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app/algorithms/delaunay.dart';
import 'package:camera_macos/camera_macos.dart';
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

Float32List generateRandomPointsFromPixels(
    ByteData bytes, Size size, int pointsCount, Random random) {
  final list = <double>[];
  for (int i = 0; i < pointsCount; i++) {
    final x = size.width * random.nextDouble();
    final y = size.height * random.nextDouble();
    final offset = Offset(x, y);
    final color =
        getPixelColorFromBytes(bytes: bytes, offset: offset, size: size);
    final brightness = color.computeLuminance();
    if (random.nextDouble() > brightness) {
      list.addAll([offset.dx, offset.dy]);
    } else {
      i--;
    }
  }
  return Float32List.fromList(list);
}

Color getPixelColorFromBytes({
  required ByteData bytes,
  required Offset offset,
  required Size size,
}) {
  final pixelDataOffset = getBitmapPixelOffset(
    imageWidth: size.width.toInt(),
    x: offset.dx.toInt(),
    y: offset.dy.toInt(),
  );

  // Check if pixelDataOffset is within valid range
  if (pixelDataOffset < 0 || pixelDataOffset + 4 > bytes.lengthInBytes) {
    return Colors.black.withOpacity(0.5);
  }

  final rgbaColor = bytes.getUint32(pixelDataOffset);
  return Color(rgbaToArgb(rgbaColor));
}

int getBitmapPixelOffset({
  required int imageWidth,
  required int x,
  required int y,
}) {
  return ((y * imageWidth) + x) * 4;
}

Float32List calcWeightedCentroids(
  Delaunay delaunay,
  Size size,
  ByteData bytes,
) {
  final weightedCentroids = Float32List(delaunay.coords.length);
  final weights = Float32List(delaunay.coords.length ~/ 2);
  int delaunayIndex = 0;
  int pixelsCount = (size.width * size.height).toInt();
  for (int p = 0; p < pixelsCount; p++) {
    int i = p % size.width.toInt();
    int j = p ~/ size.width;

    final color = getPixelColorFromBytes(
      bytes: bytes,
      offset: Offset(i.toDouble(), j.toDouble()),
      size: size,
    );

    final brightness =
        0.2126 * color.red + 0.7152 * color.green + 0.0722 * color.blue;
    final weight = 1 - brightness / 255;

    delaunayIndex = delaunay.find(
      i.toDouble(),
      j.toDouble(),
      delaunayIndex,
    );

    weightedCentroids[2 * delaunayIndex] += (i * weight);
    weightedCentroids[2 * delaunayIndex + 1] += (j * weight);
    weights[delaunayIndex] += weight;
  }

  for (int i = 0; i < weightedCentroids.length; i += 2) {
    if (weights[i ~/ 2] > 0) {
      weightedCentroids[i] /= weights[i ~/ 2];
      weightedCentroids[i + 1] /= weights[i ~/ 2];
    } else {
      weightedCentroids[i] = delaunay.coords[i];
      weightedCentroids[i + 1] = delaunay.coords[i + 1];
    }
  }

  return weightedCentroids;
}

CameraImageData argb2bitmap(CameraImageData content) {
  final Uint8List updated = Uint8List(content.bytes.length);
  for (int i = 0; i < updated.length; i += 4) {
    updated[i] = content.bytes[i + 1];
    updated[i + 1] = content.bytes[i + 2];
    updated[i + 2] = content.bytes[i + 3];
    updated[i + 3] = content.bytes[i];
  }

  const int headerSize = 122;
  final int contentSize = content.bytes.length;
  final int fileLength = contentSize + headerSize;

  final Uint8List headerIntList = Uint8List(fileLength);

  final ByteData bd = headerIntList.buffer.asByteData();
  bd.setUint8(0x0, 0x42);
  bd.setUint8(0x1, 0x4d);
  bd.setInt32(0x2, fileLength, Endian.little);
  bd.setInt32(0xa, headerSize, Endian.little);
  bd.setUint32(0xe, 108, Endian.little);
  bd.setUint32(0x12, content.width, Endian.little);
  bd.setUint32(0x16, -content.height, Endian.little); //-height
  bd.setUint16(0x1a, 1, Endian.little);
  bd.setUint32(0x1c, 32, Endian.little); // pixel size
  bd.setUint32(0x1e, 3, Endian.little); //BI_BITFIELDS
  bd.setUint32(0x22, contentSize, Endian.little);
  bd.setUint32(0x36, 0x000000ff, Endian.little);
  bd.setUint32(0x3a, 0x0000ff00, Endian.little);
  bd.setUint32(0x3e, 0x00ff0000, Endian.little);
  bd.setUint32(0x42, 0xff000000, Endian.little);

  headerIntList.setRange(
    headerSize,
    fileLength,
    updated,
  );

  return CameraImageData(
    bytes: headerIntList,
    width: content.width,
    height: content.height,
    bytesPerRow: content.bytesPerRow,
  );
}
