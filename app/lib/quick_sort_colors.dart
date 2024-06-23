import 'dart:developer';
import 'dart:math' hide log;

import 'package:app/utils.dart';
import 'package:flutter/material.dart';

class QuickSortColorsPage extends StatelessWidget {
  const QuickSortColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: QuickSortColors(
        count: 500,
        tickDuration: 5,
      ),
    );
  }
}

class QuickSortColors extends StatefulWidget {
  const QuickSortColors({
    super.key,
    this.count = 100,
    this.tickDuration = 100,
  });

  final int count;
  final int tickDuration;

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
    );
  }

  _runQuickSort() async {
    await _quickSort(values, 0, values.length - 1);
    log('Finished!');
    setState(() {});
  }

  _swap(List<HSLColor> arr, int i, int j) async {
    final HSLColor tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
    setState(() {});
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

  Future<int> _partition(List<HSLColor> arr, int start, int end) async {
    int pivotIndex = start;
    final pivotValue = arr[end];
    for (int i = start; i < end; i++) {
      if (arr[i].hue < pivotValue.hue) {
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
        painter: QuickSortCustomPainter(
          values: values,
        ),
      ),
    );
  }
}

class QuickSortCustomPainter extends CustomPainter {
  QuickSortCustomPainter({
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
