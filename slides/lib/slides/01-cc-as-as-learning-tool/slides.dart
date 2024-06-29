import 'package:app/app.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/slides/01-cc-as-as-learning-tool/bubble_sort_algorithm_slide.dart';
import 'package:slides/slides/01-cc-as-as-learning-tool/bubble_sort_code_slide.dart';
import 'package:slides/slides/01-cc-as-as-learning-tool/title.dart';
import 'package:slides/widgets/placeholder_slide.dart';

final creativeCodingAsALearningToolSlides = <FlutterDeckSlideWidget>[
  // 01
  CCAsALearningToolTitleSlide(),
  // 02
  PlaceholderSlide('1.1 Bubble Sort'),
  // 03
  BubbleSortAlgorithmSlide(),
  // 04
  BubbleSortCodeSlide(),
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
