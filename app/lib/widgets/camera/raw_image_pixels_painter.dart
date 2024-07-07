import 'dart:typed_data';

import 'package:app/utils.dart';
import 'package:flutter/material.dart';

class RawImagePixelsPainter extends CustomPainter {
  RawImagePixelsPainter({
    required this.bytes,
    this.resolution = 20,
    this.grayScale = false,
  });

  final ByteData bytes;
  final double resolution;
  final bool grayScale;

  @override
  void paint(Canvas canvas, Size size) {
    final cols = (size.width / resolution).floor();
    final rows = (size.height / resolution).floor();
    for (int i = 0; i < cols * rows; i++) {
      int col = i ~/ cols;
      int row = i % cols;
      double top = col * resolution;
      double left = row * resolution;
      final center = Offset(left + resolution / 2, top + resolution / 2);

      final color = getPixelColorFromBytes(
        bytes: bytes,
        offset: center,
        size: size,
      );
      final brightness = color.computeLuminance();

      canvas.drawRect(
        Rect.fromLTWH(left, top, resolution, resolution),
        Paint()
          ..color = grayScale ? Colors.black.withOpacity(brightness) : color,
      );

      canvas.drawRect(
        Rect.fromLTWH(left, top, resolution, resolution),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.black,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
