import 'package:playground/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_friends_24_slides/styles/app_colors.dart';
import 'package:flutter_friends_24_slides/widgets/controls.dart';
import 'package:flutter_friends_24_slides/widgets/window_frame.dart';

class RandomizedImageStipplingDemo extends StatefulWidget {
  const RandomizedImageStipplingDemo({super.key});

  @override
  State<RandomizedImageStipplingDemo> createState() =>
      _RandomizedImageStipplingDemoState();
}

class _RandomizedImageStipplingDemoState
    extends State<RandomizedImageStipplingDemo> {
  static const double iconSize = 30;
  static const double controlsSize = 52;
  static const double borderRadius = 15;
  static const Color activeColor = AppColors.primary;

  bool showImage = true;
  bool showPoints = false;
  int pointsCount = 1400;
  double angleIncrement = 17;
  double radiusIncrement = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
      child: Stack(
        children: [
          WindowFrame(
            label: 'Random',
            child: SizedBox.expand(
              child: ColoredBox(
                color: Colors.white,
                child: WeightedVoronoiStipplingDemo(
                  showImage: showImage,
                  showVoronoiPolygons: false,
                  pointsCount: 2000,
                  showPoints: showPoints,
                  paintColors: false,
                  trigger: false,
                  weightedCentroids: false,
                ),
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
                    onTap: () => setState(() => showImage = !showImage),
                    size: controlsSize,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                    iconSize: iconSize,
                    icon: Icons.image,
                    color: showImage ? activeColor : Colors.black,
                  ),
                  const SizedBox(width: 10),
                  ControlsButton(
                    onTap: () => setState(() => showPoints = !showPoints),
                    size: controlsSize,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                    iconSize: iconSize,
                    icon: Icons.circle,
                    color: showPoints ? activeColor : Colors.black,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
