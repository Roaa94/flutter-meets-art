import 'package:app/app.dart';
import 'package:flutter/material.dart';

class SplashDemoPage extends StatelessWidget {
  const SplashDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: CameraImageStipplingDemo(
        weightedStrokes: true,
        mode: StippleMode.circles,
        showPoints: true,
        showDevicesDropdown: false,
        minStroke: 5,
        maxStroke: 15,
        pointsCount: 2000,
        strokePaintingStyle: true,
      ),
    );
  }
}
