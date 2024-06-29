import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/templates/build_template_slide.dart';
import 'package:slides/widgets/window_frame.dart';

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
                  paintCircumcircles: true,
                  // paintVoronoiPolygonEdges: true,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
