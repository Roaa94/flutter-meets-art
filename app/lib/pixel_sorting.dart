import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _kThresholdMax = 0.8;
const _kThresholdMin = 0.2;
const _kShowThreshold = false;

class PixelSortingPage extends StatelessWidget {
  const PixelSortingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: PixelSorting(
        imagePath: 'assets/images/colored-buildings-700w.png',
        tickDuration: 5,
      ),
    );
  }
}

class PixelSorting extends StatefulWidget {
  const PixelSorting({
    super.key,
    required this.imagePath,
    this.tickDuration = 100,
  });

  final String imagePath;
  final int tickDuration;

  @override
  State<PixelSorting> createState() => _PixelSortingState();
}

class _PixelSortingState extends State<PixelSorting> {
  bool _isLoadingImage = false;
  ByteData? _imageBytes;
  Size _imageSize = Size.zero;
  List<HSLColor> _pixels = [];
  final List<int> _intervals = [];
  List<HSLColor> _transposedPixels = [];
  double zoom = 1;
  late Duration _tickDuration;

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

  void _initPixels() {
    if (_imageBytes == null) {
      return;
    }

    int width = _imageSize.width.floor();
    int height = _imageSize.height.floor();
    int pixelCount = width * height;

    _pixels =
        List<HSLColor>.filled(pixelCount, HSLColor.fromColor(Colors.black));
    _transposedPixels =
        List<HSLColor>.filled(pixelCount, HSLColor.fromColor(Colors.black));

    for (int i = 0; i < _imageBytes!.lengthInBytes; i += 4) {
      int pixelIndex = i ~/ 4;
      int col = pixelIndex % width;
      int row = pixelIndex ~/ width;
      int index = (row * width + col) * 4;

      if (index >= 0 && index + 4 <= _imageBytes!.lengthInBytes) {
        final rgbaColor = _imageBytes!.getUint32(index);
        HSLColor pixelColor = HSLColor.fromColor(Color(rgbaToArgb(rgbaColor)));
        _pixels[pixelIndex] = pixelColor;
        _transposedPixels[col * height + row] = pixelColor;
      }
    }
  }

  void _initIntervals() {
    int? start;
    int? end;
    for (int i = 0; i < _transposedPixels.length; i++) {
      final color = _transposedPixels[i];

      if (compare(color, _kThresholdMin, _kThresholdMax)) {
        start ??= i;
      } else {
        if (start != null && end == null) {
          end = i - 1;
        }
      }
      if (start != null && end != null) {
        _intervals.addAll([start, end]);
        start = null;
        end = null;
      }
    }
  }

  _swap(List<HSLColor> arr, int i, int j) async {
    final HSLColor tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
    setState(() {});
    if (i != j && _tickDuration.inMilliseconds > 0) {
      await Future.delayed(_tickDuration);
    }
  }

  Future<void> _quickSortColors(List<HSLColor> arr, int start, int end) async {
    if (start >= end) {
      return;
    }
    final index = await _partition(arr, start, end);
    await Future.wait([
      _quickSortColors(arr, start, index - 1),
      _quickSortColors(arr, index + 1, end),
    ]);
  }

  Future<int> _partition(List<HSLColor> arr, int start, int end) async {
    int pivotIndex = start;
    final pivotValue = arr[end];
    for (int i = start; i < end; i++) {
      if (arr[i].lightness < pivotValue.lightness) {
        await _swap(arr, i, pivotIndex);
        pivotIndex++;
      }
    }
    await _swap(arr, pivotIndex, end);
    return pivotIndex;
  }

  Future<void> _sortPixels() async {
    if (_pixels.isEmpty) return;
    List<Future<void> Function()> futureFunctions = [];
    for (int i = 0; i < _imageSize.width.toInt(); i++) {
      final start = i * _imageSize.height.toInt();
      final end = start + _imageSize.height.toInt() - 1;
      futureFunctions
          .add(() async => _quickSortColors(_transposedPixels, start, end));
    }
    List<Future<void>> futures =
        futureFunctions.map((futureFunction) => futureFunction()).toList();
    await Future.wait(futures);
  }

  Future<void> _sortPixelsByIntervals() async {
    if (_pixels.isEmpty || _intervals.isEmpty) return;
    List<Future<void> Function()> futureFunctions = [];
    for (int i = 0; i < _intervals.length; i += 2) {
      final start = _intervals[i];
      final end = _intervals[i + 1];
      futureFunctions
          .add(() async => _quickSortColors(_transposedPixels, start, end));
    }
    List<Future<void>> futures =
        futureFunctions.map((futureFunction) => futureFunction()).toList();
    await Future.wait(futures);
  }

  Future<void> _handleLoadImage() async {
    await _loadImage();
    _initPixels();
    _initIntervals();
  }

  @override
  void initState() {
    super.initState();
    _handleLoadImage();
    _tickDuration = Duration(milliseconds: widget.tickDuration);
  }

  @override
  void didUpdateWidget(covariant PixelSorting oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tickDuration != widget.tickDuration) {
      _tickDuration = Duration(milliseconds: widget.tickDuration);
    }
    if (oldWidget.imagePath != widget.imagePath) {
      zoom = 1;
      _handleLoadImage();
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
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          child: ColoredBox(
            color: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _initPixels();
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.restart_alt_rounded,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (zoom > 0.5) {
                      setState(() {
                        zoom = zoom - 0.1;
                      });
                    }
                  },
                  icon: const Icon(Icons.zoom_out),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      zoom = zoom + 0.1;
                    });
                  },
                  icon: const Icon(Icons.zoom_in),
                ),
                IconButton(
                  onPressed: () {
                    _sortPixelsByIntervals().then((_) {
                      log('Finished!');
                    });
                  },
                  icon: const Icon(Icons.play_circle),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Transform.scale(
              scale: zoom,
              child: SizedBox(
                width: _imageSize.width,
                height: _imageSize.height,
                child: CustomPaint(
                  painter: ImagePixelsFullSortPainter(
                    pixels: _transposedPixels,
                    imageSize: _imageSize,
                    showThreshold: _kShowThreshold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ImagePixelsFullSortPainter extends CustomPainter {
  ImagePixelsFullSortPainter({
    required this.pixels,
    required this.imageSize,
    this.showThreshold = false,
  });

  final List<HSLColor> pixels;
  final Size imageSize;
  final bool showThreshold;

  @override
  void paint(Canvas canvas, Size size) {
    final vertices = generateVerticesRaw(
      pixels.length,
      imageSize.height.toInt(),
      transposed: true,
    );
    final colorsRaw = Int32List(vertices.length ~/ 2);
    for (int i = 0; i < colorsRaw.length; i += 6) {
      int color = pixels[i ~/ 6].toColor().value;

      if (showThreshold) {
        if (compare(pixels[i ~/ 6], _kThresholdMin, _kThresholdMax)) {
          color = Colors.white.value;
        } else {
          color = Colors.black.value;
        }
      }

      colorsRaw[i] = color;
      colorsRaw[i + 1] = color;
      colorsRaw[i + 2] = color;
      colorsRaw[i + 3] = color;
      colorsRaw[i + 4] = color;
      colorsRaw[i + 5] = color;
    }
    final verticesRaw = Vertices.raw(
      VertexMode.triangles,
      vertices,
      colors: colorsRaw,
    );

    canvas.drawVertices(verticesRaw, BlendMode.src, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

bool compare(HSLColor color, double min, double max) {
  final brightness = 1 - color.lightness;
  return brightness <= max && brightness >= min;
}