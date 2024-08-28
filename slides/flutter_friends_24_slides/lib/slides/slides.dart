import 'package:flutter_friends_24_slides/slides/03-relaxation/slides.dart';
import 'package:flutter_friends_24_slides/slides/title_slide.dart';

import '../templates/placeholder_slide.dart';
import '00-introduction/slides.dart';
import '01-bitmaps/slides.dart';
import '02-voronoi/slides.dart';
import '06-conclusion/slides.dart';

final slides = [
  const TitleSlide(),
  ...introductionSlides,
  ...bitmapsSlides,
  ...voronoiSlides,
  ...relaxationSlides,
  PlaceholderSlide('UI & Art'),
  PlaceholderSlide('Performance'),
  ...conclusionSlides,
];
