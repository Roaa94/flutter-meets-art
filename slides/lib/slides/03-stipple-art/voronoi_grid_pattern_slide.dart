import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/demos/voronoi_grid_pattern_demo.dart';
import 'package:slides/templates/build_template_slide.dart';

class VoronoiGridPatternSlide extends FlutterDeckSlideWidget {
  const VoronoiGridPatternSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/voronoi-grid-pattern-demo',
            title: 'Voronoi Grid Patterns',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      showHeader: true,
      content: const VoronoiGridPatternDemo(),
    );
  }
}
