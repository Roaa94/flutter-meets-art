import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/slides/00-introduction/agenda_slide.dart';
import 'package:flutter_friends_24_slides/templates/image_slide.dart';
import 'package:flutter_friends_24_slides/templates/section_title_slide.dart';

final introductionSlides = <FlutterDeckSlideWidget>[
  ImageSlide(
      title: 'I think, therefore I am',
      path: 'assets/images/descartes.jpg',
      showHeader: false,
      width: 1000),
  ImageSlide(
    title: 'Rene Descartes\' vortices - 1644',
    path: 'assets/images/descartes-vortices.jpg',
    width: 500,
  ),
  ImageSlide(
    title: 'Broad Street cholera outbreak - 1854',
    path: 'assets/images/cholera.png',
    width: 900,
    route: 'broadstreet-1',
    label:
        'Original map by John Snow showing the clusters of cholera cases (1854) - Wikipedia',
  ),
  ImageSlide(
    title: 'Broad Street cholera outbreak - 1854',
    path: 'assets/images/cholera-pumps.png',
    width: 900,
    route: 'broadstreet-2',
    label:
        'Original map by John Snow showing the clusters of cholera cases (1854) - Wikipedia',
  ),
  // ImageSlide(
  //   title: 'John Snow\'s Map',
  //   path: 'assets/images/cholera-voronoi.png',
  //   width: 700,
  //   label:
  //       'Remaking John Snow\'s map of Broad Street cholera, 1854 - sciencedirect.com',
  // ),
  ImageSlide(
    title: 'Early, unofficial examples of a Voronoi Diagram ',
    path: 'assets/images/rene-and-snow.png',
    route: 'early-voronoi',
  ),
  SectionTitleSlide('Stippling / Stipple Engraving'),
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
