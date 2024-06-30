import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/styles/text_styles.dart';

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
              // _buildStippledDash(),
              _buildStippledFlutterLogo(),
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

  Widget _buildStippledFlutterLogo() {
    return Positioned(
      bottom: 40,
      right: 70,
      child: Transform.scale(
        scale: 1.6,
        alignment: Alignment.bottomRight,
        child: const Opacity(
          opacity: 0.2,
          child: WeightedVoronoiStipplingDemo(
            showVoronoiPolygons: false,
            paintColors: true,
            showImage: false,
            showPoints: true,
            pointsCount: 2000,
            weightedStrokes: true,
            minStroke: 8,
            wiggleFactor: 0.5,
            imagePath: 'assets/images/flutter-logo.png',
            maxStroke: 20,
            // strokePaintingStyle: true,
          ),
        ),
      ),
    );
  }

  Widget _buildStippledDash() {
    return Positioned(
      bottom: -100,
      right: -330,
      child: Opacity(
        opacity: 0.2,
        child: Transform.scale(
          scale: 1.65,
          alignment: Alignment.bottomRight,
          child: const WeightedVoronoiStipplingDemo(
            showVoronoiPolygons: false,
            paintColors: true,
            showImage: false,
            showPoints: true,
            pointsCount: 1000,
            weightedStrokes: true,
            minStroke: 8,
            maxStroke: 23,
            // strokePaintingStyle: true,
            imagePath: 'assets/images/dash.jpg',
            animate: true,
          ),
        ),
      ),
    );
  }
}
