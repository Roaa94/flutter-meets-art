import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/styles/text_styles.dart';
import 'package:slides/widgets/template_slide.dart';

class SectionTitleSlide extends FlutterDeckSlideWidget {
  SectionTitleSlide(
    this.title, {
    this.subtitle,
  }) : super(
          configuration: FlutterDeckSlideConfiguration(
            route: '/${title.toLowerCase().replaceAll(' ', '')}',
            title: '$title${subtitle == null ? '' : ' - $subtitle'}',
          ),
        );

  final String title;
  final String? subtitle;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return TemplateSlide(
      title,
      showHeader: false,
      content: Center(
        child: Text(
          title,
          style: TextStyles.title,
        ),
      ),
    ).build(context);
  }
}
