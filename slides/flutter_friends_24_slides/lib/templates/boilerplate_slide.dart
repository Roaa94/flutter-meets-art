import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/templates/build_template_slide.dart';

class BoilerplateSlide extends FlutterDeckSlideWidget {
  BoilerplateSlide()
      : super(
          configuration: FlutterDeckSlideConfiguration(
            route: '',
            title: '',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
    );
  }
}
