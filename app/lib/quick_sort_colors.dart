import 'dart:developer';
import 'dart:math' hide log;

import 'package:app/enums.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';

class QuickSortColorsPage extends StatelessWidget {
  const QuickSortColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: QuickSortColors(
        count: 200,
        tickDuration: 5,
        colorSortProperty: ColorSortProperty.hue,
        initialHue: 360,
      ),
    );
  }
}

class QuickSortColors extends StatefulWidget {
  const QuickSortColors({
    super.key,
    this.count = 100,
    this.tickDuration = 100,
    this.colorSortProperty = ColorSortProperty.hue,
    this.initialHue = 360.0,
  });

  final int count;
  final int tickDuration;
  final double initialHue;
  final ColorSortProperty colorSortProperty;

  @override
  State<QuickSortColors> createState() => _QuickSortColorsState();
}

class _QuickSortColorsState extends State<QuickSortColors>
    with SingleTickerProviderStateMixin {
  final random = Random(4);
  late List<HSLColor> values;
  late Duration _tickDuration;

  _initColors() {
    values = generateRandomHSLColors(
      random,
      widget.count,
      randomHue: widget.colorSortProperty == ColorSortProperty.hue,
      randomSaturation:
          widget.colorSortProperty == ColorSortProperty.saturation,
      randomLightness: widget.colorSortProperty == ColorSortProperty.lightness,
      initialHue: widget.initialHue,
    );
  }

  _runQuickSort() async {
    await _quickSort(values, 0, values.length - 1);
    log('Finished!');
  }

  _swap(List<HSLColor> arr, int i, int j) async {
    final HSLColor tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
    if(mounted) setState(() {});
    await Future.delayed(_tickDuration);
  }

  Future<void> _quickSort(List<HSLColor> arr, int start, int end) async {
    if (start >= end) {
      return;
    }
    final index = await _partition(arr, start, end);
    await Future.wait([
      _quickSort(arr, start, index - 1),
      _quickSort(arr, index + 1, end),
    ]);
  }

  double _getValue(HSLColor color) {
    switch (widget.colorSortProperty) {
      case ColorSortProperty.hue:
        return color.hue;
      case ColorSortProperty.saturation:
        return color.saturation;
      case ColorSortProperty.lightness:
        return color.lightness;
    }
  }

  Future<int> _partition(List<HSLColor> arr, int start, int end) async {
    int pivotIndex = start;
    final pivotValue = arr[end];
    final pivotValueToCompare = _getValue(pivotValue);
    for (int i = start; i < end; i++) {
      final targetValueToCompare = _getValue(arr[i]);
      if (targetValueToCompare < pivotValueToCompare) {
        await _swap(arr, i, pivotIndex);
        pivotIndex++;
      }
    }
    await _swap(arr, pivotIndex, end);
    return pivotIndex;
  }

  @override
  void initState() {
    super.initState();
    _tickDuration = Duration(milliseconds: widget.tickDuration);
    _initColors();
    _runQuickSort();
  }

  @override
  void didUpdateWidget(covariant QuickSortColors oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tickDuration != widget.tickDuration) {
      _tickDuration = Duration(milliseconds: widget.tickDuration);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: CustomPaint(
        painter: QuickSortColorsCustomPainter(
          values: values,
        ),
      ),
    );
  }
}

class QuickSortColorsCustomPainter extends CustomPainter {
  QuickSortColorsCustomPainter({
    required this.values,
  });

  final List<HSLColor> values;

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = (size.width + values.length) / values.length;
    for (int i = 0; i < values.length; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          i * (barWidth - 1),
          0,
          barWidth,
          size.height,
        ),
        Paint()..color = values[i].toColor(),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
