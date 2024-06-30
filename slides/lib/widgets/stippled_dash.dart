import 'package:app/widgets/relaxation/weighted_voronoi_stippling_demo.dart';
import 'package:flutter/material.dart';

class StippledDash extends StatelessWidget {
  const StippledDash({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -100,
      right: -330,
      child: Opacity(
        opacity: 0.2,
        child: Transform.scale(
          scale: 1.65,
          alignment: Alignment.bottomRight,
          child: const WeightedVoronoiStipplingDemo(
            showVoronoiPolygons: false,
            paintColors: true,
            showImage: false,
            showPoints: true,
            pointsCount: 1000,
            weightedStrokes: true,
            minStroke: 8,
            maxStroke: 23,
            // strokePaintingStyle: true,
            imagePath: 'assets/images/dash.jpg',
            animate: true,
          ),
        ),
      ),
    );
  }
}
