import 'dart:typed_data';

import 'package:playground/widgets/camera/macos_camera_view.dart';
import 'package:playground/widgets/camera/mobile_camera_view.dart';
import 'package:flutter/material.dart';

class AdaptiveCameraView extends StatelessWidget {
  const AdaptiveCameraView({super.key, required this.imageStream});

  final ValueChanged<ByteData> imageStream;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.macOS:
        return MacOSCameraView(imageStream: imageStream);
      case TargetPlatform.iOS:
      case TargetPlatform.android:
        return MobileCameraView(imageStream: imageStream);
      default:
        return const Center(
          child: Text('Platform not supported!'),
        );
    }
  }
}
