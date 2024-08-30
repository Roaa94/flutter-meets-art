import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/slides/03-relaxation/animated_voronoi_relaxation_slide.dart';
import 'package:flutter_friends_24_slides/slides/03-relaxation/code.dart';
import 'package:flutter_friends_24_slides/slides/03-relaxation/colored_weighted_stippling_slide.dart';
import 'package:flutter_friends_24_slides/slides/03-relaxation/voronoi_relaxation_slide.dart';
import 'package:flutter_friends_24_slides/slides/03-relaxation/weighted_stippling_slide.dart';
import 'package:flutter_friends_24_slides/templates/code_slide.dart';
import 'package:flutter_friends_24_slides/templates/demo_slide.dart';
import 'package:flutter_friends_24_slides/templates/image_slide.dart';
import 'package:flutter_friends_24_slides/templates/section_title_slide.dart';
import 'package:playground/widgets/voronoi/voronoi_painter_wrapper.dart';

final relaxationSlides = <FlutterDeckSlideWidget>[
  SectionTitleSlide(
    'LLoyd\'s Algorithm',
    subtitle: 'Voronoi Iteration/Relaxation',
  ),
  ImageSlide(
    title: 'Lloyd\'s Relaxation Algorithm',
    path: 'assets/images/relaxation-algorithm.png',
    width: 500,
  ),
  CodeSlide(
    voronoiRelaxationCode1,
    title: 'Lloyd\'s Relaxation Algorithm',
    route: 'voronoi-relaxation-code-1',
  ),
  CodeSlide(
    voronoiRelaxationCode2,
    title: 'Lloyd\'s Relaxation Algorithm',
    route: 'voronoi-relaxation-code-2',
  ),
  CodeSlide(
    voronoiRelaxationCode3,
    title: 'Lloyd\'s Relaxation Algorithm',
    route: 'voronoi-relaxation-code-3',
  ),
  CodeSlide(
    voronoiRelaxationCode4,
    title: 'Lloyd\'s Relaxation Algorithm',
    route: 'voronoi-relaxation-code-4',
  ),
  CodeSlide(
    lerpPointsCode,
    title: 'Lloyd\'s Relaxation Algorithm',
    route: 'voronoi-relaxation-code-5',
  ),
  CodeSlide(
    voronoiRelaxationTickerCode,
    title: 'Lloyd\'s Relaxation Algorithm',
    route: 'voronoi-relaxation-code-6',
  ),
  const VoronoiRelaxationSlide(),
  const AnimatedVoronoiRelaxationSlide(),
  SectionTitleSlide('Weighted Voronoi Stippling'),
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
