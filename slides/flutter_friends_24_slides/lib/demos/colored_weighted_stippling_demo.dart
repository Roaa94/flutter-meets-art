import 'package:playground/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_friends_24_slides/styles/app_colors.dart';
import 'package:flutter_friends_24_slides/widgets/controls.dart';
import 'package:flutter_friends_24_slides/widgets/window_frame.dart';

class ColoredWeightedStipplingDemo extends StatefulWidget {
  const ColoredWeightedStipplingDemo({super.key});

  @override
  State<ColoredWeightedStipplingDemo> createState() =>
      _ColoredWeightedStipplingDemoState();
}

class _ColoredWeightedStipplingDemoState
    extends State<ColoredWeightedStipplingDemo> {
  static const double iconSize = 30;
  static const double controlsSize = 52;
  static const double borderRadius = 15;
  static const Color activeColor = AppColors.primary;

  bool weightedStrokes = false;
  bool showColors = false;
  bool strokePaintingStyle = false;
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
                  child: ColoredBox(
                    color: Colors.white,
                    child: WeightedVoronoiStipplingDemo(
                      showImage: false,
                      showVoronoiPolygons: false,
                      pointsCount: 3000,
                      paintColors: true,
                      trigger: trigger,
                      maxStroke: 10,
                      minStroke: 4,
                      pointStrokeWidth: 4,
                      weightedCentroids: true,
                      weightedStrokes: weightedStrokes,
                      strokePaintingStyle: strokePaintingStyle,
                      randomSeed: true,
                      lerpFactor: 0.1,
                      // wiggleFactor: 0.5,
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
                        onTap: () => setState(() => weightedStrokes = !weightedStrokes),
                        size: controlsSize,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(borderRadius),
                          topRight: Radius.circular(borderRadius),
                        ),
                        iconSize: iconSize,
                        icon: Icons.line_weight,
                        color: weightedStrokes ? activeColor : Colors.black,
                      ),
                      const SizedBox(width: 10),
                      ControlsButton(
                        onTap: () => setState(() => strokePaintingStyle = !strokePaintingStyle),
                        size: controlsSize,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(borderRadius),
                          topRight: Radius.circular(borderRadius),
                        ),
                        iconSize: iconSize,
                        icon: Icons.circle_outlined,
                        color: strokePaintingStyle ? activeColor : Colors.black,
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
