import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:slides/styles/app_colors.dart';
import 'package:slides/widgets/controls.dart';
import 'package:slides/widgets/window_frame.dart';

class WeightedStipplingDemo extends StatefulWidget {
  const WeightedStipplingDemo({super.key});

  @override
  State<WeightedStipplingDemo> createState() =>
      _WeightedStipplingDemoState();
}

class _WeightedStipplingDemoState
    extends State<WeightedStipplingDemo> {
  static const double iconSize = 30;
  static const double controlsSize = 52;
  static const double borderRadius = 15;
  static const Color activeColor = AppColors.primary;

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
      child: Stack(
        children: [
          WindowFrame(
            label: 'Weighted Stippling',
            child: SizedBox.expand(
              child: ColoredBox(
                color: Colors.white,
                child: WeightedVoronoiStipplingDemo(
                  showImage: false,
                  showVoronoiPolygons: showVoronoi,
                  pointsCount: 2000,
                  paintColors: false,
                  showPoints: showPoints,
                  trigger: trigger,
                  weightedCentroids: true,
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
