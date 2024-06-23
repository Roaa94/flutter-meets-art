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
}) {
  return List<HSLColor>.generate(n, (index) {
    return HSLColor.fromAHSL(
      1.0,
      randomHue ? random.nextDouble() * 360 : 360,
      randomSaturation ? random.nextDouble() : 1.0,
      randomLightness ? random.nextDouble() : 0.5,
    );
  });
}
