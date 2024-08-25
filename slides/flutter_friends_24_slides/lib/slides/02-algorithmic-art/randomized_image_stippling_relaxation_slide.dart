import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/demos/randomized_image_stippling_relaxation_demo.dart';
import 'package:flutter_friends_24_slides/templates/build_template_slide.dart';

class RandomizedImageStipplingRelaxationSlide extends FlutterDeckSlideWidget {
  const RandomizedImageStipplingRelaxationSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/randomized-image-relaxation',
            title: 'Randomized Image Relaxation',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      showHeader: true,
      title: 'Randomized Image Stippling',
      content: const RandomizedImageStipplingRelaxationDemo(),
    );
  }
}
