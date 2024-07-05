import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/demos/voronoi_demo.dart';
import 'package:slides/templates/build_template_slide.dart';

class VoronoiOnDelaunaySlide extends FlutterDeckSlideWidget {
  const VoronoiOnDelaunaySlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/voronoi-on-delaunay-demo',
            title: 'Voronoi As the Delaunay Dual Graph',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'Voronoi As the Delaunay Dual Graph',
      showHeader: true,
      content: const VoronoiDemo(),
    );
  }
}
