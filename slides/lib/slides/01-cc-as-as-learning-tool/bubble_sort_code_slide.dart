import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/code.dart';
import 'package:slides/slides/01-cc-as-as-learning-tool/code.dart';
import 'package:slides/widgets/code_highlight.dart';
import 'package:slides/widgets/placeholder_slide.dart';

class BubbleSortCodeSlide extends FlutterDeckSlideWidget {
  BubbleSortCodeSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/bubble-sort-code',
            title: 'Bubble Sort Code',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const PlaceholderSlideContent(
        '1.1 Bubble Sort 2/n',
        subtitle: '(Code for single-run execution)',
        content: CodeHighlight(
          code: singleRunBubbleSortCode,
        ),
      ),
    );
  }
}
