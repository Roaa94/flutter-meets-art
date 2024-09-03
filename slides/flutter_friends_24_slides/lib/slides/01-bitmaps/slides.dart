import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/slides/00-introduction/agenda_slide.dart';
import 'package:flutter_friends_24_slides/slides/01-bitmaps/code.dart';
import 'package:flutter_friends_24_slides/slides/01-bitmaps/image_pixels_painter_slide.dart';
import 'package:flutter_friends_24_slides/slides/01-bitmaps/randomly_distributed_points_slide.dart';
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
    title: 'Image Bitmaps',
    path: 'assets/images/image-3x3.png',
    route: 'image-bitmaps-illustration-2',
    width: 400,
  ),
  // 35
  ImageSlide(
    title: 'Image Bitmaps',
    path: 'assets/images/image-3x3-rgba.png',
    route: 'image-bitmaps-illustration-3',
    width: 900,
  ),
  // 36
  ImageSlide(
    title: 'Image Bitmaps',
    path: 'assets/images/image-lists.png',
    route: 'image-bitmaps-illustration-4',
    width: 1000,
  ),
  // 37
  CodeSlide(
    loadImageBytesCode1,
    title: 'Reading an Image\'s Bitmap',
    route: 'reading-image-bytes-code-1',
  ),
  // 37
  CodeSlide(
    loadImageBytesCode2,
    title: 'Reading an Image\'s Bitmap',
    route: 'reading-image-bytes-code-2',
  ),
  // 40
  CodeSlide(
    paintImagePixelsCode1,
    title: 'Painting Image Pixels',
    route: 'paint-image-pixels-code-1',
    codeFontSize: 24,
  ),
  // 40
  CodeSlide(
    paintImagePixelsCode2,
    title: 'Painting Image Pixels',
    route: 'paint-image-pixels-code-2',
    codeFontSize: 24,
  ),
  // 41
  AgendaSlide(step: 3, completed: 1),
  // Randomly distributed points
  CodeSlide(
    generateRandomlyDistributedPointsCode1,
    title: 'Random point distribution',
    route: 'random-points-1',
  ),
  // Randomly distributed points
  CodeSlide(
    generateRandomlyDistributedPointsCode2,
    title: 'Random point distribution',
    route: 'random-points-2',
  ),
  CodeSlide(
    generateRandomlyDistributedPointsCode3,
    title: 'Random point distribution',
    route: 'random-points-3',
  ),
  const RandomlyDistributedPointsSlide(),
  AgendaSlide(step: 3, completed: 2),
];
