import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera_macos/camera_macos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

const frameRate = 10;

class MacOSCameraView extends StatefulWidget {
  const MacOSCameraView({
    super.key,
    required this.imageStream,
  });

  final ValueChanged<ByteData> imageStream;

  @override
  State<MacOSCameraView> createState() => _MacOSCameraViewState();
}

class _MacOSCameraViewState extends State<MacOSCameraView>
    with SingleTickerProviderStateMixin {
  static const tickInterval = Duration(milliseconds: 1000 ~/ frameRate);
  late final Ticker _ticker;

  CameraMacOSController? macOSController;
  GlobalKey cameraKey = GlobalKey();
  GlobalKey cameraRenderBoxKey = GlobalKey();
  List<CameraMacOSDevice> _videoDevices = [];
  String? _selectedVideoDeviceId;

  Duration _lastTick = Duration.zero;

  Future<void> _loadPixelsFromRepaintBoundary() async {
    if (cameraRenderBoxKey.currentContext == null) return;
    RenderRepaintBoundary boundary = cameraRenderBoxKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? imageBytes = await image.toByteData();
    if (imageBytes != null) {
      widget.imageStream(imageBytes);
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

  void _handleSelectVideoDevice(CameraMacOSDevice device) {
    setState(() {
      _selectedVideoDeviceId = device.deviceId;
    });
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    final elapsedDelta = elapsed - _lastTick;
    if (elapsedDelta >= tickInterval) {
      _lastTick += tickInterval;
      _loadPixelsFromRepaintBoundary();
    }
  }

  @override
  void initState() {
    super.initState();
    _listVideoDevices();
    _ticker = createTicker(_onTick);
  }

  @override
  void dispose() {
    super.dispose();
    _ticker.dispose();
    if (macOSController != null && !macOSController!.isDestroyed) {
      log('Disposing camera...');
      macOSController!.destroy();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedVideoDeviceId == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              _videoDevices.length,
              (i) => GestureDetector(
                onTap: () => _handleSelectVideoDevice(_videoDevices[i]),
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
                    _videoDevices[i].localizedName ?? _videoDevices[i].deviceId,
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

    return RepaintBoundary(
      key: cameraRenderBoxKey,
      child: CameraMacOSView(
        key: cameraKey,
        deviceId: _selectedVideoDeviceId,
        fit: BoxFit.cover,
        cameraMode: CameraMacOSMode.photo,
        resolution: PictureResolution.low,
        pictureFormat: PictureFormat.tiff,
        videoFormat: VideoFormat.mp4,
        onCameraLoading: (_) => Container(),
        onCameraInizialized: (CameraMacOSController controller) {
          setState(() {
            macOSController = controller;
          });
        },
        onCameraDestroyed: () {
          log('Camera destroyed!');
          return const Text('Camera Destroyed!');
        },
        toggleTorch: Torch.off,
        enableAudio: false,
      ),
    );
  }
}