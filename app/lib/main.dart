import 'package:app/app.dart';
import 'package:app/playgrounds/camera_image_stippling_playground.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: WeightedVoronoiStippling(
          showVoronoiPolygons: false,
          showImage: false,
          pointsCount: 2000,
          animate: true,
          weightedCentroids: true,
        ),
      ),
    );
  }
}
