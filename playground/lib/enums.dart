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
  polygonsOutlined;

  IconData get icon {
    switch(this) {
      case dots:
        return Icons.circle;
      case circles:
        return Icons.circle_outlined;
      case polygons:
        return Icons.pentagon;
      case polygonsOutlined:
        return Icons.pentagon_outlined;
    }
  }
}

enum StippleColorMode {
  colored,
  grayscale,
  black,
  white,
}
