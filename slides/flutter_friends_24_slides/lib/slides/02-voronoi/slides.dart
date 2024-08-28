import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/slides/00-introduction/agenda_slide.dart';
import 'package:flutter_friends_24_slides/slides/02-voronoi/animated_voronoi_slide.dart';
import 'package:flutter_friends_24_slides/slides/02-voronoi/code.dart';
import 'package:flutter_friends_24_slides/slides/02-voronoi/delaunay_triangulation_slide.dart';
import 'package:flutter_friends_24_slides/slides/02-voronoi/voronoi_diagram_slide.dart';
import 'package:flutter_friends_24_slides/slides/02-voronoi/voronoi_grid_pattern_slide.dart';
import 'package:flutter_friends_24_slides/slides/02-voronoi/voronoi_on_delaunay_slide.dart';
import 'package:flutter_friends_24_slides/slides/02-voronoi/voronoi_spiral_pattern_slide.dart';
import 'package:flutter_friends_24_slides/templates/code_slide.dart';
import 'package:flutter_friends_24_slides/templates/image_slide.dart';
import 'package:flutter_friends_24_slides/templates/section_title_slide.dart';

final voronoiSlides = <FlutterDeckSlideWidget>[
  SectionTitleSlide('ALGORITHMIC ART'),
  SectionTitleSlide('The Voronoi Diagram', isSubtitle: true),
  const VoronoiDiagramSlide(),
  ImageSlide(
    title: 'Voronoi FFI Computation',
    path: 'assets/images/voronoi-pub-dev.png',
    label: 'pub.dev package to calculate voronoi diagram using Rust',
  ),
  SectionTitleSlide('The Delaunay Triangulation', isSubtitle: true),
  const DelaunayTriangulationSlide(),
  ImageSlide(
    title: 'Delaunay Applications',
    path: 'assets/images/delaunay-applications.png',
  ),
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
    initDelaunayCode,
    title: 'Delaunay Initialization',
  ),
  const VoronoiOnDelaunaySlide(),
  CodeSlide(
    delaunayVoronoiExtensionCode1,
    title: 'Extending Delaunay Class with Voronoi',
    route: 'delaunay-voronoi-extension-1',
  ),
  CodeSlide(
    delaunayVoronoiExtensionCode2,
    title: 'Extending Delaunay Class with Voronoi',
    route: 'delaunay-voronoi-extension-2',
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
  CodeSlide(
    voronoiGridPatternCode,
    title: 'Voronoi Grid Patterns',
    codeFontSize: 22,
  ),
  const VoronoiGridPatternSlide(),
  CodeSlide(
    voronoiSpiralPatternCode,
    title: 'Voronoi Spiral Patterns',
    codeFontSize: 22,
  ),
  const VoronoiSpiralPatternSlide(),
  const AnimatedVoronoiSlide(),
  AgendaSlide(step: 3, completed: 2, route: 'goals-reminder'),
];
