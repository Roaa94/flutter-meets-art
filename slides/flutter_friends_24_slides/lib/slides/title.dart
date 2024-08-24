import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

class TitleSlide extends FlutterDeckSlideWidget {
  const TitleSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/title',
            title: 'Title',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    final flutterDeck = FlutterDeck.of(context);
    final speakerInfo = flutterDeck.speakerInfo;

    return FlutterDeckSlide.title(
      title: 'Code Meets Art: Flutter for Creative Coding',
    );
  }
}
