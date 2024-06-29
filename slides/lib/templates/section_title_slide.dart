import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/styles/text_styles.dart';
import 'package:slides/templates/build_template_slide.dart';

class SectionTitleSlide extends FlutterDeckSlideWidget {
  SectionTitleSlide(
    this.title, {
    this.subtitle,
    this.route,
  }) : super(
          configuration: FlutterDeckSlideConfiguration(
            route: route != null
                ? '/$route'
                : '/${title.toLowerCase().replaceAll(' ', '')}',
            title: '$title${subtitle == null ? '' : ' - $subtitle'}',
          ),
        );

  final String title;
  final String? subtitle;
  final String? route;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: title,
      showHeader: false,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200.0),
        child: Center(
          child: Text(
            title,
            style: TextStyles.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
