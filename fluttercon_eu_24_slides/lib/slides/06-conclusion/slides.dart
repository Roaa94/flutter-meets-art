import 'package:flutter_deck/flutter_deck.dart';
import 'package:fluttercon_eu_24_slides/templates/image_slide.dart';
import 'package:fluttercon_eu_24_slides/templates/section_title_slide.dart';

final conclusionSlides = <FlutterDeckSlideWidget>[
  SectionTitleSlide(
    'Why Flutter?',
    route: 'why-flutter',
  ),
  ImageSlide(
    title: 'Party Dash',
    path: 'assets/images/party-dash-1.gif',
    route: 'party-dash-1',
  ),
  ImageSlide(
    title: 'Party Dash',
    path: 'assets/images/party-dash.gif',
    route: 'party-dash-21',
  ),
  ImageSlide(
    title: 'Avenger Dash',
    path: 'assets/images/fading-dash.gif',
  ),
  SectionTitleSlide(
    'Thank you!',
    route: 'last',
  ),
];
