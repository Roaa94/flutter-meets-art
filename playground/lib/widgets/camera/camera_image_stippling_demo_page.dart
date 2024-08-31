import 'package:flutter/material.dart';
import 'package:playground/enums.dart';
import 'package:playground/widgets/camera/camera_image_stippling_controls.dart';
import 'package:playground/widgets/camera/camera_image_stippling_demo.dart';

class CameraImageStipplingDemoPage extends StatefulWidget {
  const CameraImageStipplingDemoPage({super.key});

  @override
  State<CameraImageStipplingDemoPage> createState() =>
      _CameraImageStipplingDemoPageState();
}

class _CameraImageStipplingDemoPageState
    extends State<CameraImageStipplingDemoPage> {
  static const defaultMode = StippleMode.circles;
  static const defaultMinStroke = 7.0;
  static const defaultMaxStroke = 30.0;
  static const defaultShowColors = true;
  static const defaultWeightedPoints = false;
  late int _pointsCount;

  StippleMode _mode = defaultMode;
  double _minStroke = defaultMinStroke;
  double _maxStroke = defaultMaxStroke;
  bool _showColors = defaultShowColors;
  bool _weightedPoints = defaultWeightedPoints;

  int getDefaultSeedPointsCount(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width < 500
        ? 700
        : size.width < 1000
            ? 1000
            : 2000;
  }

  void _handleReset() {
    setState(() {
      _mode = defaultMode;
      _minStroke = defaultMinStroke;
      _maxStroke = defaultMaxStroke;
      _showColors = defaultShowColors;
      _weightedPoints = defaultWeightedPoints;
      _pointsCount = getDefaultSeedPointsCount(context);
    });
  }

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _pointsCount = getDefaultSeedPointsCount(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraImageStipplingDemo(
            size: size,
            mode: _mode,
            minStroke: _minStroke,
            maxStroke: _maxStroke,
            wiggleFactor: 1,
            paintColors: _showColors,
            pointsCount: _pointsCount,
            weightedPoints: _weightedPoints,
          ),
          Positioned(
            right: -2,
            top: 0,
            bottom: 0,
            child: Center(
              child: CameraImageStipplingControls(
                onReset: _handleReset,
                selectedStippleMode: _mode,
                colored: _showColors,
                weightedPoints: _weightedPoints,
                selectedPointsCount: _pointsCount,
                onPointsCountChanged: (value) {
                  setState(() {
                    _pointsCount = value;
                  });
                },
                onWeightedPointsChanged: (value) {
                  setState(() {
                    _weightedPoints = value;
                  });
                },
                onColoredChanged: (value) {
                  setState(() {
                    _showColors = value;
                  });
                },
                onStippleModeChanged: (mode) {
                  setState(() {
                    _mode = mode;
                  });
                },
                selectedMinStroke: _minStroke,
                onMinStrokeChanged: (value) {
                  setState(() {
                    _minStroke = value;
                  });
                },
                selectedMaxStroke: _maxStroke,
                onMaxStrokeChanged: (value) {
                  setState(() {
                    _maxStroke = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
