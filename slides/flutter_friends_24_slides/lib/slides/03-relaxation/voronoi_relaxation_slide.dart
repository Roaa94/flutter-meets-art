import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/demos/voronoi_relaxation_demo.dart';
import 'package:flutter_friends_24_slides/templates/build_template_slide.dart';

class VoronoiRelaxationSlide extends FlutterDeckSlideWidget {
  const VoronoiRelaxationSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/voronoi-relaxation',
            title: 'Lloyd\'s Relaxation Algorithm Demo',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      showHeader: true,
      title: 'Lloyd\'s Relaxation Algorithm Demo',
      content: const VoronoiRelaxationSlideDemo(),
    );
  }
}
