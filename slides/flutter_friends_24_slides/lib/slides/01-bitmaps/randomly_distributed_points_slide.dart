import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/demos/randomly_distributed_point_demo.dart';
import 'package:flutter_friends_24_slides/templates/build_template_slide.dart';

class RandomlyDistributedPointsSlide extends FlutterDeckSlideWidget {
  const RandomlyDistributedPointsSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/randomly-distributed-points',
            title: 'Randomly Distributed Points',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      showHeader: true,
      title: 'Random point distribution',
      content: const RandomlyDistributedPointsDemo(),
    );
  }
}
