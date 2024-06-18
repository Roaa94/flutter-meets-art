import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BubbleSortPage extends StatelessWidget {
  const BubbleSortPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BubbleSortBars(
        min: 20,
        max: size.height - 50,
        count: 50,
      ),
    );
  }
}

class BubbleSortBars extends StatefulWidget {
  const BubbleSortBars({
    super.key,
    this.min = 0,
    this.max = 200,
    this.count = 100,
  });

  final double min;
  final double max;
  final int count;

  @override
  State<BubbleSortBars> createState() => _BubbleSortBarsState();
}

class _BubbleSortBarsState extends State<BubbleSortBars>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final random = Random(3);
  late Float32List barHeights;
  Duration _lastTick = Duration.zero;
  final Duration _tickInterval = const Duration(milliseconds: 500);

  int j = 0;
  int i = 0;

  _initBars() {
    barHeights = Float32List(widget.count);
    for (int i = 0; i < barHeights.length; i++) {
      barHeights[i] = widget.min + (random.nextDouble() * widget.max);
    }
    // _bubbleSort();
  }

  _swap(Float32List arr, int i, int j) {
    final double tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
  }

  _bubbleSort() {
    for (int i = 0; i < barHeights.length; i++) {
      for (int j = 0; j < barHeights.length - i - 1; j++) {
        final a = barHeights[j];
        final b = barHeights[j + 1];
        if (a > b) {
          _swap(barHeights, j, j + 1);
        }
      }
    }
  }

  _bubbleSortTick() {
    if (j < barHeights.length - i - 1) {
      final a = barHeights[j];
      final b = barHeights[j + 1];
      if (a > b) {
        _swap(barHeights, j, j + 1);
      }
      j++;
    } else {
      j = 0;
      i++;
    }
    setState(() {});
  }

  void _onTick(Duration elapsed) {
    if (i < barHeights.length) {
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
    _ticker = createTicker(_onTick);
    _initBars();
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: Colors.black,
        child: CustomPaint(
          painter: BubbleSortCustomPainter(
            barHeights: barHeights,
            activeBarIndex: j,
            swappedBarIndex: i,
          ),
        ),
      ),
    );
  }
}

class BubbleSortCustomPainter extends CustomPainter {
  BubbleSortCustomPainter({
    required this.barHeights,
    this.activeBarIndex = 0,
    this.swappedBarIndex = 0,
  });

  final Float32List barHeights;
  final int activeBarIndex;
  final int swappedBarIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / barHeights.length;
    for (int i = 0; i < barHeights.length; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          i * barWidth,
          size.height - barHeights[i],
          barWidth,
          barHeights[i],
        ),
        Paint()..color = i == activeBarIndex ? Colors.red : Colors.white,
      );

      canvas.drawRect(
        Rect.fromLTWH(
          i * barWidth,
          size.height - barHeights[i],
          barWidth,
          barHeights[i],
        ),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.black,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
