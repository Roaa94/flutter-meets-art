import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/code.dart';
import 'package:slides/code_highlight.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Highlighter.initialize([
    'dart',
    'yaml',
    'sql',
    'json',
  ]);
  var darkTheme = await HighlighterTheme.loadDarkTheme();
  final dartDarkHighlighter = Highlighter(
    language: 'dart',
    theme: darkTheme,
  );
  runApp(
    SlidesApp(dartHighlighter: dartDarkHighlighter),
  );
}

class SlidesApp extends StatelessWidget {
  const SlidesApp({super.key, required this.dartHighlighter});

  final Highlighter dartHighlighter;

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
        PlaceholderSlide(
          'Code Meets Art: Flutter For Creative Coding',
          subtitle: '(speaker info &  splash demo as dimmed bg)',
        ),
        PlaceholderSlide('Introduction'),
        PlaceholderSlide(
          'SECTION 1: CREATIVE CODING AS A LEARNING TOOL',
          subtitle: 'Introduction (why?)',
        ),
        PlaceholderSlide('1.1 Bubble Sort'),
        PlaceholderSlide(
          '1.1 Bubble Sort 1/n',
          subtitle: '(Explain the algorithm with image)',
        ),
        PlaceholderSlide(
          '1.1 Bubble Sort 2/n',
          subtitle: '(Code for single-run execution)',
          content: CodeHighlight(
            dartHighlighter,
            code: singleRunBubbleSortCode,
          ),
        ),
        PlaceholderSlide(
          '1.1 Bubble Sort 3/n',
          subtitle: '(Code for generating random floats)',
        ),
        PlaceholderSlide(
          '1.1 Bubble Sort 4/n - 1',
          subtitle:
              '(Code for painting the bars with the CustomPainter using the random floats list)',
        ),
        PlaceholderSlide(
          '1.1 Bubble Sort 4/n - 2',
          subtitle: 'Show random height bars',
          content: const BubbleSortBars(
            autoRun: false,
            count: 20,
          ),
        ),
        PlaceholderSlide(
          '1.1 Bubble Sort 5/n - 1',
          subtitle:
              '(Code for using one-time execution of bubble sort to sort the bars)',
        ),
        PlaceholderSlide(
          '1.1 Bubble Sort 5/n - 2',
          subtitle: 'Show sorted bars',
          content: const BubbleSortBars(
            autoRun: false,
            initSorted: true,
            count: 20,
          ),
        ),
        PlaceholderSlide(
          '1.1 Bubble Sort 6/n - 1',
          subtitle:
              '(Code to run by ticks step 1 - initialize a ticker with custom tick duration)',
        ),
        PlaceholderSlide(
          '1.1 Bubble Sort 6/n - 2',
          subtitle:
              '(Code to run by ticks step 2 - adjust sorting code to run by tick)',
        ),
        PlaceholderSlide(
          '1.1 Bubble Sort 7/n',
          subtitle: 'Run final bubble sort bars simulation',
          content: const BubbleSortBars(
            count: 20,
            autoRun: true,
            colorSortingBar: true,
            tickDuration: 300,
          ),
        ),
        PlaceholderSlide('1.2 Quick Sort'),
        PlaceholderSlide(
          '1.2 Quick Sort 1/n',
          subtitle:
              'Start complicated algorithm explanation - show highly complex image',
        ),
        PlaceholderSlide(
          '1.2 Quick Sort 2/n',
          subtitle: 'Show slowed-down simulation and explain the algorithm',
          content: const QuickSortBars(),
        ),
        PlaceholderSlide('1.3 Sorting Colors'),
        PlaceholderSlide(
          '1.3 Sorting Colors 1/n',
          subtitle:
              'Code for generating random HSL color (with option to randomize either hue/saturation/lightness)',
        ),
        PlaceholderSlide(
          '1.3 Sorting Colors 2/n',
          subtitle: 'Code for comparing hsl colors by hue/saturation/lightness',
        ),
        PlaceholderSlide(
          '1.3 Sorting Colors 3/n',
          subtitle:
              'Show simulation, has controls to experiment with generating/sorting by hue/saturation/lightness',
          content: const QuickSortColors(
            tickDuration: 10,
          ),
        ),
        PlaceholderSlide('SECTION 2: ALGORITHMIC ART'),
        PlaceholderSlide('2.1 Reading Image Pixels'),
        PlaceholderSlide(
          '2.1 Reading Image Pixels 1/n',
          subtitle: 'Decoding an image from an asset file',
          content: CodeHighlight(
            dartHighlighter,
            code: loadImageAssetCode,
          ),
        ),
      ],
    );
  }
}

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
