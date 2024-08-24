import 'package:playground/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:fluttercon_eu_24_slides/templates/build_template_slide.dart';
import 'package:fluttercon_eu_24_slides/widgets/window_frame.dart';

class InteractiveVoronoiSlide extends FlutterDeckSlideWidget {
  const InteractiveVoronoiSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/interactive-voronoi-demo',
            title: 'Interactive Voronoi Demo',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      showHeader: true,
      content: WindowFrame(
        label: 'Interactive',
        margin: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
        child: SizedBox.expand(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return InteractiveSpiralVoronoi(
                size: constraints.biggest,
              );
            },
          ),
        ),
      ),
    );
  }
}
