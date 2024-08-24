import 'package:playground/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:fluttercon_eu_24_slides/templates/build_template_slide.dart';
import 'package:fluttercon_eu_24_slides/widgets/window_frame.dart';

class VoronoiDiagramSlide extends FlutterDeckSlideWidget {
  const VoronoiDiagramSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/voronoi-diagram-demo',
            title: 'Voronoi Diagram Demo',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'The Voronoi Diagram',
      showHeader: true,
      content: WindowFrame(
        margin: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
        label: 'Voronoi',
        child: Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.white,
          child: SizedBox.expand(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return VoronoiPainterWrapper(
                  size: constraints.biggest,
                  showSeedPoints: true,
                  pointsCount: 40,
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
