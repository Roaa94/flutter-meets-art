import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/templates/build_template_slide.dart';
import 'package:slides/widgets/window_frame.dart';

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
      content: const WindowFrame(
        label: 'Image Stippling',
        margin: EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
        child: ColoredBox(
          color: Colors.white,
          child: WeightedVoronoiStippling(
            // Todo: add controls
            showImage: true,
            showVoronoiPolygons: false,
            pointsCount: 2000,
            // Todo: add controls
            paintPoints: false,
            paintColors: false,
            animate: false,
            weightedCentroids: false,
          ),
        ),
      ),
    );
  }
}
