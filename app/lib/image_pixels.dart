import 'dart:ui';

import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImagePixelsPage extends StatelessWidget {
  const ImagePixelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ImagePixels(
        imagePath: 'assets/images/dash-bg-400p.png',
      ),
    );
  }
}

class ImagePixels extends StatefulWidget {
  const ImagePixels({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  State<ImagePixels> createState() => _ImagePixelsState();
}

class _ImagePixelsState extends State<ImagePixels> {
  bool _isLoadingImage = false;
  ByteData? _imageBytes;
  Size _imageSize = Size.zero;
  List<Color> _pixels = [];

  Future<void> _loadImage() async {
    setState(() {
      _isLoadingImage = true;
    });
    final img = await rootBundle.load(widget.imagePath);
    var decodedImage = await decodeImageFromList(img.buffer.asUint8List());
    final imageBytes = await decodedImage.toByteData();
    int imgWidth = decodedImage.width;
    int imgHeight = decodedImage.height;

    setState(() {
      _imageBytes = imageBytes;
      _imageSize = Size(imgWidth.toDouble(), imgHeight.toDouble());
      _isLoadingImage = false;
    });
  }

  _initPixels() {
    if (_imageBytes == null) {
      return;
    }
    _pixels = List.filled(_imageBytes!.lengthInBytes ~/ 4, Colors.black);
    for (int i = 0; i < _imageBytes!.lengthInBytes; i++) {
      int col = (i ~/ 4) % _imageSize.width.floor();
      int row = (i ~/ 4) ~/ _imageSize.width;
      int index = ((row * _imageSize.width.floor()) + col) * 4;

      // if (index >= 0 && index + 4 <= _imageBytes!.lengthInBytes) {
        final rgbaColor = _imageBytes!.getUint32(index);
        _pixels[i ~/ 4] = Color(rgbaToArgb(rgbaColor));
      // }
    }
  }

  Future<void> _handleLoadImage() async {
    await _loadImage();
    _initPixels();
  }

  @override
  void didUpdateWidget(covariant ImagePixels oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath) {
      _imageBytes = null;
      _imageSize = Size.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _handleLoadImage,
                child:
                    Text(_imageBytes == null ? 'Load Image' : 'Reload Image'),
              ),
              const SizedBox(height: 20),
              const Text('Original Image:'),
              Text(
                  'Image Size: Size(${_imageSize.width}, ${_imageSize.height})'),
              Text('Image byte length: ${_imageBytes?.lengthInBytes ?? 0}'),
              Text('Pixel count: ${(_imageBytes?.lengthInBytes ?? 0) ~/ 4}'),
              Text('Pixel colors: ${_pixels.length}'),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Image.asset(widget.imagePath),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: _isLoadingImage
                ? const CircularProgressIndicator()
                : _imageBytes == null
                    ? const Text('No Image')
                    : SizedBox(
                        width: _imageSize.width,
                        height: _imageSize.height,
                        child: CustomPaint(
                          painter: ImagePixelsPainter(
                            pixels: _pixels,
                            imageSize: _imageSize,
                          ),
                        ),
                      ),
          ),
        ),
      ],
    );
  }
}

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
      canvas.drawPoints(
        PointMode.points,
        [Offset(col.toDouble(), row.toDouble())],
        Paint()
          ..strokeWidth = 1
          ..color = pixels[i],
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
