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

enum PixelSortStyle {
  full,
  byRow,
  byColumn,
  byIntervalRow,
  byIntervalColumn;

  bool get transposed {
    return this == byColumn || this == byIntervalColumn;
  }
}

enum StippleMode {
  dots,
  circles,
  polygons,
  polygonsOutlined,
}

enum StippleColorMode {
  colored,
  grayscale,
  black,
  white,
}