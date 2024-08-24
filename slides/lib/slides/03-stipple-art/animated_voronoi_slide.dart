import 'package:playground/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/templates/build_template_slide.dart';
import 'package:slides/widgets/window_frame.dart';

class AnimatedVoronoiSlide extends FlutterDeckSlideWidget {
  const AnimatedVoronoiSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/animated-voronoi-demo',
            title: 'Animated Voronoi Demo',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      showHeader: true,
      content: WindowFrame(
        label: 'Animated',
        margin: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
        child: SizedBox.expand(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedSpiralVoronoi(
                size: constraints.biggest,
              );
            },
          ),
        ),
      ),
    );
  }
}
