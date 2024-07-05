import 'package:app/widgets/relaxation/camera_image_stippling_demo.dart';
import 'package:flutter/material.dart';

class SplashDemoPage extends StatelessWidget {
  const SplashDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Transform.scale(
          scale: 1.7,
          child: const CameraImageStipplingDemo(
            weightedStrokes: true,
            showVoronoiPolygons: false,
            showPoints: true,
            showDevicesDropdown: false,
            minStroke: 3,
            maxStroke: 15,
            pointsCount: 2000,
            strokePaintingStyle: true,
          ),
        ),
      ),
    );
  }
}
