import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/slides/01-cc-as-as-learning-tool/code.dart';
import 'package:slides/templates/code_slide.dart';
import 'package:slides/templates/image_slide.dart';
import 'package:slides/templates/placeholder_slide.dart';
import 'package:slides/templates/section_title_slide.dart';
import 'package:slides/widgets/window_frame.dart';

final creativeCodingAsALearningToolSlides = <FlutterDeckSlideWidget>[
  // 01
  SectionTitleSlide('1. CREATIVE CODING AS A LEARNING TOOL'),
  // 02
  SectionTitleSlide('Bubble Sort'),
  // 03
  // ImageSlide(
  //   title: 'Bubble Sort 1/n',
  //   path: 'assets/images/',
  //   subtitle: '(Explain the algorithm with image)',
  // ),
  // 04
  CodeSlide(
    singleRunBubbleSortCode,
    title: 'Bubble Sort - Single Run',
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
    content: const WindowFrame(
      margin: EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
      child: BubbleSortBars(
        autoRun: false,
        count: 20,
      ),
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
    content: const WindowFrame(
      margin: EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
      child: BubbleSortBars(
        autoRun: false,
        initSorted: true,
        count: 20,
      ),
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
    content: const WindowFrame(
      margin: EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
      child: BubbleSortBars(
        count: 20,
        autoRun: true,
        colorSortingBar: true,
        tickDuration: 300,
      ),
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
    content: const WindowFrame(
      margin: EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
      child: QuickSortBars(),
    ),
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
    content: const WindowFrame(
      margin: EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
      child: QuickSortColors(
        tickDuration: 10,
      ),
    ),
  ),
  PlaceholderSlide('1. Closing'),
];
