import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/styles/text_styles.dart';

FlutterDeckSlide buildTemplateSlide(
  BuildContext context, {
  String? title,
  bool showHeader = false,
  Widget? content,
}) {
  final flutterDeck = FlutterDeck.of(context);
  final slideNumber = flutterDeck.slideNumber;
  final speakerInfo = flutterDeck.speakerInfo;

  return FlutterDeckSlide.template(
    headerBuilder: showHeader
        ? (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 15.0,
              ),
              child: title != null
                  ? Text(title, style: TextStyles.h1)
                  : Container(),
            );
          }
        : null,
    contentBuilder: content == null ? null : (context) => content,
    footerBuilder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 12,
        ),
        child: Row(
          children: [
            // Todo: add FlutterCon logo
            Expanded(child: Container()),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '$slideNumber | ${speakerInfo!.socialHandle}',
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
