import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides/slides/00-introduction/slides.dart';
import 'package:slides/slides/01-cc-as-as-learning-tool/slides.dart';
import 'package:slides/slides/02-pixel-sorting/slides.dart';
import 'package:slides/slides/03-stipple-art/slides.dart';
import 'package:slides/slides/06-conclusion/slides.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

final highlighterProvider = Provider<Highlighter>(
  (_) => throw UnimplementedError(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Highlighter.initialize([
    'dart',
    'yaml',
    'sql',
    'json',
  ]);
  var darkTheme = await HighlighterTheme.loadDarkTheme();
  final dartHighlighter = Highlighter(
    language: 'dart',
    theme: darkTheme,
  );

  runApp(
    ProviderScope(
      overrides: [
        highlighterProvider.overrideWithValue(dartHighlighter),
      ],
      child: const SlidesApp(),
    ),
  );
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
        background: FlutterDeckBackgroundConfiguration(
          // Todo: add bg image (stipple pattern?) & pick better color
          dark: FlutterDeckBackground.solid(Colors.black),
        ),
        transition: FlutterDeckTransition.fade(),
      ),
      slides: [
        ...introductionSlides,
        ...creativeCodingAsALearningToolSlides,
        ...pixelSortingSlides,
        ...stippleArtSlides,
        ...conclusionSlides,
      ],
    );
  }
}
