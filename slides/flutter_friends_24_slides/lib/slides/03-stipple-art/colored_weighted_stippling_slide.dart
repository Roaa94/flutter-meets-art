import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/demos/colored_weighted_stippling_demo.dart';
import 'package:flutter_friends_24_slides/templates/build_template_slide.dart';

class ColoredWeightedStipplingSlide extends FlutterDeckSlideWidget {
  const ColoredWeightedStipplingSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/weighted-image-stippling-colored',
            title: 'Weighted Image Stippling - Colored',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      showHeader: true,
      title: 'Weighted Voronoi Stippling - Colored',
      content: const ColoredWeightedStipplingDemo(),
    );
  }
}
