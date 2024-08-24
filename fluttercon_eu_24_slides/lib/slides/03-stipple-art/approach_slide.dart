import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:fluttercon_eu_24_slides/styles/text_styles.dart';
import 'package:fluttercon_eu_24_slides/templates/build_template_slide.dart';

class ApproachSlide extends FlutterDeckSlideWidget {
  const ApproachSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/approach-to-stippling-1',
            title: 'Approach to Stippling',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'Approach to Stippling',
      showHeader: true,
      content: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Random(ish) point distribution',
              style: TextStyles.subtitle,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 50),
            Text(
              '2. Move points based on underlying image pixels',
              style: TextStyles.subtitle,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
