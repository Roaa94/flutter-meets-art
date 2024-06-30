import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/slides/00-introduction/splash_slide.dart';
import 'package:slides/templates/placeholder_slide.dart';

final introductionSlides = <FlutterDeckSlideWidget>[
  // Todo: consider running the app separately for the splash demo to avoid crashes
  SplashSlide(),
  PlaceholderSlide(
    'Code Meets Art: Flutter For Creative Coding',
    subtitle: '(speaker info &  splash demo as dimmed bg)',
  ),
  PlaceholderSlide('Talk Introduction'),
];
