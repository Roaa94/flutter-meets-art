import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/slides/06-conclusion/recap_slide.dart';
import 'package:flutter_friends_24_slides/templates/image_slide.dart';
import 'package:flutter_friends_24_slides/templates/section_title_slide.dart';

final conclusionSlides = <FlutterDeckSlideWidget>[
  SectionTitleSlide(
    'Why Creative Coding?',
    route: 'why-creative-coding',
  ),
  const RecapSlides(),
  ImageSlide(
    title: 'Voronoi in User Experience',
    path: 'assets/images/voronoi-chart-base.png',
    route: 'voronoi-ux-1',
    width: 1100,
  ),
  ImageSlide(
    title: 'Voronoi in User Experience',
    path: 'assets/images/voronoi-chart-2.png',
    route: 'voronoi-ux-2',
    width: 1100,
  ),
  SectionTitleSlide('It\'s also fun!'),
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
