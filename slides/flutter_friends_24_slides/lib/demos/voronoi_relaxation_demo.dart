import 'package:flutter/material.dart';
import 'package:flutter_friends_24_slides/widgets/controls.dart';
import 'package:flutter_friends_24_slides/widgets/window_frame.dart';
import 'package:playground/app.dart';

class VoronoiRelaxationSlideDemo extends StatefulWidget {
  const VoronoiRelaxationSlideDemo({super.key});

  @override
  State<VoronoiRelaxationSlideDemo> createState() =>
      _VoronoiRelaxationSlideDemoState();
}

class _VoronoiRelaxationSlideDemoState
    extends State<VoronoiRelaxationSlideDemo> {
  static const double iconSize = 30;
  static const double controlsSize = 52;
  static const double borderRadius = 15;

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
                      pointsCount: 40,
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
                  if (!trigger)
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
