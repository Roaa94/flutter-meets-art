import 'package:app/app.dart';
import 'package:app/enums.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/slides/01-cc-as-as-learning-tool/code.dart';
import 'package:slides/templates/code_slide.dart';
import 'package:slides/templates/demo_slide.dart';
import 'package:slides/templates/image_slide.dart';
import 'package:slides/templates/section_title_slide.dart';

final creativeCodingAsALearningToolSlides = <FlutterDeckSlideWidget>[
  // 02
  SectionTitleSlide('1. CREATIVE CODING AS A LEARNING TOOL'),
  // 03
  SectionTitleSlide(
    'Bubble Sort',
    isSubtitle: true,
  ),
  // 04
  ImageSlide(
    title: 'Bubble Sort',
    route: 'bubble-sort-image',
    path: 'assets/images/bubble-sort.png',
    label: 'Bubble Sort illustration by Eliana Lopez',
  ),
  // 05
  CodeSlide(
    singleRunBubbleSortCode,
    title: 'Bubble Sort - Code',
    route: 'bubble-sort-single-run-1',
  ),
  // 06
  CodeSlide(
    bubbleSortSwapCode,
    title: 'Bubble Sort - Code',
    route: 'bubble-sort-single-run-2',
  ),
  // 07
  CodeSlide(
    randomValuesGenerationCode,
    title: 'Bubble Sort - Generate Random Values',
  ),
  // 08
  CodeSlide(
    bubbleSortPainterCode1,
    title: 'Bubble Sort - Paint Bars',
    route: 'bubble-sort-paint-bars-1',
    codeFontSize: 22,
  ),
  // 09
  CodeSlide(
    bubbleSortPainterCode2,
    title: 'Bubble Sort - Paint Bars',
    route: 'bubble-sort-paint-bars-2',
    codeFontSize: 22,
  ),
  // 10
  DemoSlide(
    'Bubble Sort - Paint Bars',
    route: 'bubble-sort-paint-bars-3',
    label: 'Bubble Sort',
    child: const BubbleSortBars(
      autoRun: false,
      count: 20,
    ),
  ),
  // 11
  CodeSlide(
    bubbleSortedValuesCode,
    title: 'Bubble Sort - Sort Bars',
    route: 'bubble-sort-sort-bars-1',
    codeFontSize: 22,
  ),
  // 12
  DemoSlide(
    'Bubble Sort - Sort Bars',
    route: 'bubble-sort-sort-bars-2',
    label: 'Bubble Sort',
    child: const BubbleSortBars(
      autoRun: false,
      initSorted: true,
      count: 20,
    ),
  ),
  // 13
  CodeSlide(
    tickerInitializationCode1,
    route: 'init-ticker-1-mixin',
    title: 'Ticker Set-up - Mixin',
  ),
  // 14
  CodeSlide(
    tickerInitializationCode2,
    route: 'init-ticker-2-create',
    title: 'Ticker Set-up - Create & Start',
  ),
  // 15
  CodeSlide(
    tickerInitializationCode3,
    route: 'init-ticker-3-dispose',
    title: 'Ticker Set-up - Dispose',
    codeFontSize: 20,
  ),
  // 16
  CodeSlide(
    tickerInitializationCode4,
    route: 'init-ticker-4-custom-interval',
    title: 'Ticker Set-up - Custom Interval',
  ),
  // 17
  CodeSlide(
    bubbleSortTickCode,
    title: 'Bubble Sort by Tick',
    route: 'bubble-sort-by-tick-1',
    codeFontSize: 20,
  ),
  // 18
  CodeSlide(
    createTickerWithBubbleSortCode,
    title: 'Bubble Sort by Tick',
    route: 'bubble-sort-by-tick-2',
  ),
  // 19
  DemoSlide(
    'Bubble Sort Simulation',
    label: 'Bubble Sort',
    child: const BubbleSortBars(
      count: 20,
      autoRun: true,
      colorSortingBar: true,
      tickDuration: 300,
    ),
  ),
  // 20
  SectionTitleSlide(
    'Quick Sort',
    isSubtitle: true,
  ),
  // 21
  ImageSlide(
    title: 'Quick Sort Algorithm',
    path: 'assets/images/quick-sort.png',
    label: 'Quick sort algorithm illustration by IDEA',
  ),
  // 22
  DemoSlide(
    'Quick Sort Simulation',
    label: 'Quick Sort',
    child: const QuickSortBars(),
  ),
  // 23
  CodeSlide(
    quickSortRecursionCode,
    title: 'Quick Sort Code',
    route: 'quick-sort-code-1',
  ),
  // 24
  CodeSlide(
    quickSortSwapCode,
    title: 'Quick Sort Code',
    route: 'quick-sort-code-2',
  ),
  // 25
  SectionTitleSlide(
    'Sorting Colors',
    isSubtitle: true,
  ),
  // 26
  CodeSlide(
    randomColorGenerationCode1,
    route: 'random-color-generation-1',
    title: 'Random HSL Color Generation',
  ),
  // 27
  CodeSlide(
    randomColorGenerationCode2,
    route: 'random-color-generation-2',
    title: 'Random HSL Color Generation',
  ),
  // 28
  CodeSlide(
    randomColorGenerationCode3,
    route: 'random-color-generation-3',
    title: 'Random HSL Color Generation',
  ),
  // 29
  DemoSlide(
    'Color Sorting Simulation - by Hue',
    label: 'Color Sorting',
    child: const QuickSortColors(tickDuration: 20),
  ),
  // 30
  DemoSlide(
    'Color Sorting Simulation - by Saturation',
    label: 'Color Sorting',
    child: const QuickSortColors(
      tickDuration: 20,
      colorSortProperty: ColorSortProperty.saturation,
    ),
  ),
  // 31
  DemoSlide(
    'Color Sorting Simulation - by Lightness',
    label: 'Color Sorting',
    child: const QuickSortColors(
      tickDuration: 20,
      colorSortProperty: ColorSortProperty.lightness,
    ),
  ),
];
