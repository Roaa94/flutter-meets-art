import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/widgets/code_highlight.dart';
import 'package:slides/templates/template_slide.dart';

class DemoSlide extends FlutterDeckSlideWidget {
  DemoSlide(
    this.code, {
    this.subtitle,
    required this.title,
    this.codeFontSize = 27,
  }) : super(
          configuration: FlutterDeckSlideConfiguration(
            route: '/${title.toLowerCase().replaceAll(' ', '')}',
            title: '$title${subtitle == null ? '' : ' - $subtitle'}',
          ),
        );

  final String title;
  final String? subtitle;
  final String code;
  final double codeFontSize;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return TemplateSlide(
      title,
      showHeader: true,
      content: Center(
        child: CodeHighlight(
          code,
          fontSize: codeFontSize,
        ),
      ),
    ).build(context);
  }
}
