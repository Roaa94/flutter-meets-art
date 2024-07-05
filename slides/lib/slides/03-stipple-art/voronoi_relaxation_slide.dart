import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/demos/voronoi_relaxation_demo.dart';
import 'package:slides/templates/build_template_slide.dart';

class VoronoiRelaxationSlide extends FlutterDeckSlideWidget {
  const VoronoiRelaxationSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/voronoi-relaxation',
            title: 'Voronoi Relaxation',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      showHeader: true,
      title: 'Voronoi Relaxation (Lloyd\'s Algorithm)',
      content: const VoronoiRelaxationSlideDemo(),
    );
  }
}
