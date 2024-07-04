import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:slides/widgets/controls.dart';
import 'package:slides/widgets/window_frame.dart';

class ImagePixelSortingDemo extends StatefulWidget {
  const ImagePixelSortingDemo({super.key});

  @override
  State<ImagePixelSortingDemo> createState() => _ImagePixelSortingDemoState();
}

class _ImagePixelSortingDemoState extends State<ImagePixelSortingDemo> {
  static const double iconSize = 30;
  static const double controlsSize = 52;
  static const double borderRadius = 15;

  bool trigger = false;
  bool showThreshold = false;
  double thresholdMin = 0.2;
  double thresholdMax = 0.8;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
      child: WindowFrame(
        label: 'Glitch Art',
        child: Stack(
          children: [
            PixelSortingDemo(
              imagePath: 'assets/images/sea-700w.jpg',
              tickDuration: 20,
              zoom: 1.9,
              pixelSortStyle: PixelSortStyle.byIntervalColumn,
              autoStart: false,
              trigger: trigger,
              showThreshold: showThreshold,
              thresholdMin: thresholdMin,
              thresholdMax: thresholdMax,
            ),
            Positioned(
              bottom: 0.1,
              right: 0,
              left: 0,
              child: RepaintBoundary(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ControlsButton(
                      onTap: () =>
                          setState(() => showThreshold = !showThreshold),
                      size: controlsSize,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
                      iconSize: iconSize,
                      icon: showThreshold
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    const SizedBox(width: 10),
                    Controls(
                      size: controlsSize,
                      iconSize: iconSize,
                      borderRadius: borderRadius,
                      centerColor: const Color(0xff2f8087),
                      onPlus: () {
                        if (thresholdMin < thresholdMax) {
                          setState(() {
                            thresholdMin += 0.1;
                          });
                        }
                      },
                      onMinus: () {
                        if (thresholdMin > 0) {
                          setState(() {
                            thresholdMin -= 0.1;
                          });
                        }
                      },
                      icon: Icons.arrow_back_ios,
                      label: Text(
                        'Min (${thresholdMin.toStringAsFixed(1)})',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Controls(
                      size: controlsSize,
                      centerColor: const Color(0xff2f8087),
                      borderRadius: borderRadius,
                      onPlus: () {
                        if (thresholdMin < thresholdMax) {
                          setState(() {
                            thresholdMax += 0.1;
                          });
                        }
                      },
                      onMinus: () {
                        if (thresholdMax > 0) {
                          setState(() {
                            thresholdMax -= 0.1;
                          });
                        }
                      },
                      label: Text(
                        'Max (${thresholdMax.toStringAsFixed(1)})',
                        textAlign: TextAlign.center,
                      ),
                      iconSize: iconSize,
                    ),
                    const SizedBox(width: 10),
                    ControlsButton(
                      onTap: () => setState(() => trigger = !trigger),
                      icon: Icons.play_arrow,
                      size: controlsSize,
                      iconSize: iconSize,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
