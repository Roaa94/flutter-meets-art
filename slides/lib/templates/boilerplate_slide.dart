import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/templates/template_slide.dart';

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
    return TemplateSlide(
      '',
      showHeader: true,
      // content: ,
    ).build(context);
  }
}
