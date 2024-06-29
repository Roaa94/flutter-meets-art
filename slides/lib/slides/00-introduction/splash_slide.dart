import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

class SplashSlide extends FlutterDeckSlideWidget {
  SplashSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/splash-artwork',
            title: 'Splash Artwork',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.custom(
      builder: (context) => SizedBox.expand(
        child: Container(
          color: Colors.grey,
          child: const Center(child: Text('<splash artwork>')),
        ),
      ),
    );
  }
}
