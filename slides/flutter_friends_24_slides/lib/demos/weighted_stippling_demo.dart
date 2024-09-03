import 'package:flutter/material.dart';
import 'package:flutter_friends_24_slides/styles/app_colors.dart';
import 'package:flutter_friends_24_slides/widgets/controls.dart';
import 'package:flutter_friends_24_slides/widgets/window_frame.dart';
import 'package:playground/app.dart';

class WeightedStipplingDemo extends StatefulWidget {
  const WeightedStipplingDemo({super.key});

  @override
  State<WeightedStipplingDemo> createState() => _WeightedStipplingDemoState();
}

class _WeightedStipplingDemoState extends State<WeightedStipplingDemo> {
  static const double iconSize = 30;
  static const double controlsSize = 52;
  static const double borderRadius = 15;

  bool showVoronoi = false;
  bool showPoints = true;
  bool trigger = false;
  int pointsCount = 1400;
  double angleIncrement = 17;
  double radiusIncrement = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
      child: Center(
        child: SizedBox(
          width: 800,
          height: 640,
          child: Stack(
            children: [
              WindowFrame(
                label: 'Weighted Stippling',
                child: SizedBox.expand(
                  child: WeightedVoronoiStipplingDemo(
                    showImage: false,
                    showVoronoiPolygons: showVoronoi,
                    pointsCount: 4000,
                    pointStrokeWidth: 5,
                    minStroke: 5,
                    maxStroke: 12,
                    paintColors: false,
                    showPoints: showPoints,
                    trigger: trigger,
                    weightedCentroids: true,
                    weightedStrokes: true,
                    randomSeed: true,
                    lerpFactor: 0.1,
                    pointsColor: Colors.black,
                    bgColor: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 1,
                right: 0,
                left: 0,
                child: RepaintBoundary(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ControlsButton(
                        onTap: () => setState(() => trigger = !trigger),
                        size: controlsSize,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(borderRadius),
                          topRight: Radius.circular(borderRadius),
                        ),
                        iconSize: iconSize,
                        icon: Icons.play_arrow,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
