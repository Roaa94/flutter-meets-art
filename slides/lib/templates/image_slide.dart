import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/templates/build_template_slide.dart';

import '../styles/text_styles.dart';

class ImageSlide extends FlutterDeckSlideWidget {
  ImageSlide({
    this.subtitle,
    required this.title,
    required this.path,
    this.showHeader = true,
    this.label,
    this.padding = const EdgeInsets.symmetric(horizontal: 120),
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
  final String path;
  final String? subtitle;
  final String? route;
  final bool showHeader;
  final String? label;
  final EdgeInsetsGeometry padding;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: title,
      showHeader: showHeader,
      content: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset(path)),
            if (label != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(label!, style: TextStyles.label),
              ),
          ],
        ),
      ),
    );
  }
}
