import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/demos/voronoi_spiral_pattern_demo.dart';
import 'package:flutter_friends_24_slides/templates/build_template_slide.dart';

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
      showHeader: true,
      content: const VoronoiSpiralPatternDemo(),
    );
  }
}
