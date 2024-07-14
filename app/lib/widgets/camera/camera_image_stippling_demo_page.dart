import 'package:app/enums.dart';
import 'package:app/widgets/camera/camera_image_stippling_controls.dart';
import 'package:app/widgets/camera/camera_image_stippling_demo.dart';
import 'package:flutter/material.dart';

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

  StippleMode _mode = defaultMode;
  double _minStroke = defaultMinStroke;
  double _maxStroke = defaultMaxStroke;
  bool _showColors = defaultShowColors;

  void _handleReset() {
    setState(() {
      _mode = defaultMode;
      _minStroke = defaultMinStroke;
      _maxStroke = defaultMaxStroke;
      _showColors = defaultShowColors;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pointsCount = size.width < 500
        ? 700
        : size.width < 1000
            ? 1000
            : 2000;
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
            pointsCount: pointsCount,
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
