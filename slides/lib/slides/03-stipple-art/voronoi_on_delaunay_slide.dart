import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/templates/build_template_slide.dart';
import 'package:slides/widgets/window_frame.dart';

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
      content: WindowFrame(
        margin: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.white,
          child: SizedBox.expand(
            // Todo: add controls
            child: LayoutBuilder(
              builder: (context, constraints) {
                return VoronoiPainterWrapper(
                  size: constraints.biggest,
                  showSeedPoints: true,
                  pointsCount: 5,
                  paintDelaunayTriangles: true,
                  paintVoronoiPolygonEdges: true,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
