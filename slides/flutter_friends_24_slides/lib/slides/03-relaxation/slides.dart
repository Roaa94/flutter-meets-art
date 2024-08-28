import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/slides/03-relaxation/animated_voronoi_relaxation_slide.dart';
import 'package:flutter_friends_24_slides/slides/02-voronoi/code.dart';
import 'package:flutter_friends_24_slides/slides/03-relaxation/colored_weighted_stippling_slide.dart';
import 'package:flutter_friends_24_slides/slides/03-relaxation/randomized_image_stippling_relaxation_slide.dart';
import 'package:flutter_friends_24_slides/slides/03-relaxation/voronoi_relaxation_slide.dart';
import 'package:flutter_friends_24_slides/slides/03-relaxation/weighted_stippling_slide.dart';
import 'package:flutter_friends_24_slides/templates/code_slide.dart';
import 'package:flutter_friends_24_slides/templates/demo_slide.dart';
import 'package:flutter_friends_24_slides/templates/section_title_slide.dart';
import 'package:playground/widgets/voronoi/voronoi_painter_wrapper.dart';

final relaxationSlides = <FlutterDeckSlideWidget>[
  SectionTitleSlide('LLoyd\'s Algorithm'),
  const VoronoiRelaxationSlide(),
  CodeSlide(
    voronoiRelaxationInitializationCode,
    title: 'Voronoi Relaxation Data Initialization',
    route: 'voronoi-data-initialization-1',
    codeFontSize: 20,
  ),
  CodeSlide(
    voronoiRelaxationUpdateCode,
    title: 'Lerp Seed Points to Voronoi Centroids',
    route: 'lerp-1',
  ),
  CodeSlide(
    lerpPointsCode,
    title: 'Lerp Seed Points to Voronoi Centroids',
    route: 'lerp-2',
  ),
  CodeSlide(
    voronoiRelaxationTickerCode,
    title: 'Use Ticker to Update',
  ),
  const AnimatedVoronoiRelaxationSlide(),
  SectionTitleSlide('Weighted Voronoi Stippling'),
  const RandomizedImageStipplingRelaxationSlide(),
  DemoSlide(
    'Weighted Centroids Calculation',
    route: 'weighted-image-calculation',
    child: ColoredBox(
      color: Colors.white,
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
  const WeightedStipplingSlide(),
  const ColoredWeightedStipplingSlide(),
  SectionTitleSlide(
    'What if you are the Art?',
    route: 'audience-is-art',
  ),
  CodeSlide(
    cameraImageStreamCode1,
    title: 'Camera Image Stream',
    route: 'camera-code-1',
  ),
  CodeSlide(
    cameraImageStreamCode2,
    title: 'Camera Image Stream',
    route: 'camera-code-2',
  ),
];
