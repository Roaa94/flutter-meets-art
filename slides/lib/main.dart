import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides/code.dart';
import 'package:slides/slides/00-introduction/slides.dart';
import 'package:slides/slides/01-cc-as-as-learning-tool/slides.dart';
import 'package:slides/styles/text_styles.dart';
import 'package:slides/widgets/code_highlight.dart';
import 'package:slides/widgets/placeholder_slide.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

final highlighterProvider = Provider<Highlighter>(
  (_) => throw UnimplementedError(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Highlighter.initialize([
    'dart',
    'yaml',
    'sql',
    'json',
  ]);
  var darkTheme = await HighlighterTheme.loadDarkTheme();
  final dartHighlighter = Highlighter(
    language: 'dart',
    theme: darkTheme,
  );

  runApp(
    ProviderScope(
      overrides: [
        highlighterProvider.overrideWithValue(dartHighlighter),
      ],
      child: const SlidesApp(),
    ),
  );
}

final pixelSortingSlides = <FlutterDeckSlideWidget>[
  // Todo: reconsider the title
  PlaceholderSlide('SECTION 2: GLITCH ART WITH PIXEL SORTING'),
  PlaceholderSlide('2.1 Reading Image Pixels'),
  PlaceholderSlide(
    '2.1 Reading Image Pixels 1/n',
    subtitle: 'Decoding an image from an asset file',
    content: const CodeHighlight(
      code: loadImageAssetCode,
    ),
  ),
  PlaceholderSlide(
    '2.1 Reading Image Pixels 2/n',
    subtitle: 'Explain image byte data (with illustration)',
  ),
  PlaceholderSlide(
    '2.1 Reading Image Pixels 3/n',
    subtitle: 'Reading pixel colors list from image bytes',
    content: const CodeHighlight(
      code: loadImagePixelColorsCode,
    ),
  ),
  PlaceholderSlide(
    '2.1 Reading Image Pixels 4/n',
    subtitle: 'Painting image pixel with canvas.drawRect',
    content: const CodeHighlight(
      code: paintImagePixelsCode,
    ),
  ),
  PlaceholderSlide(
    '2.1 Reading Image Pixels 5/n',
    subtitle: 'Show a small painted image with zoom in/out for illustration',
  ),
  PlaceholderSlide('2.2 Sorting the Pixels'),
  PlaceholderSlide(
    '2.2 Sorting the Pixels 1/n',
    subtitle: 'Use HSLColor',
  ),
  PlaceholderSlide(
    '2.2 Sorting the Pixels 2/n',
    subtitle: 'Quick sort swap snippet, swapping based on color.lightness',
  ),
  PlaceholderSlide(
    '2.2 Sorting the Pixels 3/n',
    subtitle: 'Code to sort by row',
  ),
  PlaceholderSlide(
    '2.2 Sorting the Pixels 4/n',
    subtitle: 'Show simulation of image sorted by row',
  ),
  PlaceholderSlide(
    '2.2 Sorting the Pixels 5/n - (possibilities - 1)',
    subtitle: 'Show simulation of image sorted by column',
  ),
  PlaceholderSlide(
    '2.2 Sorting the Pixels 5/n - (possibilities - 2)',
    subtitle: 'Show simulation of image sorted by interval',
  ),
  PlaceholderSlide(
    '2.2 Sorting the Pixels 5/n - (possibilities - 3)',
    subtitle: 'Show simulation of image sorted by interval',
  ),
  PlaceholderSlide('2. Closing'),
];

class SlidesApp extends StatelessWidget {
  const SlidesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterDeckApp(
      themeMode: ThemeMode.dark,
      speakerInfo: const FlutterDeckSpeakerInfo(
        name: 'Roaa Khaddam',
        description: 'Software Engineer, Flutter & Dart GDE',
        imagePath: 'assets/images/profile-pic-min.png',
        socialHandle: '@roaakdm',
      ),
      configuration: const FlutterDeckConfiguration(
        showProgress: false,
        controls: FlutterDeckControlsConfiguration(
          presenterToolbarVisible: true,
        ),
        footer: FlutterDeckFooterConfiguration(
          showSlideNumbers: true,
          widget: Text(
            '@roaakdm',
            style: TextStyles.footer,
          ),
        ),
        // transition: FlutterDeckTransition.fade(),
      ),
      slides: [
        ...introductionSlides,
        ...creativeCodingAsALearningToolSlides,
        ...pixelSortingSlides,
        PlaceholderSlide('SECTION 3: STIPPLE ART'),
        PlaceholderSlide(
          '3.1. Introduction 1/n',
          subtitle:
              'What is stipple engraving/image stippling? (show images from history)',
        ),
        PlaceholderSlide(
          '3.1. Introduction 2/n',
          subtitle:
              'How do we approach this? (problem breakdown and initial goal)',
        ),
        PlaceholderSlide('3.2. The Voronoi Diagram'),
        PlaceholderSlide(
          '3.2. The Voronoi Diagram 1/n',
          subtitle: 'Explanation over illustration',
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
          //   code: delaunayClassInputCode,
          // ),
        ),
        PlaceholderSlide(
          '3.2. The Voronoi Diagram 3/n - (delaunay - 4)',
          subtitle:
              'Code for generating random points over width & height in Float32List',
          content: const CodeHighlight(
            code: randomRawPointsGenerationCode,
          ),
        ),
        PlaceholderSlide(
          '3.2. The Voronoi Diagram 3/n - (delaunay - 5)',
          subtitle: 'Initialize delaunay with seed points, call update',
          content: const CodeHighlight(
            code: initDelaunayCode,
          ),
        ),
        // PlaceholderSlide(
        //   '3.2. The Voronoi Diagram 3/n - (delaunay - 6)',
        //   subtitle: 'Get delaunay triangles, paint with canvas.drawPath',
        //   content: CodeHighlight(
        //     dartHighlighter,
        //     code: paintDelaunayTrianglesCode,
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
          subtitle:
              'Code for painting the voronoi polygons using canvas.drawPath',
        ),
      ],
    );
  }
}
