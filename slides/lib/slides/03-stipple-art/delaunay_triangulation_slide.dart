import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/demos/delaunay_demo.dart';
import 'package:slides/templates/build_template_slide.dart';

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
