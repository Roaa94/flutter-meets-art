import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

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
    return FlutterDeckSlide.custom(
      builder: (context) => SlideTextThemeWrapper(
        child: PlaceholderSlideContent(
          title,
          subtitle: subtitle,
          content: content,
        ),
      ),
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
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                subtitle!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          if (content != null) Expanded(child: Center(child: content!)),
        ],
      ),
    );
  }
}

class SlideTextThemeWrapper extends StatelessWidget {
  const SlideTextThemeWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Todo: use text styles instead
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: TextTheme(
          titleLarge: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontFamily: 'Poppins'),
          headlineLarge: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontFamily: 'Poppins',
                fontSize: 50,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
      child: child,
    );
  }
}
