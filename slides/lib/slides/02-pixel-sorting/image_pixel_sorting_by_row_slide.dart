import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/templates/build_template_slide.dart';
import 'package:slides/widgets/window_frame.dart';

class ImagePixelSortingByRowSlide extends FlutterDeckSlideWidget {
  const ImagePixelSortingByRowSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/pixel-sorting-by-row',
            title: 'Pixel Sorting - By Row',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'Pixel Sorting - By Row',
      showHeader: true,
      content: const Center(
        child: WindowFrame(
          label: 'Glitch Art',
          margin: EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
          size: Size(400 * 3, 225 * 3),
          child: PixelSortingDemo(
            imagePath: 'assets/images/dash-bg-400p.png',
            tickDuration: 20,
            zoom: 3,
            pixelSortStyle: PixelSortStyle.byRow,
          ),
        ),
      ),
    );
  }
}
