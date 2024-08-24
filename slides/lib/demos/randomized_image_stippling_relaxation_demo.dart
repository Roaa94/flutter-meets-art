import 'package:playground/app.dart';
import 'package:flutter/material.dart';
import 'package:slides/styles/app_colors.dart';
import 'package:slides/widgets/controls.dart';
import 'package:slides/widgets/window_frame.dart';

class RandomizedImageStipplingRelaxationDemo extends StatefulWidget {
  const RandomizedImageStipplingRelaxationDemo({super.key});

  @override
  State<RandomizedImageStipplingRelaxationDemo> createState() =>
      _RandomizedImageStipplingRelaxationDemoState();
}

class _RandomizedImageStipplingRelaxationDemoState
    extends State<RandomizedImageStipplingRelaxationDemo> {
  static const double iconSize = 30;
  static const double controlsSize = 52;
  static const double borderRadius = 15;
  static const Color activeColor = AppColors.primary;

  bool showVoronoi = false;
  bool showPoints = false;
  bool trigger = false;
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
            label: 'Random Relaxation',
            child: SizedBox.expand(
              child: ColoredBox(
                color: Colors.white,
                child: WeightedVoronoiStipplingDemo(
                  showImage: false,
                  showVoronoiPolygons: showVoronoi,
                  pointsCount: 2000,
                  showPoints: true,
                  paintColors: false,
                  trigger: trigger,
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
                    onTap: () => setState(() => trigger = !trigger),
                    size: controlsSize,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                    iconSize: iconSize,
                    icon: Icons.play_arrow,
                  ),
                  const SizedBox(width: 10),
                  ControlsButton(
                    onTap: () => setState(() => showVoronoi = !showVoronoi),
                    size: controlsSize,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                    iconSize: iconSize,
                    icon: Icons.square_outlined,
                    color: showVoronoi ? activeColor : Colors.black,
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
