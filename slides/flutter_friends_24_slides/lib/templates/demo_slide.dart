import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/templates/build_template_slide.dart';
import 'package:flutter_friends_24_slides/widgets/window_frame.dart';

class DemoSlide extends FlutterDeckSlideWidget {
  DemoSlide(
    this.title, {
    this.subtitle,
    this.label,
    this.showHeader = true,
    this.child,
    this.route,
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
  final String? label;
  final bool showHeader;
  final Widget? child;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      showHeader: showHeader,
      title: title,
      content: WindowFrame(
        label: label,
        margin: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
        child: child,
      ),
    );
  }
}
