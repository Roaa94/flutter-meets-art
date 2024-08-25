import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/slides/00-introduction/agenda_slide.dart';
import 'package:flutter_friends_24_slides/slides/01-bitmaps/code.dart';
import 'package:flutter_friends_24_slides/slides/01-bitmaps/image_pixels_painter_slide.dart';
import 'package:flutter_friends_24_slides/slides/01-bitmaps/randomized_image_stippling_slide.dart';
import 'package:flutter_friends_24_slides/templates/code_slide.dart';
import 'package:flutter_friends_24_slides/templates/image_slide.dart';
import 'package:flutter_friends_24_slides/templates/section_title_slide.dart';

final bitmapsSlides = <FlutterDeckSlideWidget>[
  // 32
  SectionTitleSlide(
    'IMAGE BITMAPS',
    subtitle: 'Reading Image Pixel Colors',
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
    loadImageBytesCode1,
    title: 'Reading Pixel Colors from Image Bitmaps',
    route: 'reading-image-bytes-code-1',
  ),
  // 37
  CodeSlide(
    loadImageBytesCode2,
    title: 'Reading Pixel Colors from Image Bitmaps',
    route: 'reading-image-bytes-code-2',
  ),
  // 38
  CodeSlide(
    getColorsListFromImageCode1,
    title: 'Reading Pixel Colors from Image Bitmaps',
    route: 'reading-image-pixel-colors-code-1',
  ),
  // 39
  CodeSlide(
    getColorsListFromImageCode2,
    title: 'Reading Pixel Colors from Image Bitmaps',
    route: 'reading-image-pixel-colors-code-2',
  ),
  // 40
  CodeSlide(
    paintImagePixelsCode,
    title: 'Painting Image Pixel',
  ),
  // 41
  const ImagePixelsPainterSlide(),
  AgendaSlide(step: 3, completed: 1),
  CodeSlide(
    generateRandomPointsFromPixelsCode,
    title: 'Image Pixels Random Point Generation',
    codeFontSize: 20,
  ),
  const RandomizedImageStipplingSlide(),
  AgendaSlide(step: 3, completed: 2),
];
