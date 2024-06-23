import 'package:flutter/material.dart';

enum ColorSortProperty {
  hue,
  saturation,
  lightness;
}

enum SortingState {
  pivotIndex,
  pivotValue,
  partition,
  idle;

  Color get color {
    switch (this) {
      case pivotIndex:
        return Colors.red;
      case pivotValue:
        return Colors.green;
      case partition:
        return Colors.blue;
      case idle:
        return Colors.white;
    }
  }
}
