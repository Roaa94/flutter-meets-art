import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:slides/widgets/controls.dart';
import 'package:slides/widgets/window_frame.dart';

class VoronoiSpiralPatternDemo extends StatefulWidget {
  const VoronoiSpiralPatternDemo({super.key});

  @override
  State<VoronoiSpiralPatternDemo> createState() =>
      _VoronoiSpiralPatternDemoState();
}

class _VoronoiSpiralPatternDemoState extends State<VoronoiSpiralPatternDemo> {
  static const double iconSize = 30;
  static const double controlsSize = 52;
  static const double borderRadius = 15;
  static const Color activeColor = Color(0xffc033c4);

  bool showVoronoi = false;
  bool showSeedPoints = true;
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
            label: 'Spiral',
            child: SizedBox.expand(
              child: ColoredBox(
                color: Colors.white,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SpiralVoronoi(
                      size: constraints.biggest,
                      paintSeedPoints: showSeedPoints,
                      paintVoronoiCells: showVoronoi,
                      pointsCount: pointsCount,
                      angleIncrement: angleIncrement,
                      radiusIncrement: radiusIncrement,
                    );
                  },
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
                    onTap: () =>
                        setState(() => showSeedPoints = !showSeedPoints),
                    size: controlsSize,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                    iconSize: iconSize,
                    icon: Icons.circle,
                    color: showSeedPoints ? activeColor : Colors.black,
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
                  Controls(
                    size: controlsSize,
                    borderRadius: borderRadius,
                    onPlus: () {
                      if (angleIncrement < 50) {
                        setState(() {
                          angleIncrement++;
                        });
                      }
                    },
                    onMinus: () {
                      if (angleIncrement > 0) {
                        setState(() {
                          angleIncrement--;
                        });
                      }
                    },
                    icon: Icons.square_foot_sharp,
                    iconSize: iconSize,
                    centerColor: activeColor,
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
