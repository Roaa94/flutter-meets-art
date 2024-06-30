import 'package:app/widgets/voronoi/weighted_voronoi_stippling_demo.dart';
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
        body: WeightedVoronoiStipplingDemo(
          showVoronoiPolygons: false,
          showImage: false,
          pointsCount: 2000,
          animate: true,
          weightedCentroids: true,
          paintColors: true,
        ),
      ),
    );
  }
}
