import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/styles/text_styles.dart';
import 'package:slides/templates/build_template_slide.dart';
import 'package:slides/widgets/stippled_flutter_logo.dart';

class SectionTitleSlide extends FlutterDeckSlideWidget {
  SectionTitleSlide(
    this.title, {
    this.subtitle,
    this.route,
    this.isSubtitle = false,
  }) : super(
          configuration: FlutterDeckSlideConfiguration(
            route: route != null
                ? '/$route'
                : '/${title.toLowerCase().replaceAll(' ', '-')}',
            title: '$title${subtitle == null ? '' : ' - $subtitle'}',
          ),
        );

  final String title;
  final String? subtitle;
  final String? route;
  final bool isSubtitle;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: title,
      showHeader: false,
      content: Stack(
        children: [
          const StippledFlutterLogo(scale: 1.2),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 200.0),
              child: Center(
                child: Text(
                  title,
                  style: isSubtitle ? TextStyles.subtitle : TextStyles.title,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
