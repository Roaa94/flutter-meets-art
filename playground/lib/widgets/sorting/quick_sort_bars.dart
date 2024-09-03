import 'dart:developer';
import 'dart:math' hide log;

import 'package:playground/enums.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

class QuickSortBarsPage extends StatelessWidget {
  const QuickSortBarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: QuickSortBars(
        count: 30,
        tickDuration: 300,
      ),
    );
  }
}

class QuickSortBars extends StatefulWidget {
  const QuickSortBars({
    super.key,
    this.count = 100,
    this.tickDuration = 100,
  });

  final int count;
  final int tickDuration;

  @override
  State<QuickSortBars> createState() => _QuickSortBarsState();
}

class _QuickSortBarsState extends State<QuickSortBars>
    with SingleTickerProviderStateMixin {
  final random = Random(4);
  late List<double> values;
  late List<SortingState> states;
  late Duration _tickDuration;
  final _completer = CancelableCompleter(onCancel: () => log('Canceled!'));

  _initValues() {
    values = List.generate(
      widget.count,
      (i) => random.nextDouble(),
    );
    states = List.filled(values.length, SortingState.idle);
  }

  _runQuickSort() async {
    _completer.complete(_quickSort(values, 0, values.length - 1));
    await _completer.operation.value;
    log('Finished!');
    states.fillRange(0, values.length, SortingState.idle);
    setState(() {});
  }

  _swap(List<double> arr, int i, int j) async {
    final double tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
    setState(() {});
    await Future.delayed(_tickDuration);
  }

  Future<void> _quickSort(List<double> arr, int start, int end) async {
    if (start >= end) return;
    final index = await _partition(arr, start, end);
    states[index] = SortingState.idle;
    await Future.wait([
      _quickSort(arr, start, index - 1),
      _quickSort(arr, index + 1, end),
    ]);
  }

  Future<int> _partition(List<double> arr, int start, int end) async {
    for (int i = start; i < end; i++) {
      states[i] = SortingState.partition;
    }
    states[end] = SortingState.pivotValue;
    int pivotIndex = start;
    final pivotValue = arr[end];
    for (int i = start; i < end; i++) {
      if (arr[i] < pivotValue) {
        await _swap(arr, i, pivotIndex);
        states[pivotIndex] = SortingState.idle;
        pivotIndex++;
        states[pivotIndex] = SortingState.pivotIndex;
      }
    }
    await _swap(arr, pivotIndex, end);
    for (int i = start; i <= end; i++) {
      if (i != pivotIndex) {
        states[i] = SortingState.idle;
      }
    }
    return pivotIndex;
  }

  @override
  void initState() {
    super.initState();
    _tickDuration = Duration(milliseconds: widget.tickDuration);
    _initValues();
    _runQuickSort();
  }

  @override
  void didUpdateWidget(covariant QuickSortBars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tickDuration != widget.tickDuration) {
      _tickDuration = Duration(milliseconds: widget.tickDuration);
    }
  }

  @override
  void dispose() {
    _completer.operation.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: CustomPaint(
        painter: QuickSortCustomPainter(
          values: values,
          states: states,
        ),
      ),
    );
  }
}

class QuickSortCustomPainter extends CustomPainter {
  QuickSortCustomPainter({
    required this.values,
    required this.states,
  });

  final List<double> values;
  final List<SortingState> states;

  @override
  void paint(Canvas canvas, Size size) {
    const padding = 4;
    final barWidth =
        (size.width - (padding * (values.length - 1))) / values.length;
    for (int i = 0; i < values.length; i++) {
      double left = i * (barWidth + padding);
      final barHeight = values[i] * size.height;
      final top = size.height - barHeight;

      canvas.drawRect(
        Rect.fromLTWH(
          left,
          top,
          barWidth,
          barHeight,
        ),
        Paint()..color = states[i].color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
