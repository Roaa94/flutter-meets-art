import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BubbleSortBarsPage extends StatelessWidget {
  const BubbleSortBarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: BubbleSortBars(
        count: 30,
        colorSortingBar: true,
        tickDuration: 100,
        initSorted: false,
        autoRun: true,
      ),
    );
  }
}

class BubbleSortBars extends StatefulWidget {
  const BubbleSortBars({
    super.key,
    this.count = 100,
    this.colorSortingBar = false,
    this.tickDuration = 100,
    this.initSorted = false,
    this.autoRun = false,
  });

  final int count;
  final bool colorSortingBar;
  final int tickDuration;
  final bool initSorted;
  final bool autoRun;

  @override
  State<BubbleSortBars> createState() => _BubbleSortBarsState();
}

class _BubbleSortBarsState extends State<BubbleSortBars>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final random = Random(3);
  late List<double> values;
  Duration _lastTick = Duration.zero;
  late Duration _tickInterval;

  int i = 0; // Outer loop
  int j = 0; // Inner loop

  _initValues() {
    // Generate a list of random double values ranging from 0.0 to 1.0
    i = 0;
    j = 0;
    values = List.generate(
      widget.count,
      (i) => random.nextDouble(),
    );
    if (widget.initSorted) {
      _bubbleSort();
    }
  }

  _swap(List<double> arr, int i, int j) {
    final double tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
  }

  _bubbleSort() {
    for (int i = 0; i < values.length; i++) {
      for (int j = 0; j < values.length - i - 1; j++) {
        final a = values[j];
        final b = values[j + 1];
        if (a > b) {
          _swap(values, j, j + 1);
        }
      }
    }
  }

  _bubbleSortTick() {
    if (j < values.length - i - 1) {
      final a = values[j];
      final b = values[j + 1];
      if (a > b) {
        _swap(values, j, j + 1);
      }
      j++;
    } else {
      j = 0;
      i++;
    }
    setState(() {});
  }

  void _onTick(Duration elapsed) {
    if (i < values.length) {
      final elapsedDelta = elapsed - _lastTick;
      if (elapsedDelta >= _tickInterval) {
        _lastTick += _tickInterval;
        _bubbleSortTick();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tickInterval = Duration(milliseconds: widget.tickDuration);
    _ticker = createTicker(_onTick);
    _initValues();
    if (!widget.initSorted && widget.autoRun) {
      _ticker.start();
    }
  }

  @override
  void didUpdateWidget(covariant BubbleSortBars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tickDuration != widget.tickDuration) {
      _tickInterval = Duration(milliseconds: widget.tickDuration);
    }
    if (oldWidget.count != widget.count) {
      _initValues();
    }
    if (oldWidget.initSorted != widget.initSorted) {
      _initValues();
      if (widget.initSorted && _ticker.isActive) {
        _ticker.stop();
      }
    }
    if (oldWidget.autoRun != widget.autoRun) {
      if (widget.autoRun && !_ticker.isActive) {
        _ticker.start();
      } else {
        _ticker.stop();
      }
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: BubbleSortCustomPainter(
          values: values,
          activeBarIndex: j,
          swappedBarIndex: i,
          colorSortingBar: widget.colorSortingBar,
        ),
      ),
    );
  }
}

class BubbleSortCustomPainter extends CustomPainter {
  BubbleSortCustomPainter({
    required this.values,
    this.activeBarIndex = 0,
    this.swappedBarIndex = 0,
    this.colorSortingBar = false,
  });

  final List<double> values;
  final int activeBarIndex;
  final int swappedBarIndex;
  final bool colorSortingBar;

  @override
  void paint(Canvas canvas, Size size) {
    const padding = 4;
    final barWidth =
        (size.width - (padding * (values.length - 1))) / values.length;
    for (int i = 0; i < values.length; i++) {
      final barHeight = values[i] * size.height;
      canvas.drawRect(
        Rect.fromLTWH(
          i * (barWidth + padding),
          size.height - barHeight,
          barWidth,
          barHeight,
        ),
        Paint()
          ..color = i == activeBarIndex && colorSortingBar
              ? Colors.red
              : Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
