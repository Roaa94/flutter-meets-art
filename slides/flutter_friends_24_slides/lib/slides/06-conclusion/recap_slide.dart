import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/styles/text_styles.dart';
import 'package:flutter_friends_24_slides/templates/build_template_slide.dart';

class RecapSlides extends FlutterDeckSlideWidget {
  const RecapSlides()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/recap',
            title: 'Topics Covered',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'Topics Explored',
      showHeader: true,
      content: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ℹ️ Image bitmaps',
              style: TextStyles.subtitleSM,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 50),
            Text(
              'ℹ️ Memory efficient data structures',
              style: TextStyles.subtitleSM,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 50),
            Text(
              'ℹ️ Using algorithms to create art',
              style: TextStyles.subtitleSM,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 50),
            Text(
              'ℹ️ Flutter Canvas API',
              style: TextStyles.subtitleSM,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 50),
            Text(
              'ℹ️ The Voronoi Diagram',
              style: TextStyles.subtitleSM,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
