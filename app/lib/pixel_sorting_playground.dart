import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app/enums.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _kUseVertices = false;
const _kUseVerticesRaw = true;

class PixelSortingPlaygroundPage extends StatelessWidget {
  const PixelSortingPlaygroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PixelSortingPlayground(
        imagePath: 'assets/images/dash-bg-500p.png',
        tickDuration: 5,
        pixelSortStyle: PixelSortStyle.byColumn,
      ),
    );
  }
}

class PixelSortingPlayground extends StatefulWidget {
  const PixelSortingPlayground({
    super.key,
    required this.imagePath,
    this.tickDuration = 100,
    this.pixelSortStyle = PixelSortStyle.full,
  });

  final String imagePath;
  final int tickDuration;
  final PixelSortStyle pixelSortStyle;

  @override
  State<PixelSortingPlayground> createState() => _PixelSortingPlaygroundState();
}

class _PixelSortingPlaygroundState extends State<PixelSortingPlayground> {
  bool _isLoadingImage = false;
  ByteData? _imageBytes;
  Size _imageSize = Size.zero;
  List<HSLColor> _pixels = [];
  List<HSLColor> _transposedPixels = [];
  double zoom = 2;
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
    switch (widget.pixelSortStyle) {
      case PixelSortStyle.full:
        return _sortPixelsFull();
      case PixelSortStyle.byRow:
        return _sortPixelsByRow();
      case PixelSortStyle.byColumn:
        return _sortPixelsByColumn();
      default:
        return;
    }
  }

  _sortPixelsFull() async {
    await _quickSortColors(_pixels, 0, _pixels.length - 1);
  }

  _sortPixelsByRow() async {
    List<Future<void> Function()> futureFunctions = [];
    for (int i = 0; i < _imageSize.height.toInt(); i++) {
      final start = i * _imageSize.width.toInt();
      final end = start + _imageSize.width.toInt() - 1;
      futureFunctions.add(() async => _quickSortColors(_pixels, start, end));
    }
    List<Future<void>> futures =
        futureFunctions.map((futureFunction) => futureFunction()).toList();
    await Future.wait(futures);
  }

  _sortPixelsByColumn() async {
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

  Future<void> _handleLoadImage() async {
    await _loadImage();
    _initPixels();
  }

  @override
  void initState() {
    super.initState();
    _handleLoadImage();
    _tickDuration = Duration(milliseconds: widget.tickDuration);
  }

  @override
  void didUpdateWidget(covariant PixelSortingPlayground oldWidget) {
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
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Transform.scale(
              scale: zoom,
              child: SizedBox(
                width: _imageSize.width,
                height: _imageSize.height,
                child: CustomPaint(
                  painter: ImagePixelsFullSortPainter(
                    pixels: widget.pixelSortStyle == PixelSortStyle.byColumn
                        ? _transposedPixels
                        : _pixels,
                    transposed:
                        widget.pixelSortStyle == PixelSortStyle.byColumn,
                    imageSize: _imageSize,
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                _initPixels();
                setState(() {});
              },
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
            IconButton(
              onPressed: () {
                _sortPixels().then((_) {
                  log('Finished!');
                });
              },
              icon: const Icon(Icons.play_circle),
            ),
          ],
        )
      ],
    );
  }
}

class ImagePixelsFullSortPainter extends CustomPainter {
  ImagePixelsFullSortPainter({
    required this.pixels,
    required this.imageSize,
    this.transposed = false,
  });

  final List<HSLColor> pixels;
  final Size imageSize;
  final bool transposed;

  @override
  void paint(Canvas canvas, Size size) {
    if (transposed) {
      if (_kUseVertices) {
        final offsets = generateVertexOffsets(
          pixels.length,
          imageSize.height.toInt(),
          transposed: true,
        );
        final colors = List<Color>.generate(
            offsets.length, (i) => pixels[i ~/ 6].toColor());
        final vertices = Vertices(
          VertexMode.triangles,
          offsets,
          colors: colors,
        );

        canvas.drawVertices(vertices, BlendMode.src, Paint());
      } else if (_kUseVerticesRaw) {
        final vertices = generateVerticesRaw(
          pixels.length,
          imageSize.height.toInt(),
          transposed: true,
        );
        final colorsRaw = Int32List(vertices.length ~/ 2);
        for (int i = 0; i < colorsRaw.length; i += 6) {
          colorsRaw[i] = pixels[i ~/ 6].toColor().value;
          colorsRaw[i + 1] = pixels[i ~/ 6].toColor().value;
          colorsRaw[i + 2] = pixels[i ~/ 6].toColor().value;
          colorsRaw[i + 3] = pixels[i ~/ 6].toColor().value;
          colorsRaw[i + 4] = pixels[i ~/ 6].toColor().value;
          colorsRaw[i + 5] = pixels[i ~/ 6].toColor().value;
        }
        final verticesRaw = Vertices.raw(
          VertexMode.triangles,
          vertices,
          colors: colorsRaw,
        );

        canvas.drawVertices(verticesRaw, BlendMode.src, Paint());
      } else {
        for (int i = 0; i < pixels.length; i++) {
          int col = (i % imageSize.height).toInt();
          int row = i ~/ imageSize.height;
          canvas.drawRect(
            Rect.fromLTWH(row.toDouble(), col.toDouble(), 1.1, 1.1),
            Paint()..color = pixels[i].toColor(),
          );
        }
      }
    } else {
      if (_kUseVertices) {
        final offsets =
            generateVertexOffsets(pixels.length, imageSize.width.toInt());
        final colors = List<Color>.generate(
            offsets.length, (i) => pixels[i ~/ 6].toColor());
        final vertices = Vertices(
          VertexMode.triangles,
          offsets,
          colors: colors,
        );

        canvas.drawVertices(vertices, BlendMode.src, Paint());
      } else if (_kUseVerticesRaw) {
        final vertices =
            generateVerticesRaw(pixels.length, imageSize.width.toInt());
        final colorsRaw = Int32List(vertices.length ~/ 2);
        for (int i = 0; i < colorsRaw.length; i += 6) {
          colorsRaw[i] = pixels[i ~/ 6].toColor().value;
          colorsRaw[i + 1] = pixels[i ~/ 6].toColor().value;
          colorsRaw[i + 2] = pixels[i ~/ 6].toColor().value;
          colorsRaw[i + 3] = pixels[i ~/ 6].toColor().value;
          colorsRaw[i + 4] = pixels[i ~/ 6].toColor().value;
          colorsRaw[i + 5] = pixels[i ~/ 6].toColor().value;
        }
        final verticesRaw = Vertices.raw(
          VertexMode.triangles,
          vertices,
          colors: colorsRaw,
        );

        canvas.drawVertices(verticesRaw, BlendMode.src, Paint());
      } else {
        for (int i = 0; i < pixels.length; i++) {
          int col = (i % imageSize.width).toInt();

          int row = i ~/ imageSize.width;
          canvas.drawRect(
            Rect.fromLTWH(col.toDouble(), row.toDouble(), 1.1, 1.1),
            Paint()..color = pixels[i].toColor(),
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
