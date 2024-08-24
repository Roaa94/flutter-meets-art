import 'dart:math' hide log;
import 'dart:typed_data';

import 'package:playground/algorithms/voronoi_relaxation.dart';
import 'package:playground/enums.dart';
import 'package:playground/utils/painting_utils.dart';
import 'package:playground/widgets/camera/adaptive_camera_view.dart';
import 'package:playground/widgets/camera/stippling_painter.dart';
import 'package:flutter/material.dart';

class CameraImageStipplingDemo extends StatefulWidget {
  const CameraImageStipplingDemo({
    super.key,
    this.paintColors = true,
    this.minStroke = 8,
    this.maxStroke = 18,
    this.mode = StippleMode.dots,
    this.wiggleFactor = 0.2,
    this.pointsCount = 2000,
    required this.size,
  });

  final bool paintColors;
  final double minStroke;
  final double maxStroke;
  final StippleMode mode;
  final double wiggleFactor;
  final int pointsCount;
  final Size size;

  @override
  CameraImageStipplingDemoState createState() =>
      CameraImageStipplingDemoState();
}

class CameraImageStipplingDemoState extends State<CameraImageStipplingDemo> {
  final random = Random(1);
  ByteData? _cameraImage;

  VoronoiRelaxation? _relaxation;
  Float32List? _points;
  bool _initialized = false;

  void _initPoints() {
    _points = generateRandomPoints(
      random: random,
      count: widget.pointsCount,
      canvasSize: widget.size,
      padding: 0,
    );
  }

  void _initRelaxation() {
    if (_cameraImage == null || _points == null) return;

    _relaxation = VoronoiRelaxation(
      _points!,
      min: const Point(0, 0),
      max: Point(widget.size.width, widget.size.height),
      weighted: true,
      bytes: _cameraImage,
      minStroke: widget.minStroke,
      maxStroke: widget.maxStroke,
    );
  }

  void _update() {
    _relaxation?.update(
      0.5,
      bytes: _cameraImage,
      wiggleFactor: widget.wiggleFactor,
    );
    if (mounted) setState(() {});
  }

  void _handleImageStream(ByteData image) {
    _cameraImage = image;
    if (!_initialized) {
      _initPoints();
      _initRelaxation();
    }
    _initialized = true;
    _update();
  }

  @override
  void didUpdateWidget(covariant CameraImageStipplingDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.size != widget.size ||
        oldWidget.pointsCount != widget.pointsCount) {
      _initPoints();
    }
    _initRelaxation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AdaptiveCameraView(imageStream: _handleImageStream),
        if (_relaxation != null)
          Positioned.fill(
            child: CustomPaint(
              painter: StipplingPainter(
                relaxation: _relaxation!,
                mode: widget.mode,
                paintColors: widget.paintColors,
                pointStrokeWidth: 10,
                minStroke: widget.minStroke,
                maxStroke: widget.maxStroke,
              ),
            ),
          ),
      ],
    );
  }
}
