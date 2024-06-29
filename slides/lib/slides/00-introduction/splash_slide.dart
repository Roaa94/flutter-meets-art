import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

class SplashSlide extends FlutterDeckSlideWidget {
  SplashSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/splash',
            title: 'Splash',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.custom(
      builder: (context) => const Center(
        child: Text('<splash>'),
      ),
    );
  }
}
