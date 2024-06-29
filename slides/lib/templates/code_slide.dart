import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/templates/build_template_slide.dart';
import 'package:slides/widgets/code_highlight.dart';

class CodeSlide extends FlutterDeckSlideWidget {
  CodeSlide(
    this.code, {
    this.subtitle,
    required this.title,
    this.codeFontSize = 27,
    this.showHeader = true,
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
  final String code;
  final double codeFontSize;
  final bool showHeader;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: title,
      showHeader: showHeader,
      content: Center(
        child: CodeHighlight(
          code,
          fontSize: codeFontSize,
        ),
      ),
    );
  }
}
