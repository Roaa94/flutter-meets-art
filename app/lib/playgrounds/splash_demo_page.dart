import 'package:app/app.dart';
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
          scale: 1.2,
          child: const CameraImageStipplingDemo(
            weightedStrokes: true,
            mode: StippleMode.dots,
            showPoints: true,
            showDevicesDropdown: false,
            minStroke: 5,
            maxStroke: 15,
            pointsCount: 2000,
            strokePaintingStyle: true,
          ),
        ),
      ),
    );
  }
}
