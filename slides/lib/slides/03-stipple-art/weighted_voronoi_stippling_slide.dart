import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/templates/build_template_slide.dart';
import 'package:slides/widgets/window_frame.dart';

class WeightedVoronoiStipplingSlide extends FlutterDeckSlideWidget {
  const WeightedVoronoiStipplingSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/weighted-image-stippling-colored',
            title: 'Weighted Image Stippling - Colored',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      showHeader: true,
      title: 'Weighted Image Stippling - Colored',
      content: const WindowFrame(
        label: 'Image Stippling',
        margin: EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
        child: ColoredBox(
          color: Colors.white,
          // Todo: add controls (dots/no dots, polygons/no polygons, dot width)
          child: WeightedVoronoiStipplingDemo(
            showImage: false,
            showVoronoiPolygons: false,
            pointsCount: 2000,
            paintColors: true,
            animate: true,
            weightedCentroids: true,
            weightedStrokes: true,
            // wiggleFactor: 0.5,
          ),
        ),
      ),
    );
  }
}
