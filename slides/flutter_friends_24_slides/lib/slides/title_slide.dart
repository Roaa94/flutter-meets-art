import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/styles/text_styles.dart';
import 'package:flutter_friends_24_slides/widgets/stippled_flutter_logo.dart';

class TitleSlide extends FlutterDeckSlideWidget {
  const TitleSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/code-meets-art',
            title: 'Code Meets Art',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.custom(
      builder: (context) => SizedBox.expand(
        child: ColoredBox(
          color: Colors.black,
          child: Stack(
            children: [
              const StippledFlutterLogo(scale: 1.6),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(100),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Code Meets',
                          style: TextStyles.titleXL,
                          children: <TextSpan>[
                            TextSpan(
                              text: ' Art',
                              style: TextStyles.titleXL.copyWith(
                                color: const Color(0xff35aee7),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'Flutter for Creative Coding',
                        style: TextStyles.title,
                      ),
                      const SizedBox(height: 200),
                      Text(
                        'Roaa Khaddam',
                        style: TextStyles.h1.copyWith(fontSize: 35),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
