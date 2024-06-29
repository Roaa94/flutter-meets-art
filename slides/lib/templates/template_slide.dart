import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/styles/text_styles.dart';

class TemplateSlide extends FlutterDeckSlideWidget {
  TemplateSlide(
    this.title, {
    this.subtitle,
    this.content,
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
  final Widget? content;
  final bool showHeader;
  final String? route;

  @override
  FlutterDeckSlide build(BuildContext context) {
    final flutterDeck = FlutterDeck.of(context);
    final slideNumber = flutterDeck.slideNumber;
    final speakerInfo = flutterDeck.speakerInfo;

    return FlutterDeckSlide.template(
      headerBuilder: showHeader
          ? (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12,
                ),
                child: Text(title, style: TextStyles.h1),
              );
            }
          : null,
      contentBuilder: content == null ? null : (context) => content!,
      footerBuilder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  speakerInfo!.socialHandle,
                  style: TextStyles.footer,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    slideNumber.toString(),
                    style: TextStyles.footer,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
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
