import 'package:flutter/material.dart';
import 'package:flutter_friends_24_slides/widgets/window_frame.dart';
import 'package:playground/app.dart';

class RandomlyDistributedPointsDemo extends StatelessWidget {
  const RandomlyDistributedPointsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
      child: Center(
        child: SizedBox(
          width: 800,
          height: 640,
          child: Stack(
            children: [
              WindowFrame(
                label: 'Random',
                child: WeightedVoronoiStipplingDemo(
                  showImage: true,
                  showVoronoiPolygons: false,
                  strokePaintingStyle: false,
                  pointsCount: 2000,
                  showPoints: true,
                  paintColors: false,
                  trigger: false,
                  weightedCentroids: true,
                  randomSeed: true,
                  bgColor: Colors.white,
                  pointsColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
