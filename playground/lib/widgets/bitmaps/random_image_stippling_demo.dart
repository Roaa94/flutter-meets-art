import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playground/utils/color_utils.dart';

class RandomImageStipplingDemo extends StatefulWidget {
  const RandomImageStipplingDemo({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  State<RandomImageStipplingDemo> createState() =>
      _RandomImageStipplingDemoState();
}

class _RandomImageStipplingDemoState extends State<RandomImageStipplingDemo> {
  bool _isLoadingImage = false;
  ByteData? _imageBytes;
  Size _imageSize = Size.zero;

  Future<void> _loadImage() async {
    setState(() {
      _isLoadingImage = true;
    });
    final img = await rootBundle.load(widget.imagePath);
    var decodedImage = await decodeImageFromList(img.buffer.asUint8List());
    final imageBytes = await decodedImage.toByteData();
    int imgWidth = decodedImage.width;
    int imgHeight = decodedImage.height;

    if (imageBytes != null) {
      _imageBytes = imageBytes;
      _imageSize = Size(imgWidth.toDouble(), imgHeight.toDouble());
    }
    _isLoadingImage = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant RandomImageStipplingDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath) {
      _imageBytes = null;
      _imageSize = Size.zero;
      _loadImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingImage) {
      return const CircularProgressIndicator();
    }
    if (_imageBytes == null) {
      return const Text('No Image');
    }
    return Center(
      child: SizedBox(
        width: _imageSize.width,
        height: _imageSize.height,
        child: CustomPaint(
          painter: RandomImageStipplePainter(
            imageBytes: _imageBytes!,
          ),
        ),
      ),
    );
  }
}

class RandomImageStipplePainter extends CustomPainter {
  RandomImageStipplePainter({
    required this.imageBytes,
    this.greyScale = false,
  });

  final ByteData imageBytes;
  final bool greyScale;

  final _paint = Paint()..color = Colors.black;
  final random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    // for (int i = 0; i < size.width * size.height; i += 6) {
    //   double x = i % size.width;
    //   double y = i / size.width;
    //
    //   final pixelOffset = i * 4;
    //
    //   // Check if pixelDataOffset is within valid range
    //   if (pixelOffset < 0 || pixelOffset + 4 > imageBytes.lengthInBytes) {
    //     throw Exception('Pixel out of range!');
    //   }
    //
    //   final rgbaColor = imageBytes.getUint32(pixelOffset);
    //   final color = Color(rgbaToArgb(rgbaColor));
    //
    //   final brightness = color.computeLuminance();
    //
    //   if (random.nextDouble() > brightness) {
    //     canvas.drawCircle(
    //       Offset(x, y),
    //       2,
    //       _paint,
    //     );
    //   }
    // }

    const pointsCount = 3000;
    for (int i = 0; i < pointsCount; i++) {
      final x = size.width * random.nextDouble();
      final y = size.height * random.nextDouble();

      final pixelOffset = (((y * size.width) + x) * 4).toInt();

      // Check if pixelDataOffset is within valid range
      if (pixelOffset < 0 || pixelOffset + 4 > imageBytes.lengthInBytes) {
        continue;
      }

      final rgbaColor = imageBytes.getUint32(pixelOffset);
      final color = Color(rgbaToArgb(rgbaColor));

      final brightness = color.computeLuminance();

      if (random.nextDouble() > brightness) {
        canvas.drawCircle(
          Offset(x, y),
          2,
          _paint,
        );
      } else {
        i--;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
