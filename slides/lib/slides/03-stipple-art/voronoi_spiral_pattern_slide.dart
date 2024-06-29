import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/templates/build_template_slide.dart';
import 'package:slides/widgets/window_frame.dart';

class VoronoiSpiralPatternSlide extends FlutterDeckSlideWidget {
  const VoronoiSpiralPatternSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/voronoi-spiral-pattern-demo',
            title: 'Voronoi Spiral Patterns',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'Voronoi Spiral Patterns',
      showHeader: true,
      content: WindowFrame(
        margin: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
        child: SizedBox.expand(
          // Todo: add controls
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SpiralVoronoi(
                size: constraints.biggest,
              );
            },
          ),
        ),
      ),
    );
  }
}
