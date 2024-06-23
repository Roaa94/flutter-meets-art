import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

void main() {
  runApp(const SlidesApp());
}

class SlidesApp extends StatelessWidget {
  const SlidesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterDeckApp(
      themeMode: ThemeMode.dark,
      speakerInfo: const FlutterDeckSpeakerInfo(
        name: 'Roaa Khaddam',
        description: 'Software Engineer, Flutter & Dart GDE',
        imagePath: 'assets/images/profile-pic-min.png',
        socialHandle: '@roaakdm',
      ),
      configuration: const FlutterDeckConfiguration(
        showProgress: false,
        controls: FlutterDeckControlsConfiguration(
          presenterToolbarVisible: true,
        ),
      ),
      slides: [
        PlaceholderSlide('Splash Demo Slide'),
        PlaceholderSlide('Title (with splash demo as dimmed bg)'),
        PlaceholderSlide('Introduction'),
      ],
    );
  }
}

class PlaceholderSlide extends FlutterDeckSlideWidget {
  PlaceholderSlide(this.title)
      : super(
          configuration: FlutterDeckSlideConfiguration(
            route: '/${title.toLowerCase().replaceAll(' ', '')}',
            title: title,
          ),
        );

  final String title;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.custom(
      builder: (context) => SlideTextThemeWrapper(
        child: PlaceholderSlideContent(title),
      ),
    );
  }
}

class PlaceholderSlideContent extends StatelessWidget {
  const PlaceholderSlideContent(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineLarge,
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
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      child: child,
    );
  }
}
