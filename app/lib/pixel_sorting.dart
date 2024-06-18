import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _kShowImage = false;
const _kTickDuration = 5;

class PixelSortingPage extends StatelessWidget {
  const PixelSortingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ImagePixelQuickSort(),
    );
  }
}

class ImagePixelQuickSort extends StatefulWidget {
  const ImagePixelQuickSort({super.key});

  @override
  State<ImagePixelQuickSort> createState() => _ImagePixelQuickSortState();
}

class _ImagePixelQuickSortState extends State<ImagePixelQuickSort> {
  bool _loading = false;
  late ByteData? _imageBytes;

  late Uint32List? _pixelColors;

  final Duration _tickInterval = const Duration(milliseconds: _kTickDuration);

  Size _imageSize = const Size(0, 0);

  // static const imagePath = 'assets/images/buildings-200x200.jpeg';
  // static const imagePath = 'assets/images/buildings-50.jpeg';
  // static const imagePath = 'assets/images/buildings-100x100.jpeg';
  // static const imagePath = 'assets/images/dash-bg-2-100p.png';
  // static const imagePath = 'assets/images/dash-bg-100p.png';
  // static const imagePath = 'assets/images/dash-bg-3-50p.jpeg';
  // static const imagePath = 'assets/images/dash-bg-2-400p.png';
  // static const imagePath = 'assets/images/dash-bg-3-400p.jpeg';
  static const imagePath = 'assets/images/dash-bg-400p.png';

  Future<void> _loadImagePixels(String imageAssetPath) async {
    setState(() {
      _loading = true;
    });
    final pixels = await rootBundle.load(imageAssetPath);
    var decodedImage = await decodeImageFromList(pixels.buffer.asUint8List());
    final imageBytes = await decodedImage.toByteData();
    int imgWidth = decodedImage.width;
    int imgHeight = decodedImage.height;
    setState(() {
      _imageBytes = imageBytes;
      _imageSize = Size(imgWidth.toDouble(), imgHeight.toDouble());
      _loading = false;
    });
  }

  _initPixelData() {
    if (_imageBytes == null) {
      return;
    }
    _pixelColors = Uint32List(_imageBytes!.lengthInBytes ~/ 4);
    for (int i = 0; i < _imageBytes!.lengthInBytes; i++) {
      int col = (i ~/ 4) % _imageSize.width.floor();
      int row = (i ~/ 4) ~/ _imageSize.width;
      int index = ((row * _imageSize.width.floor()) + col) * 4;

      if (index >= 0 && index + 4 <= _imageBytes!.lengthInBytes) {
        final rgbaColor = _imageBytes!.getUint32(index);
        _pixelColors![i ~/ 4] = rgbaToArgb(rgbaColor);
      }
    }
  }

  _sortPixels() async {
    List<Future<void>> futures = [];
    for (int i = 0; i < _imageSize.height.toInt(); i++) {
      final start = i * _imageSize.width.toInt();
      final end = start + _imageSize.width.toInt() - 1;
      futures
          .add((() async => _quickSortColors(_pixelColors!, start, end))());
    }
    await Future.wait(futures);
  }

  _swap(Uint32List arr, int i, int j) async {
    final int tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
    setState(() {});
    if (i != j) {
      await Future.delayed(_tickInterval);
    }
  }

  Future<void> _quickSortColors(Uint32List arr, int start, int end) async {
    if (start >= end) {
      return;
    }
    final index = await _partition(arr, start, end);
    await Future.wait([
      _quickSortColors(arr, start, index - 1),
      _quickSortColors(arr, index + 1, end),
    ]);
  }

  Future<int> _partition(Uint32List arr, int start, int end) async {
    int pivotIndex = start;
    final pivotValue = arr[end];
    // Todo: pre-calculate hues
    final pivotColor = Color(rgbaToArgb(pivotValue));
    final hslPivotColor = HSLColor.fromColor(pivotColor);
    for (int i = start; i < end; i++) {
      final targetColor = Color(rgbaToArgb(arr[i]));
      final targetHSLColor = HSLColor.fromColor(targetColor);
      if (targetHSLColor.lightness < hslPivotColor.lightness) {
        await _swap(arr, i, pivotIndex);
        pivotIndex++;
      }
    }
    await _swap(arr, pivotIndex, end);
    return pivotIndex;
  }

  @override
  void initState() {
    super.initState();
    _loadImagePixels(imagePath).then((_) {
      _initPixelData();
      _sortPixels().then((_) {
        log('Finished!');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_imageBytes == null || _pixelColors == null) {
      return const Center(
        child: Text('Failed to load image!'),
      );
    }
    return Center(
      child: Transform.scale(
        scale: 3,
        child: SizedBox(
          width: _imageSize.width,
          height: _imageSize.height,
          child: Stack(
            children: [
              if (_kShowImage)
                Positioned.fill(
                  child: Image.asset(imagePath),
                ),
              Positioned.fill(
                child: CustomPaint(
                  painter: ImagePixelSortingPainter(
                    bytes: _imageBytes!,
                    colors: _pixelColors!,
                    imageSize: _imageSize,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImagePixelSortingPainter extends CustomPainter {
  ImagePixelSortingPainter({
    required this.bytes,
    required this.colors,
    required this.imageSize,
  });

  final ByteData bytes;
  final Uint32List colors;
  final Size imageSize;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < colors.length; i++) {
      int col = (i % imageSize.width).toInt();
      int row = i ~/ imageSize.width;
      final color = Color(colors[i]);
      canvas.drawPoints(
        PointMode.points,
        [Offset(col.toDouble(), row.toDouble())],
        Paint()
          ..strokeWidth = 1
          ..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(ImagePixelSortingPainter oldDelegate) {
    return true;
  }
}
