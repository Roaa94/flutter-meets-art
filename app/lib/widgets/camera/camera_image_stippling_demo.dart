import 'dart:math' hide log;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:app/algorithms/voronoi_relaxation.dart';
import 'package:app/enums.dart';
import 'package:app/utils.dart';
import 'package:app/widgets/camera/adaptive_camera_view.dart';
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
  final _videoSize = Size(
    videoWidth.toDouble(),
    videoHeight.toDouble(),
  );

  VoronoiRelaxation? _relaxation;
  bool _initialized = false;

  void _init() {
    if(_cameraImage == null) return;
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

class CameraImageStipplingDemoPainter extends CustomPainter {
  CameraImageStipplingDemoPainter({
    required this.relaxation,
    this.paintColors = false,
    this.mode = StippleMode.dots,
    this.weightedStrokesMode = false,
    this.pointStrokeWidth = 5,
    this.minStroke = 4,
    this.maxStroke = 15,
  }) {
    bgPaint.color = Colors.black;
    stipplePaints = <Paint>[];
    secondaryStipplePaints = <Paint>[];
    weightedStrokes = Float32List(relaxation.coords.length ~/ 2);
    for (int i = 0; i < relaxation.colors.length; i++) {
      final color = Color(relaxation.colors[i]);
      final paint = Paint()..color = color;
      double stroke = pointStrokeWidth;
      if (weightedStrokesMode) {
        stroke = map(relaxation.strokeWeights[i], 0, 1, minStroke, maxStroke);
        weightedStrokes[i] = stroke;
      }
      if (mode == StippleMode.circles) {
        paint
          ..strokeWidth = stroke * 0.15
          ..style = PaintingStyle.stroke;
      }

      stipplePaints.add(paint);

      final secondaryPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke;
      secondaryStipplePaints.add(secondaryPaint);
    }
  }

  final VoronoiRelaxation relaxation;
  final bool paintColors;
  final StippleMode mode;
  final bool weightedStrokesMode;
  final double pointStrokeWidth;
  final double minStroke;
  final double maxStroke;

  final circlesPaint = Paint();
  late final List<Paint> stipplePaints;
  late final List<Paint> secondaryStipplePaints;
  late final Float32List weightedStrokes;
  final bgPaint = Paint();

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawPaint(bgPaint);
    canvas.save();
    double scaleX = size.width / relaxation.size.width;
    double scaleY = size.height / relaxation.size.height;
    double scale = max(scaleX, scaleY);
    double dx = (size.width - relaxation.size.width * scale) / 2;
    double dy = (size.height - relaxation.size.height * scale) / 2;

    canvas.translate(dx, dy);
    canvas.scale(scale, scale);

    if (mode == StippleMode.polygons || mode == StippleMode.polygonsOutlined) {
      final cells = relaxation.voronoi.cells;
      for (int j = 0; j < cells.length; j++) {
        final path = Path()..moveTo(cells[j][0].dx, cells[j][0].dy);
        for (int i = 1; i < cells[j].length; i++) {
          path.lineTo(cells[j][i].dx, cells[j][i].dy);
        }
        path.close();

        if (mode != StippleMode.polygonsOutlined) {
          canvas.drawPath(path, stipplePaints[j]);
        }

        canvas.drawPath(
          path,
          secondaryStipplePaints[j],
        );
      }
    }

    if (mode == StippleMode.dots || mode == StippleMode.circles) {
      for (int i = 0; i < relaxation.coords.length; i += 2) {
        canvas.drawCircle(
          Offset(relaxation.coords[i], relaxation.coords[i + 1]),
          weightedStrokes[i ~/ 2] / 2,
          stipplePaints[i ~/ 2],
        );
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
