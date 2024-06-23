import 'package:flutter/material.dart';

class ImagePixelsPainter extends CustomPainter {
  ImagePixelsPainter({
    required this.pixels,
    required this.imageSize,
  });

  final List<Color> pixels;
  final Size imageSize;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pixels.length; i++) {
      int col = (i % imageSize.width).toInt();
      int row = i ~/ imageSize.width;
      canvas.drawRect(
        Rect.fromLTWH(col.toDouble(), row.toDouble(), 1.1, 1.1),
        Paint()..color = pixels[i],
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
