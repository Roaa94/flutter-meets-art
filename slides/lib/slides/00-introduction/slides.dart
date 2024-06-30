import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/slides/00-introduction/splash_slide.dart';
import 'package:slides/slides/00-introduction/title_slide.dart';

final introductionSlides = <FlutterDeckSlideWidget>[
  // Todo: consider running the app separately for the splash demo to avoid crashes
  SplashSlide(),
  const TitleSlide(),
];
