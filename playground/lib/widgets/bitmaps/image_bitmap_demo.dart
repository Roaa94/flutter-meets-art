import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playground/utils/color_utils.dart';

class ImageBitmapDemo extends StatefulWidget {
  const ImageBitmapDemo({
    super.key,
    required this.imagePath,
    this.zoom = 3,
  });

  final String imagePath;
  final double zoom;

  @override
  State<ImageBitmapDemo> createState() => _ImageBitmapDemoState();
}

class _ImageBitmapDemoState extends State<ImageBitmapDemo> {
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
  void didUpdateWidget(covariant ImageBitmapDemo oldWidget) {
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
      child: Transform.scale(
        scale: widget.zoom,
        child: SizedBox(
          width: _imageSize.width,
          height: _imageSize.height,
          child: CustomPaint(
            painter: BitmapPainter(
              imageBytes: _imageBytes!,
            ),
          ),
        ),
      ),
    );
  }
}

class BitmapPainter extends CustomPainter {
  BitmapPainter({
    required this.imageBytes,
    this.greyScale = false,
  });

  final ByteData imageBytes;
  final bool greyScale;

  final _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < size.width * size.height; i++) {
      double x = i % size.width;
      double y = i / size.width;

      final pixelOffset = i * 4;

      // Check if pixelDataOffset is within valid range
      if (pixelOffset < 0 || pixelOffset + 4 > imageBytes.lengthInBytes) {
        throw Exception('Pixel out of range!');
      }

      final rgbaColor = imageBytes.getUint32(pixelOffset);
      _paint.color = Color(rgbaToArgb(rgbaColor));

      canvas.drawRect(
        Rect.fromLTWH(x, y, 1, 1),
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
