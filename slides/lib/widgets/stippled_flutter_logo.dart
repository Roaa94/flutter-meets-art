import 'package:playground/widgets/relaxation/weighted_voronoi_stippling_demo.dart';
import 'package:flutter/material.dart';

class StippledFlutterLogo extends StatelessWidget {
  const StippledFlutterLogo({
    super.key,
    this.scale = 1,
  });

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      right: 70,
      child: Transform.scale(
        scale: scale,
        alignment: Alignment.bottomRight,
        child: const Opacity(
          opacity: 0.2,
          child: WeightedVoronoiStipplingDemo(
            showVoronoiPolygons: false,
            paintColors: true,
            showImage: false,
            showPoints: true,
            pointsCount: 2000,
            weightedStrokes: true,
            minStroke: 8,
            wiggleFactor: 0.5,
            trigger: false,
            imagePath: 'assets/images/flutter-logo.png',
            maxStroke: 20,
            // strokePaintingStyle: true,
          ),
        ),
      ),
    );
    ;
  }
}
