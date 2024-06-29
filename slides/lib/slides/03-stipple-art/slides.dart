import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/slides/03-stipple-art/code.dart';
import 'package:slides/templates/placeholder_slide.dart';
import 'package:slides/templates/section_title_slide.dart';
import 'package:slides/templates/template_slide.dart';

import '../../widgets/code_highlight.dart';

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
  TemplateSlide(
    'The Voronoi Diagram',
    route: 'voronoi-diagram-demo',
    content: VoronoiPainterWrapper(
      size: Size(700, 500),
      showSeedPoints: true,
      pointsCount: 10,
    ),
  ),
  PlaceholderSlide(
    '3.2. The Voronoi Diagram 2/n - 1',
    subtitle: 'How to achieve with Flutter? (why its hard)',
  ),
  PlaceholderSlide(
    '3.2. The Voronoi Diagram 2/n - 2',
    subtitle: 'How to achieve with Flutter? (ffi option)',
  ),
  PlaceholderSlide(
    '3.2. The Voronoi Diagram 2/n - 3',
    subtitle: 'How to achieve with Flutter? (Delaunay Triangulation)',
  ),
  PlaceholderSlide(
    '3.2. The Voronoi Diagram 3/n - (delaunay - 1)',
    subtitle:
        'What is the delaunay triangulation? (explain using interactive dots + triangulation demo)',
  ),
  PlaceholderSlide(
    '3.2. The Voronoi Diagram 3/n - (delaunay - 2)',
    subtitle: 'The dart package',
  ),
  PlaceholderSlide(
    '3.2. The Voronoi Diagram 3/n - (delaunay - 3)',
    subtitle: 'Delaunay class code (input list)',
    // content: CodeHighlight(
    //   dartHighlighter,
    //   delaunayClassInputCode,
    // ),
  ),
  PlaceholderSlide(
    '3.2. The Voronoi Diagram 3/n - (delaunay - 4)',
    subtitle:
        'Code for generating random points over width & height in Float32List',
    content: const CodeHighlight(
      randomRawPointsGenerationCode,
    ),
  ),
  PlaceholderSlide(
    '3.2. The Voronoi Diagram 3/n - (delaunay - 5)',
    subtitle: 'Initialize delaunay with seed points, call update',
    content: const CodeHighlight(
      initDelaunayCode,
    ),
  ),
  // PlaceholderSlide(
  //   '3.2. The Voronoi Diagram 3/n - (delaunay - 6)',
  //   subtitle: 'Get delaunay triangles, paint with canvas.drawPath',
  //   content: CodeHighlight(
  //     dartHighlighter,
  //     paintDelaunayTrianglesCode,
  //     fontSize: 18,
  //   ),
  // ),
  PlaceholderSlide(
    '3.2. The Voronoi Diagram 4/n',
    subtitle:
        'Voronoi is the dual graph of the delaunay triangulation! (show that in interactive demo, and explain how polygons are formed from circumcenters)',
  ),
  PlaceholderSlide(
    '3.2. The Voronoi Diagram 5/n',
    subtitle:
        'How I extended the Delaunay class to calculate the Voronoi polygons (extra work to take care of edges) (show code??)',
  ),
  PlaceholderSlide(
    '3.2. The Voronoi Diagram 6/n',
    subtitle: 'Code for painting the voronoi polygons using canvas.drawPath',
  ),
];
