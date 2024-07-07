import 'dart:developer';
import 'dart:math' hide log;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:app/algorithms/voronoi_relaxation.dart';
import 'package:app/enums.dart';
import 'package:app/utils.dart';
import 'package:camera_macos/camera_macos.dart';
import 'package:flutter/material.dart';

/// Low resolution - 480p (640x480)
/// Medium resolution - 540p (960x540)
const videoWidth = 960;
const videoHeight = 540;

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
  CameraMacOSController? macOSController;
  GlobalKey cameraKey = GlobalKey();
  List<CameraMacOSDevice> _videoDevices = [];
  String? _selectedVideoDeviceId;
  final random = Random(1);
  ByteData? _cameraImagePixels;
  final _videoSize = Size(
    videoWidth.toDouble(),
    videoHeight.toDouble(),
  );

  VoronoiRelaxation? _relaxation;
  CameraImageData? _streamedImage;

  void _init() {
    if (_cameraImagePixels == null) return;
    final points = generateRandomPointsFromPixels(
      _cameraImagePixels!,
      _videoSize,
      widget.pointsCount,
      random,
    );
    _relaxation = VoronoiRelaxation(
      points,
      min: const Point(0, 0),
      max: Point(_videoSize.width, _videoSize.height),
      weighted: widget.weightedCentroids,
      bytes: _cameraImagePixels,
      minStroke: widget.minStroke,
      maxStroke: widget.maxStroke,
    );
  }

  void _update() {
    _relaxation?.update(
      0.1,
      bytes: _cameraImagePixels,
      wiggleFactor: widget.wiggleFactor,
    );
    if (mounted) setState(() {});
  }

  Future<void> _loadPixelsFromStreamedImage(
    CameraImageData? streamedImage,
  ) async {
    if (streamedImage != null) {
      var decodedImage =
          await decodeImageFromList(argb2bitmap(streamedImage).bytes);
      final imageBytes = await decodedImage.toByteData();
      _streamedImage = streamedImage;
      _cameraImagePixels = imageBytes;
      if (!_initialized) {
        _init();
      }
      _initialized = true;
      _update();
    }
  }

  Future<void> _listVideoDevices() async {
    try {
      List<CameraMacOSDevice> videoDevices =
          await CameraMacOS.instance.listDevices(
        deviceType: CameraMacOSDeviceType.video,
      );
      log('videoDevices: ${videoDevices.map((v) => v.localizedName).join(', ')}');
      setState(() {
        _videoDevices = videoDevices;
      });
    } catch (e) {
      log('Error listing videos!');
      log(e.toString());
    }
  }

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _listVideoDevices();
  }

  @override
  void didUpdateWidget(covariant CameraImageStipplingDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    if (macOSController != null && !macOSController!.isDestroyed) {
      log('Disposing camera...');
      macOSController!.stopImageStream();
      macOSController!.destroy();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedVideoDeviceId == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _videoDevices
              .map(
                (device) => GestureDetector(
                  onTap: () => setState(() {
                    _selectedVideoDeviceId = device.deviceId;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      device.localizedName ?? device.deviceId,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    }

    return SizedBox.expand(
      child: Stack(
        children: [
          if (_selectedVideoDeviceId != null)
            Positioned(
              width: videoWidth.toDouble(),
              height: videoHeight.toDouble(),
              child: CameraMacOSView(
                key: cameraKey,
                deviceId: _selectedVideoDeviceId,
                fit: BoxFit.cover,
                cameraMode: CameraMacOSMode.photo,
                resolution: PictureResolution.medium,
                pictureFormat: PictureFormat.tiff,
                videoFormat: VideoFormat.mp4,
                onCameraInizialized: (CameraMacOSController controller) {
                  setState(() {
                    macOSController = controller;
                  });
                  macOSController?.startImageStream((image) {
                    _loadPixelsFromStreamedImage(image);
                  });
                },
                onCameraDestroyed: () {
                  log('Camera destroyed!');
                  return const Text('Camera Destroyed!');
                },
                toggleTorch: Torch.off,
                enableAudio: false,
              ),
            ),
          if (_streamedImage != null)
            Positioned(
              left: 0,
              top: 0,
              width: videoWidth.toDouble(),
              height: videoHeight.toDouble(),
              child: Image.memory(
                argb2bitmap(_streamedImage!).bytes,
                width: videoWidth.toDouble(),
              ),
            ),
          if (_cameraImagePixels != null && _relaxation != null)
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
