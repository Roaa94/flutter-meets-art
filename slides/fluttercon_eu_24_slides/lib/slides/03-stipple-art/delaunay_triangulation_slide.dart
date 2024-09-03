import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:fluttercon_eu_24_slides/demos/delaunay_demo.dart';
import 'package:fluttercon_eu_24_slides/templates/build_template_slide.dart';

class DelaunayTriangulationSlide extends FlutterDeckSlideWidget {
  const DelaunayTriangulationSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/delaunay-triangulation-demo',
            title: 'Delaunay Triangulation Demo',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'The Delaunay Triangulation',
      showHeader: true,
      content: const DelaunayDemo(),
    );
  }
}
