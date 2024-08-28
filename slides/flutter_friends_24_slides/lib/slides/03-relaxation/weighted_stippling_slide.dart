import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/demos/weighted_stippling_demo.dart';
import 'package:flutter_friends_24_slides/templates/build_template_slide.dart';

class WeightedStipplingSlide extends FlutterDeckSlideWidget {
  const WeightedStipplingSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/weighted-image-stippling-1',
            title: 'Weighted Voronoi Stippling',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'Weighted Voronoi Stippling',
      showHeader: true,
      content: const WeightedStipplingDemo(),
    );
  }
}
