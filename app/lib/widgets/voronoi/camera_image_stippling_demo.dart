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
  });

  final bool weightedCentroids;
  final bool paintColors;
  final double minStroke;
  final double maxStroke;
  final bool weightedStrokes;
  final bool showVoronoiPolygons;
  final bool strokePaintingStyle;
  final double wiggleFactor;

  @override
  CameraImageStipplingDemoState createState() =>
      CameraImageStipplingDemoState();
}

class CameraImageStipplingDemoState extends State<CameraImageStipplingDemo> {
  CameraMacOSController? macOSController;
  GlobalKey cameraKey = GlobalKey();
  List<CameraMacOSDevice> videoDevices = [];
  String? selectedVideoDevice;
  final random = Random(1);
  ByteData? _cameraImagePixels;
  final _videoSize = Size(
    videoWidth.toDouble(),
    videoHeight.toDouble(),
  );

  VoronoiRelaxation? _relaxation;
  CameraImageData? _streamedImage;

  void _init() {
    final points = generateRandomPointsFromPixels(
      _cameraImagePixels!,
      _videoSize,
      2000,
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
    setState(() {});
  }

  Future<void> _loadPixelsFromStreamedImage(
      CameraImageData? streamedImage) async {
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
      setState(() {});
    }
  }

  Future<void> _listVideoDevices() async {
    try {
      List<CameraMacOSDevice> videoDevices =
          await CameraMacOS.instance.listDevices(
        deviceType: CameraMacOSDeviceType.video,
      );
      setState(() {
        this.videoDevices = videoDevices;
        if (videoDevices.isNotEmpty) {
          selectedVideoDevice = videoDevices.first.deviceId;
        }
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
      macOSController!.stopImageStream();
      macOSController!.destroy();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: DropdownButton<String>(
                    elevation: 3,
                    isExpanded: true,
                    value: selectedVideoDevice,
                    underline: Container(color: Colors.transparent),
                    items: videoDevices.map((CameraMacOSDevice device) {
                      return DropdownMenuItem(
                        value: device.deviceId,
                        child: Text(device.localizedName ?? device.deviceId),
                      );
                    }).toList(),
                    onChanged: (String? newDeviceID) {
                      setState(() {
                        selectedVideoDevice = newDeviceID;
                      });
                    },
                  ),
                ),
              ),
              MaterialButton(
                color: Colors.lightBlue,
                textColor: Colors.white,
                onPressed: _listVideoDevices,
                child: const Text('List video devices'),
              ),
            ],
          ),
          SizedBox(
            width: videoWidth.toDouble(),
            height: videoHeight.toDouble(),
            child: Stack(
              children: [
                Positioned(
                  width: videoWidth.toDouble(),
                  height: videoHeight.toDouble(),
                  child: CameraMacOSView(
                    key: cameraKey,
                    deviceId: selectedVideoDevice,
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
                    toggleTorch: Torch.on,
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