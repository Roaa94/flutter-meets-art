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
  SectionTitleSlide('Bubble Sort'),
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
    route: 'bubble-sort-single-run',
  ),
  // 06
  CodeSlide(
    randomValuesGenerationCode,
    title: 'Bubble Sort - Generate Random Values',
  ),
  // 07
  CodeSlide(
    bubbleSortPainterCode1,
    title: 'Bubble Sort - Paint Bars',
    route: 'bubble-sort-paint-bars-1',
    codeFontSize: 22,
  ),
  // 08
  CodeSlide(
    bubbleSortPainterCode2,
    title: 'Bubble Sort - Paint Bars',
    route: 'bubble-sort-paint-bars-2',
    codeFontSize: 22,
  ),
  // 09
  DemoSlide(
    'Bubble Sort - Paint Bars',
    route: 'bubble-sort-paint-bars-3',
    label: 'Bubble Sort',
    child: const BubbleSortBars(
      autoRun: false,
      count: 20,
    ),
  ),
  // 10
  CodeSlide(
    bubbleSortedValuesCode,
    title: 'Bubble Sort - Sort Bars',
    route: 'bubble-sort-sort-bars-1',
    codeFontSize: 22,
  ),
  // 11
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
  // 12
  CodeSlide(
    tickerInitializationCode1,
    route: 'init-ticker-1-mixin',
    title: 'Ticker Set-up - Mixin',
  ),
  // 13
  CodeSlide(
    tickerInitializationCode2,
    route: 'init-ticker-2-create',
    title: 'Ticker Set-up - Create & Start',
  ),
  // 14
  CodeSlide(
    tickerInitializationCode3,
    route: 'init-ticker-3-dispose',
    title: 'Ticker Set-up - Dispose',
    codeFontSize: 20,
  ),
  // 15
  CodeSlide(
    tickerInitializationCode4,
    route: 'init-ticker-4-custom-interval',
    title: 'Ticker Set-up - Custom Interval',
  ),
  // 16
  CodeSlide(bubbleSortTickCode,
      title: 'Bubble Sort by Tick',
      route: 'bubble-sort-by-tick-1',
      codeFontSize: 20),
  // 17
  CodeSlide(
    createTickerWithBubbleSortCode,
    title: 'Bubble Sort by Tick',
    route: 'bubble-sort-by-tick-2',
  ),
  // 18
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
  // 19
  SectionTitleSlide('Quick Sort'),
  // 20
  ImageSlide(
      title: 'Quick Sort Algorithm',
      path: 'assets/images/quick-sort.png',
      label: 'Quick sort algorithm illustration by IDEA'),
  // 21
  DemoSlide(
    'Quick Sort Simulation',
    label: 'Quick Sort',
    child: const QuickSortBars(),
  ),
  // 22
  SectionTitleSlide('Sorting Colors'),
  // 23
  CodeSlide(
    randomColorGenerationCode1,
    route: 'random-color-generation-1',
    title: 'Random HSL Color Generation',
  ),
  // 24
  CodeSlide(
    randomColorGenerationCode2,
    route: 'random-color-generation-2',
    title: 'Random HSL Color Generation',
  ),
  // 25
  CodeSlide(
    randomColorGenerationCode3,
    route: 'random-color-generation-3',
    title: 'Random HSL Color Generation',
  ),
  DemoSlide(
    'Color Sorting Simulation - by Hue',
    label: 'Color Sorting',
    child: const QuickSortColors(tickDuration: 20),
  ),
  DemoSlide(
    'Color Sorting Simulation - by Saturation',
    label: 'Color Sorting',
    child: const QuickSortColors(
      tickDuration: 20,
      colorSortProperty: ColorSortProperty.saturation,
    ),
  ),
  DemoSlide(
    'Color Sorting Simulation - by Lightness',
    label: 'Color Sorting',
    child: const QuickSortColors(
      tickDuration: 20,
      colorSortProperty: ColorSortProperty.lightness,
    ),
  ),
];
