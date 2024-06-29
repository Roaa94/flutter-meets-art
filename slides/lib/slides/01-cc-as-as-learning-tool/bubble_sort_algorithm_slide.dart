import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/widgets/placeholder_slide.dart';

class BubbleSortAlgorithmSlide extends FlutterDeckSlideWidget {
  BubbleSortAlgorithmSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/bubble-sort-algorithm',
            title: 'Bubble Sort Algorithm',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const PlaceholderSlideContent(
        '1.1 Bubble Sort 1/n',
        subtitle: '(Explain the algorithm with image)',
      ),
    );
  }
}
