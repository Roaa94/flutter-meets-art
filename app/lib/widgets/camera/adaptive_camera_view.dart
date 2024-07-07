import 'dart:developer';
import 'dart:typed_data';

import 'package:app/utils.dart';
import 'package:camera_macos/camera_macos.dart';
import 'package:flutter/material.dart';

const videoWidth = 960.0;
const videoHeight = 540.0;

class AdaptiveCameraView extends StatefulWidget {
  const AdaptiveCameraView({
    super.key,
    required this.imageStream,
  });

  final ValueChanged<ByteData> imageStream;

  @override
  State<AdaptiveCameraView> createState() => _AdaptiveCameraViewState();
}

class _AdaptiveCameraViewState extends State<AdaptiveCameraView> {
  CameraMacOSController? macOSController;
  GlobalKey cameraKey = GlobalKey();
  GlobalKey cameraRenderBoxKey = GlobalKey();
  List<CameraMacOSDevice> _videoDevices = [];
  String? _selectedVideoDeviceId;

  Future<void> _loadPixelsFromStreamedImage(
    CameraImageData? streamedImage,
  ) async {
    if (streamedImage != null) {
      var decodedImage =
          await decodeImageFromList(argb2bitmap(streamedImage).bytes);
      final imageBytes = await decodedImage.toByteData();
      if (imageBytes != null) {
        widget.imageStream(imageBytes);
      }
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

  @override
  void initState() {
    super.initState();
    _listVideoDevices();
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
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    }

    return CameraMacOSView(
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
    );
  }
}
