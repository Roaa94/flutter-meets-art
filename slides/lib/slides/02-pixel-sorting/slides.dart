import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/slides/02-pixel-sorting/code.dart';
import 'package:slides/widgets/code_highlight.dart';
import 'package:slides/templates/placeholder_slide.dart';
import 'package:slides/templates/section_title_slide.dart';

final pixelSortingSlides = <FlutterDeckSlideWidget>[
  SectionTitleSlide('2. GLITCH ART WITH PIXEL SORTING'),
  PlaceholderSlide('2.1 Reading Image Pixels'),
  PlaceholderSlide(
    '2.1 Reading Image Pixels 1/n',
    subtitle: 'Decoding an image from an asset file',
    content: const CodeHighlight(
      loadImageAssetCode,
    ),
  ),
  PlaceholderSlide(
    '2.1 Reading Image Pixels 2/n',
    subtitle: 'Explain image byte data (with illustration)',
  ),
  PlaceholderSlide(
    '2.1 Reading Image Pixels 3/n',
    subtitle: 'Reading pixel colors list from image bytes',
    content: const CodeHighlight(
      loadImagePixelColorsCode,
    ),
  ),
  PlaceholderSlide(
    '2.1 Reading Image Pixels 4/n',
    subtitle: 'Painting image pixel with canvas.drawRect',
    content: const CodeHighlight(
      paintImagePixelsCode,
    ),
  ),
  PlaceholderSlide(
    '2.1 Reading Image Pixels 5/n',
    subtitle: 'Show a small painted image with zoom in/out for illustration',
  ),
  PlaceholderSlide('2.2 Sorting the Pixels'),
  PlaceholderSlide(
    '2.2 Sorting the Pixels 1/n',
    subtitle: 'Use HSLColor',
  ),
  PlaceholderSlide(
    '2.2 Sorting the Pixels 2/n',
    subtitle: 'Quick sort swap snippet, swapping based on color.lightness',
  ),
  PlaceholderSlide(
    '2.2 Sorting the Pixels 3/n',
    subtitle: 'Code to sort by row',
  ),
  PlaceholderSlide(
    '2.2 Sorting the Pixels 4/n',
    subtitle: 'Show simulation of image sorted by row',
  ),
  PlaceholderSlide(
    '2.2 Sorting the Pixels 5/n - (possibilities - 1)',
    subtitle: 'Show simulation of image sorted by column',
  ),
  PlaceholderSlide(
    '2.2 Sorting the Pixels 5/n - (possibilities - 2)',
    subtitle: 'Show simulation of image sorted by interval',
  ),
  PlaceholderSlide(
    '2.2 Sorting the Pixels 5/n - (possibilities - 3)',
    subtitle: 'Show simulation of image sorted by interval',
  ),
  PlaceholderSlide('2. Closing'),
];
