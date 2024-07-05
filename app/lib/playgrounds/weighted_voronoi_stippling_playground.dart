import 'package:app/widgets/relaxation/weighted_voronoi_stippling_demo.dart';
import 'package:flutter/material.dart';

class WeightedVoronoiStipplingPlayground extends StatelessWidget {
  const WeightedVoronoiStipplingPlayground({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: WeightedVoronoiStipplingDemo(
        pointsCount: 2000,
        showImage: false,
        showVoronoiPolygons: false,
        showPoints: true,
        paintColors: true,
        trigger: true,
        weightedCentroids: true,
        weightedStrokes: true,
        minStroke: 5,
        maxStroke: 20,
        strokePaintingStyle: true,
        wiggleFactor: 0.2,
        imagePath: 'assets/images/ftcon-europe-logo.png',
      ),
    );
  }
}
