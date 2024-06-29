import 'package:app/widgets/voronoi/camera_image_stippling.dart';
import 'package:flutter/material.dart';

class CameraImageStipplingPlayground extends StatelessWidget {
  const CameraImageStipplingPlayground({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CameraImageStippling(),
    );
  }
}
