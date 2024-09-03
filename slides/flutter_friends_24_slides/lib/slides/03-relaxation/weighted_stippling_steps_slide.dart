import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_friends_24_slides/styles/text_styles.dart';
import 'package:flutter_friends_24_slides/templates/build_template_slide.dart';

class WeightedStipplingStepsSlide extends FlutterDeckSlideWidget {
  WeightedStipplingStepsSlide({
    this.step = 0,
  }) : super(
          configuration: FlutterDeckSlideConfiguration(
            route: '/weighted-centroids-calculation-$step',
            title: 'Weighted Centroids Calculation',
          ),
        );

  final int step;

  @override
  FlutterDeckSlide build(BuildContext context) {
    const textStyle = TextStyle(
      fontFamily: TextStyles.defaultFontFamily,
      color: Colors.white,
      fontSize: 28,
      fontWeight: FontWeight.w400,
    );
    return buildTemplateSlide(
      context,
      showHeader: true,
      title: 'Weighted Centroids Calculation',
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 120),
        child: Center(
          child: Stack(
            children: [
              Image.asset('assets/images/weighted-voronoi.png'),
              Positioned.fill(
                child: Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: SizedBox.expand(),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: const EdgeInsets.all(30),
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('1. Loop over all pixels', style: textStyle),
                            const SizedBox(height: 20),
                            const Text('2. For each pixel', style: textStyle),
                            const SizedBox(height: 20),
                            const Padding(
                              padding: EdgeInsets.only(left: 50),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '1. Get color',
                                    style: textStyle,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    '2. Calculate brightness',
                                    style: textStyle,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    '3. Find Voronoi polygon',
                                    style: textStyle,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              '3. Accumulate pixel brightnesses of each polygon',
                              style: textStyle,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              '4. Calculate average for each polygon',
                              style: textStyle,
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'That\'s the weighted centroid!',
                              style: textStyle.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
