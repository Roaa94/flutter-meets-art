import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/widgets/placeholder_slide.dart';

class CCAsALearningToolTitleSlide extends FlutterDeckSlideWidget {
  CCAsALearningToolTitleSlide()
      : super(
    configuration: const FlutterDeckSlideConfiguration(
      route: '/cc-as-a-learning-tool-title',
      title: 'Creative Coding as a Learning Tool',
    ),
  );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const PlaceholderSlideContent(
        'SECTION 1: CREATIVE CODING AS A LEARNING TOOL',
        subtitle: 'Introduction (why?)',
      ),
    );
  }
}
