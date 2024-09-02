import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/templates/build_template_slide.dart';
import 'package:flutter_friends_24_slides/widgets/controls.dart';
import 'package:flutter_friends_24_slides/widgets/window_frame.dart';
import 'package:playground/app.dart';

class AnimatedVoronoiRelaxationSlide extends FlutterDeckSlideWidget {
  const AnimatedVoronoiRelaxationSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/animated-voronoi-relaxation',
            title: 'Lloyd\'s Relaxation Algorithm Demo',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      showHeader: true,
      content: const _Demo(),
    );
  }
}

class _Demo extends StatefulWidget {
  const _Demo();

  @override
  State<_Demo> createState() => __DemoState();
}

class __DemoState extends State<_Demo> {
  static const double iconSize = 30;
  static const double controlsSize = 52;
  static const double borderRadius = 15;
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
                      pointsCount: 2000,
                      trigger: trigger,
                      showPolygons: false,
                      showCentroids: false,
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
