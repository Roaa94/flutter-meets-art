import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/styles/text_styles.dart';
import 'package:flutter_friends_24_slides/templates/build_template_slide.dart';

class AgendaSlide extends FlutterDeckSlideWidget {
  AgendaSlide({this.step = 1, this.completed = 0, this.route})
      : super(
          configuration: FlutterDeckSlideConfiguration(
            route: route != null ? '/$route' : '/agenda-$step-$completed',
            title: 'Goals',
          ),
        );

  final int step;
  final int completed;
  final String? route;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'Goals',
      showHeader: true,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: step >= 1 ? 1 : 0,
              child: Text(
                '${completed >= 1 ? '✅' : '☑️'} Process image pixels and read their colors',
                style: TextStyles.subtitleSM,
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 50),
            Opacity(
              opacity: step >= 2 ? 1 : 0,
              child: Text(
                '${completed >= 2 ? '✅' : '☑️'} Lay-out seed points in a random distribution',
                style: TextStyles.subtitleSM,
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 50),
            Opacity(
              opacity: step >= 3 ? 1 : 0,
              child: Text(
                '${completed >= 3 ? '✅' : '☑️'} Move the seed points to “stipple” the underlying image',
                style: TextStyles.subtitleSM,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
