import 'package:app/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _kThresholdMax = 0.6;
const _kThresholdMin = 0.3;
const _kShowThreshold = false;

class ImagePixelsDemo extends StatefulWidget {
  const ImagePixelsDemo({
    super.key,
    required this.imagePath,
    this.zoom = 3,
  });

  final String imagePath;
  final double zoom;

  @override
  State<ImagePixelsDemo> createState() => _ImagePixelsDemoState();
}

class _ImagePixelsDemoState extends State<ImagePixelsDemo> {
  bool _isLoadingImage = false;
  ByteData? _imageBytes;
  Size _imageSize = Size.zero;
  List<Color>? _pixelColors;

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
      _pixelColors = _getPixelColorsFromByteData(imageBytes, imgWidth);
      _imageSize = Size(imgWidth.toDouble(), imgHeight.toDouble());
    }
    _isLoadingImage = false;
    setState(() {});
  }

  List<Color> _getPixelColorsFromByteData(ByteData bytes, int imageWidth) {
    final pixelColors =
        List<Color>.filled(bytes.lengthInBytes ~/ 4, Colors.white);
    for (int i = 0; i < bytes.lengthInBytes; i += 4) {
      // ⬅️ Increment by 4
      final rgbaColor = bytes.getUint32(i);
      pixelColors[i ~/ 4] = Color(rgbaToArgb(rgbaColor));
    }
    return pixelColors;
  }

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant ImagePixelsDemo oldWidget) {
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
    if (_imageBytes == null || _pixelColors == null) {
      return const Text('No Image');
    }
    return Center(
      child: Transform.scale(
        scale: widget.zoom,
        child: SizedBox(
          width: _imageSize.width,
          height: _imageSize.height,
          child: CustomPaint(
            painter: ImagePixelsDemoPainter(
              pixels: _pixelColors!,
              imageSize: _imageSize,
              threshold: _kShowThreshold,
            ),
          ),
        ),
      ),
    );
  }
}

class ImagePixelsDemoPainter extends CustomPainter {
  ImagePixelsDemoPainter({
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
    for (int i = 0; i < pixels.length; i++) {
      double x = i % imageSize.width;
      double y = i / imageSize.width;
      canvas.drawRect(
        Rect.fromLTWH(x, y, 1.1, 1.1),
        Paint()..color = pixels[i],
      );
    }

    // final offsets = generateVertexOffsets(pixels.length, imageSize.width);
    // final colors = List<Color>.generate(offsets.length, (i) {
    //   final color = pixels[i ~/ 6];
    //   final HSLColor hslColor = HSLColor.fromColor(color);
    //   if (greyScale) {
    //     return Colors.black.withOpacity(1.0 - hslColor.lightness);
    //   } else if (threshold) {
    //     if (hslColor.lightness > _kThresholdMin &&
    //         hslColor.lightness < _kThresholdMax) {
    //       return Colors.white;
    //     } else {
    //       return Colors.black;
    //     }
    //   } else {
    //     return color;
    //   }
    // });
    // final vertices = Vertices(
    //   VertexMode.triangles,
    //   offsets,
    //   colors: colors,
    // );
    //
    // canvas.drawVertices(vertices, BlendMode.src, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
