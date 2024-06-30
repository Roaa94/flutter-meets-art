const singleRunBubbleSortCode = '''_bubbleSort() {
  for (int i = 0; i < values.length; i++) {
    for (int j = 0; j < values.length - i - 1; j++) {
      final a = values[j];
      final b = values[j + 1];
      if (a > b) {
        _swap(values, j, j + 1);
      }
    }
  }
}''';

const randomValuesGenerationCode = '''
final values = List.generate(n, (i) => random.nextDouble());''';

const bubbleSortPainterCode1 = '''
class BubbleSortCustomPainter extends CustomPainter {
  BubbleSortCustomPainter({ required this.values });

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}''';

const bubbleSortPainterCode2 = '''
@override
void paint(Canvas canvas, Size size) {
  final barWidth = size.width / values.length;
  for (int i = 0; i < values.length; i++) {
    final barHeight = values[i] * size.height;
    canvas.drawRect(
      Rect.fromLTWH(
        i * barWidth,
        size.height - barHeight,
        barWidth,
        barHeight,
      ),
      Paint()..color = Colors.white,
    );
  }
}''';

const bubbleSortedValuesCode = '''
final values = List.generate(n, (i) => random.nextDouble());
 _bubbleSort();''';

const tickerInitializationCode1 = '''
class _BubbleSortBarsState extends State<BubbleSortBars>
    with SingleTickerProviderStateMixin {
  //...
}''';

const tickerInitializationCode2 = '''
class _BubbleSortBarsState extends State<BubbleSortBars>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  
  @override
  void initState() {
    super.initState();
    _ticker = createTicker((Duration elapsed) {
      // Todo: sort one bar
    });
    _ticker.start();
  }
  //...
}''';

const tickerInitializationCode3 = '''
class _BubbleSortBarsState extends State<BubbleSortBars>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  
  @override
  void initState() {
    super.initState();
    _ticker = createTicker((Duration elapsed) {
      // Todo: sort one bar
    });
    _ticker.start();
  }
  
  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
  //...
}''';

const tickerInitializationCode4 = '''
late Duration _tickDuration;

@override
void initState() {
  super.initState();
  _tickDuration = Duration(milliseconds: widget.tickDuration);
  _ticker = createTicker((Duration elapsed) {
    final elapsedDelta = elapsed - _lastTick;
    if (elapsedDelta >= _tickDuration) {
      _lastTick += _tickDuration;
      // Todo: sort one bar
    }
  });
  _ticker.start();
}''';

const bubbleSortTickCode = '''
class _BubbleSortBarsState extends State<BubbleSortBars>
    with SingleTickerProviderStateMixin {
  //...
  int i = 0; // Outer loop
  int j = 0; // Inner loop
  
  _bubbleSortTick() {
    if (j < values.length - i - 1) {
      final a = values[j];
      final b = values[j + 1];
      if (a > b) _swap(values, j, j + 1);
      j++;
    } else {
      j = 0;
      i++;
    }
    setState(() {});
  }
  //...
}''';

const createTickerWithBubbleSortCode = '''
_ticker = createTicker((Duration elapsed) {
  if (i < values.length) {
    final elapsedDelta = elapsed - _lastTick;
    if (elapsedDelta >= _tickDuration) {
      _lastTick += _tickDuration;
      _bubbleSortTick();
    }
  }
});''';

const randomColorGenerationCode1 = '''
List<Color> generateRandomColors(Random random, int n) {
  return List<Color>.generate(n, (index) {
    return HSLColor.fromAHSL(
      1.0, // Opacity
      random.nextDouble() * 360, // Hue [0 <=> 360]     
      1.0, // Saturation [0 <=> 1]
      0.5, // Lightness [0 <=> 1]
    ).toColor();
  });
}''';

const randomColorGenerationCode2 = '''
List<Color> generateRandomColors(Random random, int n) {
  return List<Color>.generate(n, (index) {
    return HSLColor.fromAHSL(
      1.0, // Opacity
      360, // Hue [0 <=> 360]
      random.nextDouble() * 1.0, // Saturation [0 <=> 1]
      0.5, // Lightness [0 <=> 1]
    ).toColor();
  });
}''';

const randomColorGenerationCode3 = '''
List<Color> generateRandomColors(Random random, int n) {
  return List<Color>.generate(n, (index) {
    return HSLColor.fromAHSL(
      1.0, // Opacity
      360, // Hue [0 <=> 360]
      1.0, // Saturation [0 <=> 1]
      random.nextDouble() * 0.5,  // Lightness [0 <=> 1]
    ).toColor();
  });
}''';
