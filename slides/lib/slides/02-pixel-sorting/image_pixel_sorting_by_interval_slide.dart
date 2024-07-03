import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/templates/build_template_slide.dart';
import 'package:slides/widgets/window_frame.dart';

class ImagePixelSortingByIntervalSlide extends FlutterDeckSlideWidget {
  const ImagePixelSortingByIntervalSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/image-pixel-sorting-by-interval',
            title: 'Image Pixel Sorting - By Interval',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'Image Pixel Sorting - By Interval',
      showHeader: true,
      content: const Center(
        child: WindowFrame(
          label: 'Glitch Art',
          margin: EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
          child: PixelSortingDemo(
            imagePath: 'assets/images/sea-700w.jpg',
            tickDuration: 5,
            zoom: 2,
            pixelSortStyle: PixelSortStyle.byIntervalColumn,
          ),
        ),
      ),
    );
  }
}
