import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app/enums.dart';
import 'package:app/utils.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PixelSortingDemoPage extends StatelessWidget {
  const PixelSortingDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: PixelSortingDemo(
        imagePath: 'assets/images/dash-bg-400p.png',
        tickDuration: 5,
        zoom: 3,
        pixelSortStyle: PixelSortStyle.byColumn,
        showThreshold: false,
        thresholdMin: 0.2,
        thresholdMax: 0.8,
      ),
    );
  }
}

class PixelSortingDemo extends StatefulWidget {
  const PixelSortingDemo({
    super.key,
    required this.imagePath,
    this.tickDuration = 100,
    this.zoom = 1.0,
    this.pixelSortStyle = PixelSortStyle.byRow,
    this.showThreshold = false,
    this.thresholdMax = 0.8,
    this.thresholdMin = 0.2,
    this.autoStart = true,
    this.trigger = true,
  });

  final String imagePath;
  final int tickDuration;
  final double zoom;
  final PixelSortStyle pixelSortStyle;
  final bool showThreshold;
  final double thresholdMax;
  final double thresholdMin;
  final bool autoStart;
  final bool trigger;

  @override
  State<PixelSortingDemo> createState() => _PixelSortingDemoState();
}

class _PixelSortingDemoState extends State<PixelSortingDemo> {
  bool _isLoadingImage = false;
  ByteData? _imageBytes;
  Size _imageSize = Size.zero;
  List<HSLColor> _pixels = [];
  List<int> _intervals = [];
  List<HSLColor> _transposedPixels = [];
  late Duration _tickDuration;
  CancelableCompleter? _completer;

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
    log('Image size: $_imageSize');
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
      int col = (i ~/ 4) % width;
      int row = (i ~/ 4) ~/ width;

      final rgbaColor = _imageBytes!.getUint32(i);
      HSLColor pixelColor = HSLColor.fromColor(Color(rgbaToArgb(rgbaColor)));
      _pixels[i ~/ 4] = pixelColor;
      _transposedPixels[col * height + row] = pixelColor;
    }
  }

  void _initIntervals({transposed = false}) {
    _intervals = [];
    int? start;
    int? end;
    List<HSLColor> pixels = transposed ? _transposedPixels : _pixels;
    for (int i = 0; i < pixels.length; i++) {
      final color = pixels[i];

      if (compare(color, widget.thresholdMin, widget.thresholdMax)) {
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
    if (start >= end) return;
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

  Future<void> _sortPixelsFull() async {
    await _quickSortColors(_pixels, 0, _pixels.length - 1);
  }

  Future<void> _sortPixelsByRow() async {
    List<Future<void>> futures = [];
    for (int i = 0; i < _imageSize.height.toInt(); i++) {
      final start = i * _imageSize.width.toInt();
      final end = start + _imageSize.width.toInt() - 1;
      futures.add((() async => _quickSortColors(_pixels, start, end))());
    }
    await Future.wait(futures);
  }

  Future<void> _sortPixelsByColumn() async {
    List<Future<void>> futures = [];
    for (int i = 0; i < _imageSize.width.toInt(); i++) {
      final start = i * _imageSize.height.toInt();
      final end = start + _imageSize.height.toInt() - 1;
      futures.add(_quickSortColors(_transposedPixels, start, end));
    }
    await Future.wait(futures);
  }

  Future<void> _sortPixelsByIntervals({bool transposed = false}) async {
    List<Future<void>> futures = [];
    for (int i = 0; i < _intervals.length; i += 2) {
      final start = _intervals[i];
      final end = _intervals[i + 1];
      futures.add(
        _quickSortColors(transposed ? _transposedPixels : _pixels, start, end),
      );
    }
    await Future.wait(futures);
  }

  Future<void> _loadImageAndPixels() async {
    await _loadImage();
    _initPixels();
    _initIntervals(transposed: widget.pixelSortStyle.transposed);
  }

  Future<void> _sort() async {
    _completer?.complete(_sortPixels());
    await _completer?.operation.value;
    log('Finished!');
  }

  Future<void> _sortPixels() async {
    switch (widget.pixelSortStyle) {
      case PixelSortStyle.full:
        return _sortPixelsFull();
      case PixelSortStyle.byRow:
        return _sortPixelsByRow();
      case PixelSortStyle.byColumn:
        return _sortPixelsByColumn();
      case PixelSortStyle.byIntervalRow:
        return _sortPixelsByIntervals();
      case PixelSortStyle.byIntervalColumn:
        return _sortPixelsByIntervals(transposed: true);
      default:
        return;
    }
  }

  @override
  void initState() {
    super.initState();
    _completer = CancelableCompleter(onCancel: () => log('Canceled!'));
    _tickDuration = Duration(milliseconds: widget.tickDuration);
    _loadImageAndPixels().then((_) {
      if (widget.autoStart) _sort();
    });
  }

  @override
  void didUpdateWidget(covariant PixelSortingDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tickDuration != widget.tickDuration) {
      _tickDuration = Duration(milliseconds: widget.tickDuration);
    }
    if (oldWidget.imagePath != widget.imagePath ||
        oldWidget.pixelSortStyle != widget.pixelSortStyle) {
      _completer?.operation.cancel().then((_) {
        _completer = CancelableCompleter(onCancel: () => log('Canceled!'));
        _loadImageAndPixels().then((_) {
          if (widget.autoStart) _sort();
        });
      });
    }

    if (oldWidget.trigger != widget.trigger && _imageBytes != null) {
      _completer?.operation.cancel().then((_) {
        _completer = CancelableCompleter(onCancel: () => log('Canceled!'));
        _initPixels();
        _initIntervals(transposed: widget.pixelSortStyle.transposed);
        _sort();
      });
    }
  }

  @override
  void dispose() {
    _completer?.operation.cancel();
    _completer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingImage) {
      return const Center(child: CircularProgressIndicator());
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
            painter: PixelSortingDemoPainter(
              pixels: widget.pixelSortStyle.transposed
                  ? _transposedPixels
                  : _pixels,
              transposed: widget.pixelSortStyle.transposed,
              imageSize: _imageSize,
              showThreshold: widget.showThreshold,
              thresholdMax: widget.thresholdMax,
              thresholdMin: widget.thresholdMin,
            ),
          ),
        ),
      ),
    );
  }
}

class PixelSortingDemoPainter extends CustomPainter {
  PixelSortingDemoPainter({
    required this.pixels,
    required this.imageSize,
    this.showThreshold = false,
    this.transposed = false,
    this.thresholdMax = 0.8,
    this.thresholdMin = 0.2,
  });

  final List<HSLColor> pixels;
  final Size imageSize;
  final bool showThreshold;
  final bool transposed;
  final double thresholdMax;
  final double thresholdMin;

  @override
  void paint(Canvas canvas, Size size) {
    if (transposed) {
      final vertices = generateVerticesRaw(
        pixels.length,
        imageSize.height.toInt(),
        transposed: true,
      );
      final colorsRaw = Int32List(vertices.length ~/ 2);
      for (int i = 0; i < colorsRaw.length; i += 6) {
        int color = pixels[i ~/ 6].toColor().value;

        if (showThreshold) {
          if (compare(pixels[i ~/ 6], thresholdMin, thresholdMax)) {
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
    } else {
      final vertices =
          generateVerticesRaw(pixels.length, imageSize.width.toInt());
      final colorsRaw = Int32List(vertices.length ~/ 2);
      for (int i = 0; i < colorsRaw.length; i += 6) {
        int color = pixels[i ~/ 6].toColor().value;
        if (showThreshold) {
          if (compare(pixels[i ~/ 6], thresholdMin, thresholdMax)) {
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

      canvas.drawVertices(verticesRaw, BlendMode.dst, Paint());
    }
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
