import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/slides/03-stipple-art/animated_voronoi_relaxation_slide.dart';
import 'package:slides/slides/03-stipple-art/animated_voronoi_slide.dart';
import 'package:slides/slides/03-stipple-art/code.dart';
import 'package:slides/slides/03-stipple-art/delaunay_triangulation_slide.dart';
import 'package:slides/slides/03-stipple-art/interactive_voronoi_slide.dart';
import 'package:slides/slides/03-stipple-art/randomized_image_stippling_slide.dart';
import 'package:slides/slides/03-stipple-art/voronoi_diagram_slide.dart';
import 'package:slides/slides/03-stipple-art/voronoi_grid_pattern_slide.dart';
import 'package:slides/slides/03-stipple-art/voronoi_on_delaunay_slide.dart';
import 'package:slides/slides/03-stipple-art/voronoi_relaxation_slide.dart';
import 'package:slides/slides/03-stipple-art/voronoi_spiral_pattern_slide.dart';
import 'package:slides/slides/03-stipple-art/weighted_voronoi_stippling_slide.dart';
import 'package:slides/templates/code_slide.dart';
import 'package:slides/templates/demo_slide.dart';
import 'package:slides/templates/image_slide.dart';
import 'package:slides/templates/placeholder_slide.dart';
import 'package:slides/templates/section_title_slide.dart';

final stippleArtSlides = <FlutterDeckSlideWidget>[
  SectionTitleSlide('3. STIPPLE ART'),
  PlaceholderSlide(
    '3.1. Introduction 1/n',
    subtitle:
        'What is stipple engraving/image stippling? (show images from history)',
  ),
  PlaceholderSlide(
    '3.1. Introduction 2/n',
    subtitle: 'How do we approach this? (problem breakdown and initial goal)',
  ),
  SectionTitleSlide('The Voronoi Diagram'),
  const VoronoiDiagramSlide(),
  ImageSlide(
      title: 'Voronoi FFI Computation',
      path: 'assets/images/voronoi-pub-dev.png',
      label: 'pub.dev package to calculate voronoi diagram using Rust'),
  SectionTitleSlide('The Delaunay Triangulation'),
  const DelaunayTriangulationSlide(),
  ImageSlide(
    title: 'Delaunay Dart Package',
    path: 'assets/images/delaunay-pub-dev.png',
    label: 'pub.dev package to calculate delaunay triangulation',
  ),
  CodeSlide(
    delaunayClassInputCode,
    title: 'Delaunay Class',
  ),
  CodeSlide(
    randomRawPointsGenerationCode,
    title: 'Delaunay Coordinates Generation',
  ),
  CodeSlide(
    initDelaunayCode,
    title: 'Delaunay Initialization',
  ),
  const VoronoiOnDelaunaySlide(),
  CodeSlide(
    delaunayVoronoiExtensionCode,
    title: 'Extending Delaunay Class with Voronoi',
  ),
  CodeSlide(
    initializeVoronoiCode,
    title: 'Voronoi Initialization',
  ),
  CodeSlide(
    paintVoronoiEdgesCode1,
    title: 'Painting Voronoi Polygons',
    route: 'painting-voronoi-polygons-1',
    codeFontSize: 24,
  ),
  CodeSlide(
    paintVoronoiEdgesCode2,
    title: 'Painting Voronoi Polygons',
    route: 'painting-voronoi-polygons-2',
    codeFontSize: 24,
  ),
  const VoronoiGridPatternSlide(),
  const VoronoiSpiralPatternSlide(),
  const InteractiveVoronoiSlide(),
  const AnimatedVoronoiSlide(),
  SectionTitleSlide('LLoyd\'s Algorithm'),
  const VoronoiRelaxationSlide(),
  CodeSlide(
    voronoiStateInitializationCode1,
    title: 'Voronoi Data Initialization',
    route: 'voronoi-data-initialization-1',
    codeFontSize: 20,
  ),
  CodeSlide(
    voronoiStateInitializationCode2,
    title: 'Voronoi Data Initialization',
    route: 'voronoi-data-initialization-2',
    codeFontSize: 20,
  ),
  CodeSlide(
    updateVoronoiRelaxationCode,
    title: 'Lerp Seed Points to Voronoi Centroids',
  ),
  CodeSlide(
    voronoiRelaxationTickerCode1,
    title: 'Animate Relaxation Using Ticker',
    route: 'voronoi-relaxation-animation-1',
    codeFontSize: 20,
  ),
  CodeSlide(
    voronoiRelaxationTickerCode2,
    title: 'Animate Relaxation Using Ticker',
    route: 'voronoi-relaxation-animation-2',
    codeFontSize: 20,
  ),
  CodeSlide(
    voronoiRelaxationTickerCode3,
    title: 'Animate Relaxation Using Ticker',
    route: 'voronoi-relaxation-animation-3',
    codeFontSize: 20,
  ),
  const AnimatedVoronoiRelaxationSlide(),
  SectionTitleSlide('Weighted Voronoi Stippling'),
  CodeSlide(
    generateRandomPointsFromPixelsCode,
    title: 'Image Pixels Random Point Generation',
    codeFontSize: 20,
  ),
  const RandomizedImageStipplingSlide(),
  DemoSlide(
    'Randomized Image Stippling Relaxation',
    child: const ColoredBox(
      color: Colors.white,
      child: WeightedVoronoiStipplingDemo(
        showImage: false,
        showVoronoiPolygons: false,
        pointsCount: 2000,
        paintColors: false,
        animate: true,
        weightedCentroids: false,
      ),
    ),
  ),
  PlaceholderSlide('Weights Calculation (with voronoi demo explanation)'),
  CodeSlide(
    '',
    title: 'Weighted Centroids Calculation',
  ),
  DemoSlide(
    'Weighted Image Stippling',
    route: 'weighted-image-stippling-1',
    child: const ColoredBox(
      color: Colors.white,
      child: WeightedVoronoiStipplingDemo(
        showImage: false,
        showVoronoiPolygons: false,
        pointsCount: 2000,
        paintColors: false,
        animate: true,
        weightedCentroids: true,
      ),
    ),
  ),
  const WeightedVoronoiStipplingSlide(),
  SectionTitleSlide(
    'What if you are the Art?',
    route: 'audience-is-art',
  ),
];
