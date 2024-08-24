import 'package:playground/app.dart';
import 'package:flutter/material.dart';
import 'package:fluttercon_eu_24_slides/styles/app_colors.dart';
import 'package:fluttercon_eu_24_slides/widgets/controls.dart';
import 'package:fluttercon_eu_24_slides/widgets/window_frame.dart';

class VoronoiDemo extends StatefulWidget {
  const VoronoiDemo({super.key});

  @override
  State<VoronoiDemo> createState() => _VoronoiDemoState();
}

class _VoronoiDemoState extends State<VoronoiDemo> {
  static const double iconSize = 30;
  static const double controlsSize = 52;
  static const double borderRadius = 15;

  bool showVoronoi = false;
  bool showDelaunay = true;
  int pointsCount = 5;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
      child: Stack(
        children: [
          WindowFrame(
            label: 'Voronoi',
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: SizedBox.expand(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return VoronoiPainterWrapper(
                      size: constraints.biggest,
                      showSeedPoints: true,
                      pointsCount: pointsCount,
                      paintDelaunayTriangles: showDelaunay,
                      paintVoronoiPolygonEdges: showVoronoi,
                      paintCircumcircles: false,
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.1,
            right: 0,
            left: 0,
            child: RepaintBoundary(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ControlsButton(
                    onTap: () => setState(() => showVoronoi = !showVoronoi),
                    size: controlsSize,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                    iconSize: iconSize,
                    icon: Icons.square_outlined,
                    color: showVoronoi ? AppColors.primary : Colors.black,
                  ),
                  const SizedBox(width: 10),
                  ControlsButton(
                    onTap: () => setState(() => showDelaunay = !showDelaunay),
                    size: controlsSize,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                    iconSize: iconSize,
                    icon: Icons.polyline_rounded,
                    color: showDelaunay ? AppColors.primary : Colors.black,
                  ),
                  const SizedBox(width: 10),
                  Controls(
                    size: controlsSize,
                    borderRadius: borderRadius,
                    onPlus: () {
                      if (pointsCount < 100) {
                        setState(() {
                          pointsCount++;
                        });
                      }
                    },
                    onMinus: () {
                      if (pointsCount > 3) {
                        setState(() {
                          pointsCount--;
                        });
                      }
                    },
                    icon: Icons.circle,
                    iconSize: iconSize,
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
