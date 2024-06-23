import 'dart:ui';

import 'package:app/utils.dart';
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
    // for (int i = 0; i < pixels.length; i++) {
    //   int col = (i % imageSize.width).toInt();
    //   int row = i ~/ imageSize.width;
    //   canvas.drawRect(
    //     Rect.fromLTWH(col.toDouble(), row.toDouble(), 1.1, 1.1),
    //     Paint()..color = pixels[i],
    //   );
    // }

    final offsets =
        generateVertexOffsets(pixels.length, imageSize.width.toInt());
    final colors = List<Color>.generate(offsets.length, (i) => pixels[i ~/ 6]);
    final vertices = Vertices(
      VertexMode.triangles,
      offsets,
      colors: colors,
    );

    canvas.drawVertices(vertices, BlendMode.src, Paint());

    // const pixelWidth = 50.0;
    // const topLeft = Offset(0, 0);
    // const topRight = Offset(pixelWidth, 0);
    // const bottomRight = Offset(pixelWidth, pixelWidth);
    // const bottomLeft = Offset(0, pixelWidth);
    // final vertices = Vertices(
    //   VertexMode.triangles,
    //   [
    //     topLeft,
    //     topRight,
    //     bottomRight,
    //     bottomRight,
    //     bottomLeft,
    //     topLeft,
    //   ],
    //   colors: List.generate(
    //     6,
    //     (i) => Colors.red,
    //   ),
    // );
    //
    // canvas.drawVertices(vertices, BlendMode.src, Paint());

    // const pixelWidth = 50.0;
    // const topLeft = Offset(0, 0);
    // const topRight = Offset(pixelWidth, 0);
    // const bottomRight = Offset(pixelWidth, pixelWidth);
    // const bottomLeft = Offset(0, pixelWidth);
    // final testVertices = Vertices.raw(
    //   VertexMode.triangles,
    //   Float32List.fromList([
    //     topLeft.dx,
    //     topLeft.dy,
    //     topRight.dx,
    //     topRight.dy,
    //     bottomRight.dx,
    //     bottomRight.dy,
    //     bottomRight.dx,
    //     bottomRight.dy,
    //     bottomLeft.dx,
    //     bottomLeft.dy,
    //     topLeft.dx,
    //     topLeft.dy,
    //   ]),
    //   colors: Int32List.fromList([
    //     Colors.red.value,
    //     Colors.red.value,
    //     Colors.red.value,
    //     Colors.blue.value,
    //     Colors.blue.value,
    //     Colors.blue.value,
    //   ]),
    // );
    //
    // canvas.drawVertices(testVertices, BlendMode.src, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
