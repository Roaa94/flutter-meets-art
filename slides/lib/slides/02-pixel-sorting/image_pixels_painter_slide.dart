import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/demos/bitmap_demo.dart';
import 'package:slides/templates/build_template_slide.dart';

class ImagePixelsPainterSlide extends FlutterDeckSlideWidget {
  const ImagePixelsPainterSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/painting-image-pixels-demo',
            title: 'Painting Image Pixels',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'Painting Image Pixels',
      showHeader: true,
      content: const BitmapDemo(),
    );
  }
}
