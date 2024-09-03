import 'package:playground/widgets/voronoi/voronoi_painter_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:fluttercon_eu_24_slides/slides/03-stipple-art/animated_voronoi_relaxation_slide.dart';
import 'package:fluttercon_eu_24_slides/slides/03-stipple-art/animated_voronoi_slide.dart';
import 'package:fluttercon_eu_24_slides/slides/03-stipple-art/approach_slide.dart';
import 'package:fluttercon_eu_24_slides/slides/03-stipple-art/code.dart';
import 'package:fluttercon_eu_24_slides/slides/03-stipple-art/colored_weighted_stippling_slide.dart';
import 'package:fluttercon_eu_24_slides/slides/03-stipple-art/delaunay_triangulation_slide.dart';
import 'package:fluttercon_eu_24_slides/slides/03-stipple-art/interactive_voronoi_slide.dart';
import 'package:fluttercon_eu_24_slides/slides/03-stipple-art/randomized_image_stippling_relaxation_slide.dart';
import 'package:fluttercon_eu_24_slides/slides/03-stipple-art/randomized_image_stippling_slide.dart';
import 'package:fluttercon_eu_24_slides/slides/03-stipple-art/voronoi_diagram_slide.dart';
import 'package:fluttercon_eu_24_slides/slides/03-stipple-art/voronoi_grid_pattern_slide.dart';
import 'package:fluttercon_eu_24_slides/slides/03-stipple-art/voronoi_on_delaunay_slide.dart';
import 'package:fluttercon_eu_24_slides/slides/03-stipple-art/voronoi_relaxation_slide.dart';
import 'package:fluttercon_eu_24_slides/slides/03-stipple-art/voronoi_spiral_pattern_slide.dart';
import 'package:fluttercon_eu_24_slides/slides/03-stipple-art/weighted_stippling_slide.dart';
import 'package:fluttercon_eu_24_slides/templates/code_slide.dart';
import 'package:fluttercon_eu_24_slides/templates/demo_slide.dart';
import 'package:fluttercon_eu_24_slides/templates/image_slide.dart';
import 'package:fluttercon_eu_24_slides/templates/section_title_slide.dart';

final stippleArtSlides = <FlutterDeckSlideWidget>[
  // 50
  SectionTitleSlide('3. STIPPLE ART'),
  // 51
  ImageSlide(
    title: 'Stipple Engraving',
    path: 'assets/images/stippling-greyscale.png',
    width: 800,
    label: 'Giulio Campagnola, around 1510 - "The Young Shepherd"',
  ),
  // 52
  ImageSlide(
    title: 'Colored Stipple Engraving',
    path: 'assets/images/stippling-cupid-and-aglaia.png',
    width: 800,
    label:
        'Francesco Bartolozzi (1727-1815) "Cupid Binding Aglaia to a Laurel"',
  ),
  // 53
  ImageSlide(
    title: 'Pointillism in Neo-Impressionism',
    route: 'pointillism-1',
    path:
        'assets/images/pointillism-paul-signac-l\'hirondelle-steamer-on-the-seine.jpeg',
    width: 800,
    label: 'Paul Signac (1863–1935) - "L\'Hirondelle Steamer on the Seine"',
  ),
  // 54
  ImageSlide(
    title: 'Pointillism in Neo-Impressionism',
    route: 'pointillism-2',
    path: 'assets/images/pointillism-georges-lemmen-the-beach-at-heist.jpg',
    width: 800,
    label:
        'Georges Lemmen, c.1891-92, "The Beach at Heist", Musée d\'Orsay Paris',
  ),
  // 55
  SectionTitleSlide(
    'How do we approach this?',
    isSubtitle: true,
    route: 'approach-to-stippling',
  ),
  // 56
  const ApproachSlide(),
  // 57
  SectionTitleSlide('The Voronoi Diagram', isSubtitle: true),
  // 58
  const VoronoiDiagramSlide(),
  // 59
  ImageSlide(
    title: 'Voronoi FFI Computation',
    path: 'assets/images/voronoi-pub-dev.png',
    label: 'pub.dev package to calculate voronoi diagram using Rust',
  ),
  // 60
  SectionTitleSlide('The Delaunay Triangulation', isSubtitle: true),
  // 61
  const DelaunayTriangulationSlide(),
  // 62
  ImageSlide(
    title: 'Delaunay Dart Package',
    path: 'assets/images/delaunay-pub-dev.png',
    label: 'pub.dev package to calculate delaunay triangulation',
  ),
  // 63
  CodeSlide(
    delaunayClassInputCode,
    title: 'Delaunay Class',
  ),
  // 64
  CodeSlide(
    randomRawPointsGenerationCode,
    title: 'Delaunay Coordinates Generation',
  ),
  // 65
  CodeSlide(
    initDelaunayCode,
    title: 'Delaunay Initialization',
  ),
  // 66
  const VoronoiOnDelaunaySlide(),
  // 67
  CodeSlide(
    delaunayVoronoiExtensionCode,
    title: 'Extending Delaunay Class with Voronoi',
  ),
  // 68
  CodeSlide(
    initializeVoronoiCode,
    title: 'Voronoi Initialization',
  ),
  // 69
  CodeSlide(
    paintVoronoiEdgesCode1,
    title: 'Painting Voronoi Polygons',
    route: 'painting-voronoi-polygons-1',
    codeFontSize: 24,
  ),
  // 70
  CodeSlide(
    paintVoronoiEdgesCode2,
    title: 'Painting Voronoi Polygons',
    route: 'painting-voronoi-polygons-2',
    codeFontSize: 24,
  ),
  // 71
  const VoronoiGridPatternSlide(),
  // 72
  const VoronoiSpiralPatternSlide(),
  // 73
  const InteractiveVoronoiSlide(),
  // 74
  const AnimatedVoronoiSlide(),
  // 75
  SectionTitleSlide('LLoyd\'s Algorithm'),
  // 76
  const VoronoiRelaxationSlide(),
  // 77
  CodeSlide(
    voronoiRelaxationInitializationCode,
    title: 'Voronoi Relaxation Data Initialization',
    route: 'voronoi-data-initialization-1',
    codeFontSize: 20,
  ),
  // 78
  CodeSlide(
    voronoiRelaxationUpdateCode,
    title: 'Lerp Seed Points to Voronoi Centroids',
    route: 'lerp-1',
  ),
  // 79
  CodeSlide(
    lerpPointsCode,
    title: 'Lerp Seed Points to Voronoi Centroids',
    route: 'lerp-2',
  ),
  // 80
  CodeSlide(
    voronoiRelaxationTickerCode,
    title: 'Use Ticker to Update',
  ),
  // 81
  const AnimatedVoronoiRelaxationSlide(),
  // 82
  SectionTitleSlide('Weighted Voronoi Stippling'),
  // 83
  CodeSlide(
    generateRandomPointsFromPixelsCode,
    title: 'Image Pixels Random Point Generation',
    codeFontSize: 20,
  ),
  // 84
  const RandomizedImageStipplingSlide(),
  // 85
  const RandomizedImageStipplingRelaxationSlide(),
  // 86
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
  // 87
  const WeightedStipplingSlide(),
  // 88
  const ColoredWeightedStipplingSlide(),
  // 89
  SectionTitleSlide(
    'What if you are the Art?',
    route: 'audience-is-art',
  ),
  // 90
  CodeSlide(
    cameraImageStreamCode1,
    title: 'Camera Image Stream',
    route: 'camera-code-1',
  ),
  // 91
  CodeSlide(
    cameraImageStreamCode2,
    title: 'Camera Image Stream',
    route: 'camera-code-2',
  ),
];
