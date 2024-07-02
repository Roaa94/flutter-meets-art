import 'package:app/app.dart';
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
        child: ColoredBox(
          color: Colors.black,
          child: Center(
            child: Transform.scale(
              scale: 1.7,
              child: const CameraImageStipplingDemo(
                weightedStrokes: true,
                showVoronoiPolygons: false,
                showPoints: true,
                showDevicesDropdown: false,
                minStroke: 5,
                maxStroke: 10,
                pointsCount: 10000,
                // wiggleFactor: 0.2,
                strokePaintingStyle: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
