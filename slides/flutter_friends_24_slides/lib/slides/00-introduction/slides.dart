import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/slides/00-introduction/agenda_slide.dart';
import 'package:flutter_friends_24_slides/templates/image_slide.dart';
import 'package:flutter_friends_24_slides/templates/placeholder_slide.dart';
import 'package:flutter_friends_24_slides/templates/section_title_slide.dart';

final introductionSlides = <FlutterDeckSlideWidget>[
  PlaceholderSlide('Descartes & The Universe'),
  PlaceholderSlide('John Snow & Cholera'),
  PlaceholderSlide('Stipple Art Intro'),
  ImageSlide(
    title: 'Stipple Engraving',
    path: 'assets/images/stippling-greyscale.png',
    width: 800,
    label: 'Giulio Campagnola, around 1510 - "The Young Shepherd"',
  ),
  // 52
  ImageSlide(
    title: 'Colored Stipple Engraving',
    path: 'assets/images/stippling-cupid-and-aglaia.png',
    width: 800,
    label:
        'Francesco Bartolozzi (1727-1815) "Cupid Binding Aglaia to a Laurel"',
  ),
  // 53
  SectionTitleSlide(
    'How do we approach this?',
    isSubtitle: true,
    route: 'approach-to-stippling',
  ),
  // 56
  AgendaSlide(step: 1),
  AgendaSlide(step: 2),
  AgendaSlide(step: 3),
];
