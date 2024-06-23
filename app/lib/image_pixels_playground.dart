import 'dart:ui';

import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _kThresholdMax = 0.6;
const _kThresholdMin = 0.3;

class ImagePixelsPlaygroundPage extends StatelessWidget {
  const ImagePixelsPlaygroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ImagePixelsPlayground(
        imagePath: 'assets/images/subway-500w.jpg',
      ),
    );
  }
}

class ImagePixelsPlayground extends StatefulWidget {
  const ImagePixelsPlayground({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  State<ImagePixelsPlayground> createState() => _ImagePixelsPlaygroundState();
}

class _ImagePixelsPlaygroundState extends State<ImagePixelsPlayground> {
  bool _isLoadingImage = false;
  ByteData? _imageBytes;
  Size _imageSize = Size.zero;
  List<Color> _pixels = [];
  double zoom = 1;

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

      if (index >= 0 && index + 4 <= _imageBytes!.lengthInBytes) {
        final rgbaColor = _imageBytes!.getUint32(index);
        _pixels[i ~/ 4] = Color(rgbaToArgb(rgbaColor));
      }
    }
  }

  Future<void> _handleLoadImage() async {
    await _loadImage();
    _initPixels();
  }

  @override
  void didUpdateWidget(covariant ImagePixelsPlayground oldWidget) {
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
              GestureDetector(
                onTap: _handleLoadImage,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_imageBytes == null ? 'Load Image' : 'Reload Image'),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.arrow_forward,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                  'Image Size: Size(${_imageSize.width}, ${_imageSize.height})'),
              Text('Image byte length: ${_imageBytes?.lengthInBytes ?? 0}'),
              Text('Pixel count: ${(_imageBytes?.lengthInBytes ?? 0) ~/ 4}'),
              Text('Pixel colors: ${_pixels.length}'),
              const SizedBox(height: 10),
              const Text('Original Image'),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Image.asset(widget.imagePath),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => setState(() => zoom = 1),
                      icon: const Icon(Icons.restart_alt_rounded),
                    ),
                    IconButton(
                      onPressed: () {
                        if (zoom > 1) {
                          setState(() {
                            zoom--;
                          });
                        }
                      },
                      icon: const Icon(Icons.zoom_out),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          zoom++;
                        });
                      },
                      icon: const Icon(Icons.zoom_in),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: _buildImageView(),
          ),
        ),
      ],
    );
  }

  Widget _buildImageView() {
    if (_isLoadingImage) {
      return const CircularProgressIndicator();
    }
    if (_imageBytes == null) {
      return const Text('No Image');
    }
    return Center(
      child: Transform.scale(
        scale: zoom,
        child: SizedBox(
          width: _imageSize.width,
          height: _imageSize.height,
          child: CustomPaint(
            painter: ImagePixelsPlaygroundPainter(
              pixels: _pixels,
              imageSize: _imageSize,
              threshold: true,
            ),
          ),
        ),
      ),
    );
  }
}

class ImagePixelsPlaygroundPainter extends CustomPainter {
  ImagePixelsPlaygroundPainter({
    required this.pixels,
    required this.imageSize,
    this.greyScale = false,
    this.threshold = false,
  });

  final List<Color> pixels;
  final Size imageSize;
  final bool greyScale;
  final bool threshold;

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
    final colors = List<Color>.generate(offsets.length, (i) {
      final color = pixels[i ~/ 6];
      final HSLColor hslColor = HSLColor.fromColor(color);
      if (greyScale) {
        return Colors.black.withOpacity(1.0 - hslColor.lightness);
      } else if (threshold) {
        if (hslColor.lightness > _kThresholdMin &&
            hslColor.lightness < _kThresholdMax) {
          return Colors.white;
        } else {
          return Colors.black;
        }
      } else {
        return color;
      }
    });
    final vertices = Vertices(
      VertexMode.triangles,
      offsets,
      colors: colors,
    );

    canvas.drawVertices(vertices, BlendMode.src, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
