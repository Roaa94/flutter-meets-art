import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:slides/widgets/controls.dart';
import 'package:slides/widgets/window_frame.dart';

class VoronoiGridPatternDemo extends StatefulWidget {
  const VoronoiGridPatternDemo({super.key});

  @override
  State<VoronoiGridPatternDemo> createState() => _VoronoiGridPatternDemoState();
}

class _VoronoiGridPatternDemoState extends State<VoronoiGridPatternDemo> {
  static const double iconSize = 30;
  static const double controlsSize = 52;
  static const double borderRadius = 15;
  static const Color activeColor = Color(0xffb84049);

  double cellIncrementFactor = 0.1;
  bool showColors = false;
  bool showVoronoi = false;
  bool showSeedPoints = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
      child: Stack(
        children: [
          WindowFrame(
            label: 'Grid',
            child: SizedBox.expand(
              child: ColoredBox(
                color: Colors.white,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridVoronoi(
                      size: constraints.biggest,
                      cellSize: 60,
                      cellIncrementFactor: cellIncrementFactor,
                      colored: showColors,
                      paintSeedPoints: showSeedPoints,
                      paintVoronoiEdges: showVoronoi,
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 2,
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
                  ControlsButton(
                    onTap: () => setState(() => showColors = !showColors),
                    size: controlsSize,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                    iconSize: iconSize,
                    icon: Icons.color_lens_outlined,
                    color: showColors ? activeColor : Colors.black,
                  ),
                  const SizedBox(width: 10),
                  Controls(
                    size: controlsSize,
                    borderRadius: borderRadius,
                    onPlus: () {
                      if (cellIncrementFactor < 0.6) {
                        setState(() {
                          cellIncrementFactor += 0.05;
                        });
                      }
                    },
                    onMinus: () {
                      if (cellIncrementFactor > 0.2) {
                        setState(() {
                          cellIncrementFactor -= 0.05;
                        });
                      }
                    },
                    label: Text(
                      'Angle (${cellIncrementFactor.toStringAsFixed(1)})',
                      textAlign: TextAlign.center,
                    ),
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
