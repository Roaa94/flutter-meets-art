import 'dart:math';
import 'dart:ui' as ui;

import 'package:app/algorithms/voronoi_relaxation.dart';
import 'package:app/enums.dart';
import 'package:app/utils/image_utils.dart';
import 'package:app/widgets/camera/stippling_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class StippledWidget extends StatefulWidget {
  const StippledWidget({
    super.key,
    required this.child,
    required this.size,
    this.pointsCount = 200,
    this.weightedCentroids = true,
    this.showPoints = true,
    this.paintColors = true,
    this.showVoronoiPolygons = false,
    this.pointStrokeWidth = 10,
    this.strokePaintingStyle = false,
    this.weightedStrokes = false,
    this.minStroke = 6,
    this.maxStroke = 18,
    this.wiggleFactor,
  });

  final Widget child;
  final Size size;
  final int pointsCount;
  final bool weightedCentroids;
  final bool showPoints;
  final bool paintColors;
  final bool showVoronoiPolygons;
  final double pointStrokeWidth;
  final bool strokePaintingStyle;
  final bool weightedStrokes;
  final double minStroke;
  final double maxStroke;
  final double? wiggleFactor;

  @override
  State<StippledWidget> createState() => _StippledWidgetState();
}

class _StippledWidgetState extends State<StippledWidget>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final random = Random(1);
  final _widgetKey = GlobalKey();
  bool _isLoadingScene = false;
  ByteData? _sceneBytes;
  VoronoiRelaxation? _relaxation;

  void _initRelaxation() {
    if (_sceneBytes == null) return;
    final points = generateRandomPointsFromPixels(
      _sceneBytes!,
      widget.size,
      widget.pointsCount,
      random,
    );
    _relaxation = VoronoiRelaxation(
      points,
      min: const Point(0, 0),
      max: Point(widget.size.width, widget.size.height),
      weighted: widget.weightedCentroids,
      bytes: _sceneBytes,
    );
  }

  Future<void> _loadSceneBytes() async {
    if (_isLoadingScene || _widgetKey.currentContext == null) return;
    setState(() {
      _isLoadingScene = true;
    });
    RenderRepaintBoundary boundary =
        _widgetKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? imageData = await image.toByteData();
    setState(() {
      _isLoadingScene = false;
      _sceneBytes = imageData;
    });
  }

  void _update() {
    _relaxation?.update(0.1, wiggleFactor: widget.wiggleFactor);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) => _update());
    Future.delayed(Duration.zero).then((_) {
      _loadSceneBytes().then((_) {
        _initRelaxation();
        _ticker.start();
      });
    });
  }

  @override
  void didUpdateWidget(covariant StippledWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initRelaxation();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: Stack(
        children: [
          RepaintBoundary(
            key: _widgetKey,
            child: SizedBox(
              width: widget.size.width,
              height: widget.size.height,
              child: widget.child,
            ),
          ),
          if (_sceneBytes != null && _relaxation != null)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black,
                child: CustomPaint(
                  painter: StipplingPainter(
                    relaxation: _relaxation!,
                    paintColors: widget.paintColors,
                    mode: widget.showVoronoiPolygons
                        ? StippleMode.polygons
                        : widget.showPoints
                            ? StippleMode.dots
                            : widget.strokePaintingStyle
                                ? StippleMode.circles
                                : StippleMode.polygons,
                    pointStrokeWidth: widget.pointStrokeWidth,
                    minStroke: widget.minStroke,
                    maxStroke: widget.maxStroke,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
