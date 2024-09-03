import 'dart:math';
import 'dart:typed_data';

import 'package:playground/utils/color_utils.dart';
import 'package:flutter/material.dart';

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

Float32List generateRandomPointsFromPixels(
  ByteData bytes,
  Size size,
  int pointsCount,
  Random random,
) {
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

int getBitmapPixelOffset({
  required int imageWidth,
  required int x,
  required int y,
}) {
  return ((y * imageWidth) + x) * 4;
}
