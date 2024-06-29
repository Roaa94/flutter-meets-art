import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/slides/00-introduction/splash_slide.dart';
import 'package:slides/widgets/placeholder_slide.dart';

final introductionSlides = <FlutterDeckSlideWidget>[
  SplashSlide(),
  PlaceholderSlide(
    'Code Meets Art: Flutter For Creative Coding',
    subtitle: '(speaker info &  splash demo as dimmed bg)',
  ),
  PlaceholderSlide('Introduction'),
];
