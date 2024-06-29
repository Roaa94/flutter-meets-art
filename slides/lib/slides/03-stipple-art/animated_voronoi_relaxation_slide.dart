import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/templates/build_template_slide.dart';
import 'package:slides/widgets/window_frame.dart';

class AnimatedVoronoiRelaxationSlide extends FlutterDeckSlideWidget {
  const AnimatedVoronoiRelaxationSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/animated-voronoi-relaxation',
            title: 'Animated Voronoi Relaxation',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      showHeader: true,
      content: WindowFrame(
        label: 'Voronoi Relaxation',
        margin: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
        child: SizedBox.expand(
          child: ColoredBox(
            color: Colors.white,
            // Todo: add controls
            child: LayoutBuilder(
              builder: (context, constraints) {
                return VoronoiRelaxation(
                  size: constraints.biggest,
                  pointsCount: 1000,
                  animate: true,
                  showPolygons: false,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
