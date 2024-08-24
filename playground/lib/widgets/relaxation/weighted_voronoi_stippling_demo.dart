import 'dart:math';

import 'package:playground/algorithms/voronoi_relaxation.dart';
import 'package:playground/app.dart';
import 'package:playground/utils/image_utils.dart';
import 'package:playground/widgets/camera/stippling_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class WeightedVoronoiStipplingDemo extends StatefulWidget {
  const WeightedVoronoiStipplingDemo({
    super.key,
    this.pointsCount = 100,
    this.showImage = false,
    this.showPoints = true,
    this.paintColors = true,
    this.showVoronoiPolygons = true,
    this.trigger = false,
    this.weightedCentroids = true,
    this.pointStrokeWidth = 5,
    this.imagePath = 'assets/images/dash.jpg',
    this.strokePaintingStyle = false,
    this.weightedStrokes = false,
    this.minStroke = 6,
    this.maxStroke = 15,
    this.wiggleFactor,
  });

  final int pointsCount;
  final bool showImage;
  final bool showPoints;
  final bool paintColors;
  final bool showVoronoiPolygons;
  final bool trigger;
  final bool weightedCentroids;
  final double pointStrokeWidth;
  final String imagePath;
  final bool strokePaintingStyle;
  final bool weightedStrokes;
  final double minStroke;
  final double maxStroke;
  final double? wiggleFactor;

  @override
  State<WeightedVoronoiStipplingDemo> createState() =>
      _WeightedVoronoiStipplingDemoState();
}

class _WeightedVoronoiStipplingDemoState
    extends State<WeightedVoronoiStipplingDemo>
    with SingleTickerProviderStateMixin {
  bool _isLoadingImage = false;
  late ByteData? _imageBytes;
  Size _imageSize = const Size(0, 0);
  final random = Random(1);
  late final Ticker _ticker;

  VoronoiRelaxation? _relaxation;

  void _init() {
    final points = generateRandomPointsFromPixels(
      _imageBytes!,
      _imageSize,
      widget.pointsCount,
      random,
    );
    _relaxation = VoronoiRelaxation(
      points,
      min: const Point(0, 0),
      max: Point(_imageSize.width, _imageSize.height),
      weighted: widget.weightedCentroids,
      bytes: _imageBytes,
    );
  }

  void _update() {
    _relaxation?.update(1, wiggleFactor: widget.wiggleFactor);
    setState(() {});
  }

  Future<void> _loadImagePixels() async {
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

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) => _update());
    _loadImagePixels().then((_) {
      if (_imageSize == const Size(0, 0) || _imageBytes == null) {
        return;
      }
      _init();
      _ticker.start();
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WeightedVoronoiStipplingDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger) {
      if (_ticker.isActive) _ticker.stop();
      _ticker.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingImage) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_imageBytes == null) {
      return const Center(
        child: Text('Failed to load image!'),
      );
    }
    return Center(
      child: SizedBox(
        width: _imageSize.width,
        height: _imageSize.height,
        child: Stack(
          children: [
            if (widget.showImage)
              Positioned.fill(
                child: Image.asset(widget.imagePath),
              ),
            if (_relaxation != null)
              Positioned.fill(
                child: CustomPaint(
                  painter: StipplingPainter(
                    relaxation: _relaxation!,
                    paintColors: widget.paintColors,
                    mode: widget.showVoronoiPolygons
                        ? StippleMode.polygons
                        : widget.showPoints
                            ? widget.strokePaintingStyle
                                ? StippleMode.circles
                                : StippleMode.dots
                            : StippleMode.polygons,
                    pointStrokeWidth: widget.pointStrokeWidth,
                    minStroke: widget.minStroke,
                    maxStroke: widget.maxStroke,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
