import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:app/widgets/camera/raw_image_pixels_painter.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class CameraWebPlaygroundPage extends StatelessWidget {
  const CameraWebPlaygroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CameraWebPlayground(),
    );
  }
}

/// CameraWebPlaygroundPage is the Main Application.
class CameraWebPlayground extends StatefulWidget {
  /// Default Constructor
  const CameraWebPlayground({super.key});

  @override
  State<CameraWebPlayground> createState() => _CameraWebPlaygroundState();
}

class _CameraWebPlaygroundState extends State<CameraWebPlayground>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  CameraController? _cameraController;
  ByteData? _imageBytes;
  List<CameraDescription> _devices = [];
  CameraDescription? _selectedDevice;

  GlobalKey cameraRenderBoxKey = GlobalKey();

  Future<void> _init() async {
    if (_selectedDevice == null) return;
    try {
      _cameraController = CameraController(
        _selectedDevice!,
        ResolutionPreset.low,
        enableAudio: false,
      );
      await _cameraController?.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    }
  }

  Future<void> _loadPixelsFromRepaintBoundary() async {
    if (cameraRenderBoxKey.currentContext == null) return;
    RenderRepaintBoundary boundary = cameraRenderBoxKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage();
    ByteData? imageBytes =
        await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (imageBytes != null) {
      _imageBytes = imageBytes;
    }
  }

  Future<void> _listVideoDevices() async {
    try {
      final devices = await availableCameras();
      setState(() {
        _devices = devices;
      });
    } catch (e) {
      log('Error listing devices!');
      log(e.toString());
    }
  }

  Future<void> _handleSelectVideoDevice(CameraDescription device) async {
    setState(() {
      _selectedDevice = device;
    });
    await _init();
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    _loadPixelsFromRepaintBoundary();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _listVideoDevices();
    _ticker = createTicker(_onTick);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedDevice == null) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              _devices.length,
              (i) => GestureDetector(
                onTap: () => _handleSelectVideoDevice(_devices[i]),
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
                    _devices[i].name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox.expand(
      child: Stack(
        children: [
          // Positioned.fill(
          //   child: RepaintBoundary(
          //     key: cameraRenderBoxKey,
          //     child: CameraPreview(_cameraController!),
          //   ),
          // ),
          // if (_imageBytes != null)
          //   Positioned.fill(
          //     child: Image.memory(_imageBytes!.buffer.asUint8List()),
          //   ),
          RepaintBoundary(
            key: cameraRenderBoxKey,
            child: _cameraWidget(context, _cameraController),
          ),
          if (_imageBytes != null)
            Positioned.fill(
              child: CustomPaint(
                painter: RawImagePixelsPainter(
                  bytes: _imageBytes!,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _cameraWidget(context, controller) {
    var camera = controller.value;
    // fetch screen size
    final size = MediaQuery.of(context).size;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * camera.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(controller),
      ),
    );
  }
}
