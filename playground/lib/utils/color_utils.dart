import 'dart:math';

import 'package:flutter/material.dart';

int rgbaToArgb(int rgbaColor) {
  return ((rgbaColor & 0x000000FF) << 24) | ((rgbaColor & 0xFFFFFF00) >> 8);
}

List<HSLColor> generateRandomHSLColors(
  Random random,
  int n, {
  bool randomHue = true,
  bool randomSaturation = false,
  bool randomLightness = false,
  double initialHue = 360.0,
}) {
  return List<HSLColor>.generate(n, (index) {
    return HSLColor.fromAHSL(
      1.0, // Opacity
      // from 0 to 360
      randomHue ? random.nextDouble() * initialHue : initialHue,
      // from 0 to 1, default should be 1
      randomSaturation ? random.nextDouble() : 1.0,
      // from 0 to 1, default should be 0.5
      randomLightness ? random.nextDouble() : 0.5,
    );
  });
}

List<Color> generateIncrementalHSLColors(
  int n, {
  double initialHue = 360.0,
  double saturation = 1.0,
}) {
  return List<Color>.generate(n, (index) {
    return HSLColor.fromAHSL(
      1.0, // Opacity
      // from 0 to 360
      initialHue * (1 - (index / n)),
      // from 0 to 1, default should be 1
      saturation,
      // from 0 to 1, default should be 0.5
      // 0.5 * (1 - (index / n)),
      0.5,
    ).toColor();
  });
}

List<Color> generateRandomColors(
  Random random,
  int n, {
  bool randomHue = true,
  bool randomSaturation = false,
  bool randomLightness = false,
  double initialHue = 360.0,
}) {
  return List<Color>.generate(n, (index) {
    return HSLColor.fromAHSL(
      1.0, // Opacity
      // from 0 to 360
      randomHue ? random.nextDouble() * initialHue : initialHue,
      // from 0 to 1, default should be 1
      randomSaturation ? random.nextDouble() : 1.0,
      // from 0 to 1, default should be 0.5
      randomLightness ? random.nextDouble() : 0.5,
    ).toColor();
  });
}
