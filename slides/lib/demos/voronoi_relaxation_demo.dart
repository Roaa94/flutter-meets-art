import 'package:playground/app.dart';
import 'package:flutter/material.dart';
import 'package:slides/styles/app_colors.dart';
import 'package:slides/widgets/controls.dart';
import 'package:slides/widgets/window_frame.dart';

class VoronoiRelaxationSlideDemo extends StatefulWidget {
  const VoronoiRelaxationSlideDemo({super.key});

  @override
  State<VoronoiRelaxationSlideDemo> createState() =>
      _VoronoiRelaxationSlideDemoState();
}

class _VoronoiRelaxationSlideDemoState extends State<VoronoiRelaxationSlideDemo> {
  static const double iconSize = 30;
  static const double controlsSize = 52;
  static const double borderRadius = 15;
  static const Color activeColor = AppColors.primary;

  bool showVoronoi = true;
  bool showCentroids = true;
  bool trigger = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
      child: Stack(
        children: [
          WindowFrame(
            label: 'Lloyd',
            child: SizedBox.expand(
              child: ColoredBox(
                color: Colors.white,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return VoronoiRelaxationDemo(
                      size: constraints.biggest,
                      pointsCount: 30,
                      showCentroids: showCentroids,
                      showPolygons: showVoronoi,
                      trigger: trigger,
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
                  // ControlsButton(
                  //   onTap: () => setState(() => showCentroids = !showCentroids),
                  //   size: controlsSize,
                  //   borderRadius: const BorderRadius.only(
                  //     topLeft: Radius.circular(borderRadius),
                  //     topRight: Radius.circular(borderRadius),
                  //   ),
                  //   iconSize: iconSize,
                  //   icon: Icons.circle,
                  //   color: showCentroids ? activeColor : Colors.black,
                  // ),
                  // const SizedBox(width: 10),
                  // ControlsButton(
                  //   onTap: () => setState(() => showVoronoi = !showVoronoi),
                  //   size: controlsSize,
                  //   borderRadius: const BorderRadius.only(
                  //     topLeft: Radius.circular(borderRadius),
                  //     topRight: Radius.circular(borderRadius),
                  //   ),
                  //   iconSize: iconSize,
                  //   icon: Icons.square_outlined,
                  //   color: showVoronoi ? activeColor : Colors.black,
                  // ),
                  // const SizedBox(width: 10),
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
    );
  }
}
