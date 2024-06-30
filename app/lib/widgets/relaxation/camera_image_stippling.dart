import 'dart:developer';
import 'dart:math' hide log;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:app/algorithms/delaunay.dart';
import 'package:app/algorithms/voronoi.dart';
import 'package:app/utils.dart';
import 'package:camera_macos/camera_macos.dart';
import 'package:flutter/material.dart';

/// Low resolution - 480p (640x480)
/// Medium resolution - 540p (960x540)
const videoWidth = 960;
const videoHeight = 540;

class CameraImageStippling extends StatefulWidget {
  const CameraImageStippling({super.key});

  @override
  CameraImageStipplingState createState() => CameraImageStipplingState();
}

class CameraImageStipplingState extends State<CameraImageStippling> {
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

  late Float32List points;
  late Float32List centroids;
  late Delaunay delaunay;
  late Voronoi voronoi;
  CameraImageData? _streamedImage;

  void _calculate() {
    delaunay = Delaunay(points);
    delaunay.update();
    voronoi = delaunay.voronoi(
      const Point(0, 0),
      const Point(videoWidth, videoHeight),
    );
    centroids = calcWeightedCentroids(
      delaunay,
      _videoSize,
      _cameraImagePixels!,
    );
    // Uncomment to see original polygon centroids
    // centroids = calcCentroids(voronoi.cells);
  }

  void _init() {
    points = generateRandomPointsFromPixels(
      _cameraImagePixels!,
      _videoSize,
      2000,
      random,
    );
    centroids = points;
    _calculate();
  }

  void _update() {
    points = lerpPoints(points, centroids, 0.5);
    _calculate();
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
  void dispose() {
    super.dispose();
    if (macOSController != null && !macOSController!.isDestroyed) {
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
                if (_cameraImagePixels != null)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: CameraImageStipplingPainter(
                        bytes: _cameraImagePixels!,
                        voronoi: voronoi,
                        delaunay: delaunay,
                        centroids: centroids,
                        points: points,
                        paintPoints: true,
                        paintColors: true,
                        pointStrokeWidth: 10,
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

class CameraImageStipplingPainter extends CustomPainter {
  CameraImageStipplingPainter({
    required this.points,
    required this.centroids,
    required this.voronoi,
    required this.delaunay,
    required this.bytes,
    this.paintColors = false,
    this.paintPoints = false,
    this.showVoronoiPolygons = false,
    this.pointStrokeWidth = 5,
  });

  final Float32List points;
  final Float32List centroids;
  final Delaunay delaunay;
  final Voronoi voronoi;
  final ByteData bytes;
  final bool paintColors;
  final bool paintPoints;
  final bool showVoronoiPolygons;
  final double pointStrokeWidth;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawPaint(Paint()..color = Colors.white);
    final colors = List<Color>.filled(centroids.length ~/ 2, Colors.white);
    if (paintColors) {
      for (int i = 0; i < centroids.length; i += 2) {
        final color = getPixelColorFromBytes(
          bytes: bytes,
          offset: Offset(centroids[i], centroids[i + 1]),
          size: size,
        );
        colors[i ~/ 2] = color;
      }
    }

    if (showVoronoiPolygons) {
      final cells = voronoi.cells;
      for (int j = 0; j < cells.length; j++) {
        final path = Path()..moveTo(cells[j][0].dx, cells[j][0].dy);
        for (int i = 1; i < cells[j].length; i++) {
          path.lineTo(cells[j][i].dx, cells[j][i].dy);
        }
        path.close();

        if (paintColors) {
          canvas.drawPath(
            path,
            Paint()..color = colors[j],
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

    if (paintPoints) {
      if (paintColors) {
        for (int i = 0; i < delaunay.coords.length; i += 2) {
          canvas.drawCircle(
            Offset(delaunay.coords[i], delaunay.coords[i + 1]),
            pointStrokeWidth / 2,
            Paint()..color = colors[i ~/ 2],
          );
        }
      } else {
        canvas.drawRawPoints(
          PointMode.points,
          delaunay.coords,
          Paint()
            ..strokeWidth = pointStrokeWidth
            ..strokeCap = StrokeCap.round
            ..color = Colors.black,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
