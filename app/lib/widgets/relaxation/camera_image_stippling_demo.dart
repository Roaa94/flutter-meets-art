import 'dart:developer';
import 'dart:math' hide log;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:app/algorithms/voronoi_relaxation.dart';
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
    this.showVoronoiPolygons = false,
    this.strokePaintingStyle = true,
    this.wiggleFactor = 0.2,
    this.showDevicesDropdown = false,
    this.pointsCount = 2000,
  });

  final bool weightedCentroids;
  final bool paintColors;
  final double minStroke;
  final double maxStroke;
  final bool weightedStrokes;
  final bool showVoronoiPolygons;
  final bool strokePaintingStyle;
  final double wiggleFactor;
  final bool showDevicesDropdown;
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

    return SizedBox(
      width: videoWidth.toDouble(),
      height: videoHeight.toDouble(),
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
                // onCameraLoading: (_) => const SizedBox.expand(
                //   child: ColoredBox(
                //     color: Colors.black,
                //   ),
                // ),
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
                  paintPoints: true,
                  showVoronoiPolygons: widget.showVoronoiPolygons,
                  paintColors: widget.paintColors,
                  pointStrokeWidth: 10,
                  weightedStrokes: widget.weightedStrokes,
                  minStroke: widget.minStroke,
                  maxStroke: widget.maxStroke,
                  strokePaintingStyle: widget.strokePaintingStyle,
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
    this.paintPoints = false,
    this.showVoronoiPolygons = false,
    this.weightedStrokes = false,
    this.strokePaintingStyle = false,
    this.pointStrokeWidth = 5,
    this.minStroke = 4,
    this.maxStroke = 15,
  });

  final VoronoiRelaxation relaxation;
  final bool paintColors;
  final bool paintPoints;
  final bool weightedStrokes;
  final bool showVoronoiPolygons;
  final bool strokePaintingStyle;
  final double pointStrokeWidth;
  final double minStroke;
  final double maxStroke;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawPaint(Paint()..color = Colors.black);

    if (showVoronoiPolygons && paintColors) {
      final cells = relaxation.voronoi.cells;
      for (int j = 0; j < cells.length; j++) {
        final path = Path()..moveTo(cells[j][0].dx, cells[j][0].dy);
        for (int i = 1; i < cells[j].length; i++) {
          path.lineTo(cells[j][i].dx, cells[j][i].dy);
        }
        path.close();

        canvas.drawPath(
          path,
          Paint()..color = Color(relaxation.colors[j]),
        );
      }
    }

    if (paintPoints && !showVoronoiPolygons) {
      for (int i = 0; i < relaxation.coords.length; i += 2) {
        double stroke = pointStrokeWidth;
        if (weightedStrokes) {
          stroke =
              map(relaxation.strokeWeights[i ~/ 2], 0, 1, minStroke, maxStroke);
        }
        final color =
            paintColors ? Color(relaxation.colors[i ~/ 2]) : Colors.black;
        final paint = Paint()..color = color;
        if (strokePaintingStyle) {
          paint
            ..style = PaintingStyle.stroke
            ..strokeWidth = stroke * 0.1;
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
