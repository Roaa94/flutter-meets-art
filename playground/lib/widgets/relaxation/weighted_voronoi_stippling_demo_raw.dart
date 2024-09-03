import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:playground/algorithms/voronoi_relaxation.dart';
import 'package:playground/utils/image_utils.dart';
import 'package:playground/utils/math_utils.dart';
import 'package:playground/utils/painting_utils.dart';

class WeightedVoronoiStipplingDemoRaw extends StatefulWidget {
  const WeightedVoronoiStipplingDemoRaw({
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
    this.randomSeed = false,
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
  final bool randomSeed;

  @override
  State<WeightedVoronoiStipplingDemoRaw> createState() =>
      _WeightedVoronoiStipplingDemoRawState();
}

class _WeightedVoronoiStipplingDemoRawState
    extends State<WeightedVoronoiStipplingDemoRaw>
    with SingleTickerProviderStateMixin {
  bool _isLoadingImage = false;
  late ByteData? _imageBytes;
  Size _imageSize = const Size(0, 0);
  final random = Random(1);
  late final Ticker _ticker;

  VoronoiRelaxation? _relaxation;

  void _init() {
    final points = widget.randomSeed
        ? generateRandomPoints(
            random: random,
            canvasSize: _imageSize,
            count: widget.pointsCount,
          )
        : generateRandomPointsFromPixels(
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
    _relaxation?.update(0.1, wiggleFactor: widget.wiggleFactor);
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
      if (widget.trigger) {
        _ticker.start();
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WeightedVoronoiStipplingDemoRaw oldWidget) {
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
                  painter: WeightedVoronoiStipplingPainter(
                    relaxation: _relaxation!,
                    bytes: _imageBytes!,
                    paintColors: widget.paintColors,
                    showVoronoiPolygons: widget.showVoronoiPolygons,
                    showPoints: widget.showPoints,
                    pointStrokeWidth: widget.pointStrokeWidth,
                    strokePaintingStyle: widget.strokePaintingStyle,
                    weightedStrokes: widget.weightedStrokes,
                    minStroke: widget.minStroke,
                    maxStroke: widget.maxStroke,
                    pointsColor: Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class WeightedVoronoiStipplingPainter extends CustomPainter {
  WeightedVoronoiStipplingPainter({
    required this.relaxation,
    required this.bytes,
    this.paintColors = true,
    this.showVoronoiPolygons = true,
    this.showPoints = true,
    this.pointStrokeWidth = 2,
    this.strokePaintingStyle = false,
    this.weightedStrokes = false,
    this.minStroke = 4,
    this.maxStroke = 8,
    this.pointsColor = Colors.black,
  });

  final VoronoiRelaxation relaxation;
  final ByteData bytes;
  final bool paintColors;
  final bool showPoints;
  final bool showVoronoiPolygons;
  final double pointStrokeWidth;
  final bool strokePaintingStyle;
  final bool weightedStrokes;
  final double minStroke;
  final double maxStroke;
  final Color pointsColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (showVoronoiPolygons) {
      final cells = relaxation.voronoi.cells;
      for (int j = 0; j < cells.length; j++) {
        final path = Path()..moveTo(cells[j][0].dx, cells[j][0].dy);
        for (int i = 1; i < cells[j].length; i++) {
          path.lineTo(cells[j][i].dx, cells[j][i].dy);
        }
        path.close();

        if (paintColors) {
          canvas.drawPath(
            path,
            Paint()..color = Color(relaxation.colors[j]),
          );
        }
        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.black,
        );
      }
    }

    if (showPoints) {
      for (int i = 0; i < relaxation.coords.length; i += 2) {
        double stroke = pointStrokeWidth;
        if (weightedStrokes) {
          stroke =
              map(relaxation.strokeWeights[i ~/ 2], 0, 1, minStroke, maxStroke);
        }
        final color =
            paintColors ? Color(relaxation.colors[i ~/ 2]) : pointsColor;
        final paint = Paint()..color = color;
        if (strokePaintingStyle) {
          paint
            ..style = PaintingStyle.stroke
            ..strokeWidth = stroke * 0.15;
        }
        canvas.drawCircle(
          Offset(relaxation.coords[i], relaxation.coords[i + 1]),
          stroke / 2,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
