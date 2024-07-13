import 'package:app/enums.dart';
import 'package:app/widgets/camera/camera_image_stippling_demo.dart';
import 'package:flutter/material.dart';

class SplashDemoPage extends StatelessWidget {
  const SplashDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final size = constraints.biggest;
          final pointsCount = size.width < 500
              ? 700
              : size.width < 1000
                  ? 1000
                  : 3000;

          return CameraImageStipplingDemo(
            size: constraints.biggest,
            weightedStrokes: true,
            mode: StippleMode.circles,
            showPoints: true,
            showDevicesDropdown: false,
            minStroke: 7,
            maxStroke: 25,
            wiggleFactor: 1,
            pointsCount: pointsCount,
          );
        },
      ),
    );
  }
}
