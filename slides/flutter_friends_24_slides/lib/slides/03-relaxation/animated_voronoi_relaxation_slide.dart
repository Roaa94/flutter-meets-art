import 'package:playground/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/templates/build_template_slide.dart';
import 'package:flutter_friends_24_slides/widgets/window_frame.dart';

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
      content: WindowFrame(
        label: 'Lloyd',
        margin: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
        child: SizedBox.expand(
          child: ColoredBox(
            color: Colors.white,
            // Todo: add controls
            child: LayoutBuilder(
              builder: (context, constraints) {
                return VoronoiRelaxationDemo(
                  size: constraints.biggest,
                  pointsCount: 2000,
                  trigger: true,
                  showPolygons: false,
                  showCentroids: false,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
