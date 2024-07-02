import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/slides/02-pixel-sorting/code.dart';
import 'package:slides/slides/02-pixel-sorting/image_pixels_painter_slide.dart';
import 'package:slides/templates/code_slide.dart';
import 'package:slides/templates/image_slide.dart';
import 'package:slides/templates/placeholder_slide.dart';
import 'package:slides/templates/section_title_slide.dart';

final pixelSortingSlides = <FlutterDeckSlideWidget>[
  // 29
  SectionTitleSlide('2. GLITCH ART WITH PIXEL SORTING'),
  // 30
  SectionTitleSlide(
    'Reading Pixel Colors from Image Bitmaps',
    isSubtitle: true,
  ),
  // 31
  // ImageSlide(
  //   title: 'Reading Pixel Colors from Image Bitmaps',
  //   path: 'assets/images/pixel-to-color.png',
  //   route: 'reading-image-pixels-illustration-1',
  //   label: 'Goal: get Color type from pixel coordinates',
  //   width: 800,
  // ),
  // 31
  ImageSlide(
    title: 'Reading Pixel Colors from Image Bitmaps',
    path: 'assets/images/image-3x3.png',
    route: 'reading-image-pixels-illustration-2',
    width: 400,
  ),
  // 32
  ImageSlide(
    title: 'Reading Pixel Colors from Image Bitmaps',
    path: 'assets/images/image-3x3-rgba.png',
    route: 'reading-image-pixels-illustration-3',
    width: 900,
  ),
  // 33
  ImageSlide(
    title: 'Reading Pixel Colors from Image Bitmaps',
    path: 'assets/images/image-lists.png',
    route: 'reading-image-pixels-illustration-4',
    width: 1000,
  ),
  // 34
  CodeSlide(
    loadImageBytesCode,
    title: 'Reading Pixel Colors from Image Bitmaps',
    route: 'reading-image-pixel-colors-code-1',
  ),
  // 35
  CodeSlide(
    getColorsListFromImageCode1,
    title: 'Reading Pixel Colors from Image Bitmaps',
    route: 'reading-image-pixel-colors-code-2',
  ),
  // 36
  CodeSlide(
    getColorsListFromImageCode2,
    title: 'Reading Pixel Colors from Image Bitmaps',
    route: 'reading-image-pixel-colors-code-3',
  ),
  // 37
  CodeSlide(
    paintImagePixelsCode,
    title: 'Painting Image Pixel',
  ),
  const ImagePixelsPainterSlide(),
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
