import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/code.dart';
import 'package:slides/code_highlight.dart';
import 'package:slides/placeholder_slide.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

late final Highlighter dartHighlighter;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Highlighter.initialize([
    'dart',
    'yaml',
    'sql',
    'json',
  ]);
  var darkTheme = await HighlighterTheme.loadDarkTheme();
  dartHighlighter = Highlighter(
    language: 'dart',
    theme: darkTheme,
  );
  runApp(
    SlidesApp(),
  );
}

final creativeCodingAsALearningToolSlides = <FlutterDeckSlideWidget>[
  PlaceholderSlide(
    'SECTION 1: CREATIVE CODING AS A LEARNING TOOL',
    subtitle: 'Introduction (why?)',
  ),
  PlaceholderSlide('1.1 Bubble Sort'),
  PlaceholderSlide(
    '1.1 Bubble Sort 1/n',
    subtitle: '(Explain the algorithm with image)',
  ),
  PlaceholderSlide(
    '1.1 Bubble Sort 2/n',
    subtitle: '(Code for single-run execution)',
    content: CodeHighlight(
      dartHighlighter,
      code: singleRunBubbleSortCode,
    ),
  ),
  PlaceholderSlide(
    '1.1 Bubble Sort 3/n',
    subtitle: '(Code for generating random floats)',
  ),
  PlaceholderSlide(
    '1.1 Bubble Sort 4/n - 1',
    subtitle:
        '(Code for painting the bars with the CustomPainter using the random floats list)',
  ),
  PlaceholderSlide(
    '1.1 Bubble Sort 4/n - 2',
    subtitle: 'Show random height bars',
    content: const BubbleSortBars(
      autoRun: false,
      count: 20,
    ),
  ),
  PlaceholderSlide(
    '1.1 Bubble Sort 5/n - 1',
    subtitle:
        '(Code for using one-time execution of bubble sort to sort the bars)',
  ),
  PlaceholderSlide(
    '1.1 Bubble Sort 5/n - 2',
    subtitle: 'Show sorted bars',
    content: const BubbleSortBars(
      autoRun: false,
      initSorted: true,
      count: 20,
    ),
  ),
  PlaceholderSlide(
    '1.1 Bubble Sort 6/n - 1',
    subtitle:
        '(Code to run by ticks step 1 - initialize a ticker with custom tick duration)',
  ),
  PlaceholderSlide(
    '1.1 Bubble Sort 6/n - 2',
    subtitle:
        '(Code to run by ticks step 2 - adjust sorting code to run by tick)',
  ),
  PlaceholderSlide(
    '1.1 Bubble Sort 7/n',
    subtitle: 'Run final bubble sort bars simulation',
    content: const BubbleSortBars(
      count: 20,
      autoRun: true,
      colorSortingBar: true,
      tickDuration: 300,
    ),
  ),
  PlaceholderSlide('1.2 Quick Sort'),
  PlaceholderSlide(
    '1.2 Quick Sort 1/n',
    subtitle:
        'Start complicated algorithm explanation - show highly complex image',
  ),
  PlaceholderSlide(
    '1.2 Quick Sort 2/n',
    subtitle: 'Show slowed-down simulation and explain the algorithm',
    content: const QuickSortBars(),
  ),
  PlaceholderSlide('1.3 Sorting Colors'),
  PlaceholderSlide(
    '1.3 Sorting Colors 1/n',
    subtitle:
        'Code for generating random HSL color (with option to randomize either hue/saturation/lightness)',
  ),
  PlaceholderSlide(
    '1.3 Sorting Colors 2/n',
    subtitle: 'Code for comparing hsl colors by hue/saturation/lightness',
  ),
  PlaceholderSlide(
    '1.3 Sorting Colors 3/n',
    subtitle:
        'Show simulation, has controls to experiment with generating/sorting by hue/saturation/lightness',
    content: const QuickSortColors(
      tickDuration: 10,
    ),
  ),
  PlaceholderSlide('1. Closing'),
];

final pixelSortingSlides = <FlutterDeckSlideWidget>[
  // Todo: reconsider the title
  PlaceholderSlide('SECTION 2: GLITCH ART WITH PIXEL SORTING'),
  PlaceholderSlide('2.1 Reading Image Pixels'),
  PlaceholderSlide(
    '2.1 Reading Image Pixels 1/n',
    subtitle: 'Decoding an image from an asset file',
    content: CodeHighlight(
      dartHighlighter,
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
    content: CodeHighlight(
      dartHighlighter,
      code: loadImagePixelColorsCode,
    ),
  ),
  PlaceholderSlide(
    '2.1 Reading Image Pixels 4/n',
    subtitle: 'Painting image pixel with canvas.drawRect',
    content: CodeHighlight(
      dartHighlighter,
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
      ),
      slides: [
        PlaceholderSlide('Splash Demo Slide'),
        PlaceholderSlide(
          'Code Meets Art: Flutter For Creative Coding',
          subtitle: '(speaker info &  splash demo as dimmed bg)',
        ),
        PlaceholderSlide('Introduction'),
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
          content: CodeHighlight(
            dartHighlighter,
            code: delaunayClassInputCode,
          ),
        ),
        PlaceholderSlide(
          '3.2. The Voronoi Diagram 3/n - (delaunay - 4)',
          subtitle:
              'Code for generating random points over width & height in Float32List',
          content: CodeHighlight(
            dartHighlighter,
            code: randomRawPointsGenerationCode,
          ),
        ),
        PlaceholderSlide(
          '3.2. The Voronoi Diagram 3/n - (delaunay - 5)',
          subtitle: 'Initialize delaunay with seed points, call update',
          content: CodeHighlight(
            dartHighlighter,
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
