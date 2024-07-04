import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/slides/01-cc-as-as-learning-tool/code.dart';
import 'package:slides/slides/02-pixel-sorting/code.dart';
import 'package:slides/slides/02-pixel-sorting/image_pixel_sorting_by_column_slide.dart';
import 'package:slides/slides/02-pixel-sorting/image_pixel_sorting_by_interval_slide.dart';
import 'package:slides/slides/02-pixel-sorting/image_pixel_sorting_by_row_slide.dart';
import 'package:slides/slides/02-pixel-sorting/image_pixels_painter_slide.dart';
import 'package:slides/templates/code_slide.dart';
import 'package:slides/templates/image_slide.dart';
import 'package:slides/templates/placeholder_slide.dart';
import 'package:slides/templates/section_title_slide.dart';

final pixelSortingSlides = <FlutterDeckSlideWidget>[
  // 32
  SectionTitleSlide('2. GLITCH ART WITH PIXEL SORTING'),
  // 33
  SectionTitleSlide(
    'Reading Pixel Colors from Image Bitmaps',
    isSubtitle: true,
  ),
  // 34
  ImageSlide(
    title: 'Reading Pixel Colors from Image Bitmaps',
    path: 'assets/images/image-3x3.png',
    route: 'reading-image-pixels-illustration-2',
    width: 400,
  ),
  // 35
  ImageSlide(
    title: 'Reading Pixel Colors from Image Bitmaps',
    path: 'assets/images/image-3x3-rgba.png',
    route: 'reading-image-pixels-illustration-3',
    width: 900,
  ),
  // 36
  ImageSlide(
    title: 'Reading Pixel Colors from Image Bitmaps',
    path: 'assets/images/image-lists.png',
    route: 'reading-image-pixels-illustration-4',
    width: 1000,
  ),
  // 37
  CodeSlide(
    loadImageBytesCode,
    title: 'Reading Pixel Colors from Image Bitmaps',
    route: 'reading-image-pixel-colors-code-1',
  ),
  // 38
  CodeSlide(
    getColorsListFromImageCode1,
    title: 'Reading Pixel Colors from Image Bitmaps',
    route: 'reading-image-pixel-colors-code-2',
  ),
  // 39
  CodeSlide(
    getColorsListFromImageCode2,
    title: 'Reading Pixel Colors from Image Bitmaps',
    route: 'reading-image-pixel-colors-code-3',
  ),
  // 40
  CodeSlide(
    paintImagePixelsCode,
    title: 'Painting Image Pixel',
  ),
  // 41
  const ImagePixelsPainterSlide(),
  // 42
  SectionTitleSlide(
    'Pixel Sorting',
    isSubtitle: true,
  ),
  // 43
  CodeSlide(
    getHSLColorsListFromImageCode,
    title: 'Bitmap HSL Colors',
  ),
  // 44
  CodeSlide(
    sortPixelsByRowCode1,
    title: 'Pixel Sorting',
    route: 'pixel-sorting-code-1',
  ),
  // 45
  CodeSlide(
    sortPixelsByRowCode2,
    title: 'Pixel Sorting',
    route: 'pixel-sorting-code-2',
  ),
  // 46
  CodeSlide(
    sortPixelsByRowCode3,
    title: 'Pixel Sorting',
    route: 'pixel-sorting-code-3',
  ),
  // 47
  const ImagePixelSortingByRowSlide(),
  // 48
  const ImagePixelSortingByColumnSlide(),
  // 49
  const ImagePixelSortingByIntervalSlide(),
];
