import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/styles/text_styles.dart';
import 'package:slides/widgets/template_slide.dart';

class PlaceholderSlide extends FlutterDeckSlideWidget {
  PlaceholderSlide(this.title, {this.subtitle, this.content})
      : super(
          configuration: FlutterDeckSlideConfiguration(
            route: '/${title.toLowerCase().replaceAll(' ', '')}',
            title: '$title${subtitle == null ? '' : ' - $subtitle'}',
          ),
        );

  final String title;
  final String? subtitle;
  final Widget? content;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return TemplateSlide(
      title,
      subtitle: subtitle,
      showHeader: false,
      content: PlaceholderSlideContent(
        title,
        subtitle: subtitle,
        content: content,
      ),
    ).build(context);
  }
}

class PlaceholderSlideContent extends StatelessWidget {
  const PlaceholderSlideContent(
    this.title, {
    super.key,
    this.subtitle,
    this.content,
  });

  final String title;
  final String? subtitle;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Text(
              title,
              style: TextStyles.title,
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                subtitle!,
                style: TextStyles.subtitle,
              ),
            ),
          if (content != null) Expanded(child: Center(child: content!)),
        ],
      ),
    );
  }
}
