import 'package:playground/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:fluttercon_eu_24_slides/demos/image_pixel_sorting_demo.dart';
import 'package:fluttercon_eu_24_slides/templates/build_template_slide.dart';
import 'package:fluttercon_eu_24_slides/widgets/window_frame.dart';

class ImagePixelSortingByIntervalSlide extends FlutterDeckSlideWidget {
  const ImagePixelSortingByIntervalSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/pixel-sorting-by-interval',
            title: 'Pixel Sorting - By Interval',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'Pixel Sorting - By Interval',
      showHeader: true,
      content: const ImagePixelSortingDemo(),
    );
  }
}