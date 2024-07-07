import 'dart:math' hide log;
import 'dart:typed_data';

import 'package:app/algorithms/voronoi_relaxation.dart';
import 'package:app/enums.dart';
import 'package:app/utils.dart';
import 'package:app/widgets/camera/adaptive_camera_view.dart';
import 'package:app/widgets/camera/camera_image_stippling_painter.dart';
import 'package:flutter/material.dart';

/// Low resolution - 480p (640x480)
/// Medium resolution - 540p (960x540)
const videoWidth = 960.0;
const videoHeight = 540.0;

class CameraImageStipplingDemo extends StatefulWidget {
  const CameraImageStipplingDemo({
    super.key,
    this.weightedCentroids = true,
    this.paintColors = true,
    this.minStroke = 8,
    this.maxStroke = 18,
    this.weightedStrokes = true,
    this.mode = StippleMode.dots,
    this.strokePaintingStyle = true,
    this.wiggleFactor = 0.2,
    this.showDevicesDropdown = false,
    this.showPoints = false,
    this.pointsCount = 2000,
  });

  final bool weightedCentroids;
  final bool paintColors;
  final double minStroke;
  final double maxStroke;
  final bool weightedStrokes;
  final StippleMode mode;
  final bool strokePaintingStyle;
  final double wiggleFactor;
  final bool showDevicesDropdown;
  final bool showPoints;
  final int pointsCount;

  @override
  CameraImageStipplingDemoState createState() =>
      CameraImageStipplingDemoState();
}

class CameraImageStipplingDemoState extends State<CameraImageStipplingDemo> {
  final random = Random(1);
  ByteData? _cameraImage;
  final _videoSize = const Size(videoWidth, videoHeight);

  VoronoiRelaxation? _relaxation;
  bool _initialized = false;

  void _init() {
    if (_cameraImage == null) return;
    final points = generateRandomPointsFromPixels(
      _cameraImage!,
      _videoSize,
      widget.pointsCount,
      random,
    );
    _relaxation = VoronoiRelaxation(
      points,
      min: const Point(0, 0),
      max: Point(_videoSize.width, _videoSize.height),
      weighted: widget.weightedCentroids,
      bytes: _cameraImage,
      minStroke: widget.minStroke,
      maxStroke: widget.maxStroke,
    );
  }

  void _update() {
    _relaxation?.update(
      0.1,
      bytes: _cameraImage,
      wiggleFactor: widget.wiggleFactor,
    );
    if (mounted) setState(() {});
  }

  void _handleImageStream(ByteData image) {
    _cameraImage = image;
    if (!_initialized) _init();
    _initialized = true;
    _update();
  }

  @override
  void didUpdateWidget(covariant CameraImageStipplingDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(
            width: videoWidth,
            height: videoHeight,
            child: AdaptiveCameraView(imageStream: _handleImageStream),
          ),
          if (_relaxation != null)
            Positioned.fill(
              child: CustomPaint(
                painter: CameraImageStipplingDemoPainter(
                  relaxation: _relaxation!,
                  mode: widget.mode,
                  paintColors: widget.paintColors,
                  pointStrokeWidth: 10,
                  weightedStrokesMode: widget.weightedStrokes,
                  minStroke: widget.minStroke,
                  maxStroke: widget.maxStroke,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
