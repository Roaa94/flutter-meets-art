import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/demos/randomized_image_stippling_demo.dart';
import 'package:flutter_friends_24_slides/templates/build_template_slide.dart';

class RandomizedImageStipplingSlide extends FlutterDeckSlideWidget {
  const RandomizedImageStipplingSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/randomized-image-stippling',
            title: 'Randomized Image Stippling',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      showHeader: true,
      title: 'Randomized Image Stippling',
      content: const RandomizedImageStipplingDemo(),
    );
  }
}
