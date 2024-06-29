import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/slides/03-stipple-art/code.dart';
import 'package:slides/slides/03-stipple-art/delaunay_triangulation_slide.dart';
import 'package:slides/slides/03-stipple-art/voronoi_diagram_slide.dart';
import 'package:slides/slides/03-stipple-art/voronoi_on_delaunay_slide.dart';
import 'package:slides/templates/code_slide.dart';
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
  // Todo: Voronoi art slides
  SectionTitleSlide('LLoyd\'s Algorithm'),
];
