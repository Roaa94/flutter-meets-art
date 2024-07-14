import 'package:app/app.dart';
import 'package:flutter/material.dart';

const primaryColor = Colors.pinkAccent;

const titleTextStyle = TextStyle(
  fontWeight: FontWeight.w700,
  color: Colors.white,
  fontSize: 16,
  fontFamily: 'Poppins',
);

const labelTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontFamily: 'Poppins',
);

class CameraImageStipplingControls extends StatefulWidget {
  const CameraImageStipplingControls({
    super.key,
    this.selectedStippleMode = StippleMode.circles,
    this.onStippleModeChanged,
    this.selectedMinStroke = 7,
    this.onMinStrokeChanged,
    this.selectedMaxStroke = 30,
    this.onMaxStrokeChanged,
    this.onReset,
    this.colored = true,
    this.onColoredChanged,
    this.selectedPointsCount = 1000,
    this.onPointsCountChanged,
  });

  final StippleMode selectedStippleMode;
  final ValueChanged<StippleMode>? onStippleModeChanged;
  final double selectedMinStroke;
  final ValueChanged<double>? onMinStrokeChanged;
  final double selectedMaxStroke;
  final ValueChanged<double>? onMaxStrokeChanged;
  final VoidCallback? onReset;
  final bool colored;
  final ValueChanged<bool>? onColoredChanged;
  final int selectedPointsCount;
  final ValueChanged<int>? onPointsCountChanged;

  @override
  State<CameraImageStipplingControls> createState() =>
      _CameraImageStipplingControlsState();
}

class _CameraImageStipplingControlsState
    extends State<CameraImageStipplingControls> {
  bool _collapsed = true;

  static const panelWidth = 200.0;
  static const buttonWidth = 40.0;

  @override
  Widget build(BuildContext context) {
    final polygonModeSelected =
        widget.selectedStippleMode == StippleMode.polygons ||
            widget.selectedStippleMode == StippleMode.polygonsOutlined;
    return Transform.translate(
      offset: Offset(_collapsed ? panelWidth : 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.translate(
            offset: const Offset(1, 0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _collapsed = !_collapsed;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                width: buttonWidth,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                child: const Icon(
                  Icons.settings,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            width: panelWidth,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stippling Controls',
                  style: titleTextStyle,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Mode',
                  style: labelTextStyle,
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(
                    StippleMode.values.length,
                    (i) => Expanded(
                      child: GestureDetector(
                        onTap: () => widget.onStippleModeChanged
                            ?.call(StippleMode.values[i]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: StippleMode.values[i] ==
                                    widget.selectedStippleMode
                                ? primaryColor
                                : Colors.white.withOpacity(0.2),
                            border: Border.all(color: Colors.white, width: 0.5),
                            borderRadius: i == 0
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  )
                                : i == StippleMode.values.length - 1
                                    ? const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      )
                                    : null,
                          ),
                          child: Icon(
                            StippleMode.values[i].icon,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Paint Colors', style: labelTextStyle),
                    Checkbox(
                      value: widget.colored,
                      activeColor: primaryColor,
                      onChanged: (value) {
                        if (value != null) {
                          widget.onColoredChanged?.call(value);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Seed point count', style: labelTextStyle),
                const SizedBox(height: 10),
                Controls(
                  value: widget.selectedPointsCount,
                  onMinus: () {
                    if (widget.selectedPointsCount > 500) {
                      widget.onPointsCountChanged
                          ?.call(widget.selectedPointsCount - 500);
                    }
                  },
                  onPlus: () {
                    if (widget.selectedPointsCount < 10000) {
                      widget.onPointsCountChanged
                          ?.call(widget.selectedPointsCount + 500);
                    }
                  },
                ),
                const SizedBox(height: 20),
                Opacity(
                  opacity: polygonModeSelected ? 0.3 : 1,
                  child: IgnorePointer(
                    ignoring: polygonModeSelected,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Min Circle Size', style: labelTextStyle),
                        const SizedBox(height: 10),
                        Controls(
                          value: widget.selectedMinStroke,
                          onMinus: () {
                            if (widget.selectedMinStroke > 1) {
                              widget.onMinStrokeChanged
                                  ?.call(widget.selectedMinStroke - 1);
                            }
                          },
                          onPlus: () {
                            if (widget.selectedMinStroke < 100) {
                              widget.onMinStrokeChanged
                                  ?.call(widget.selectedMinStroke + 1);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text('Max Circle Size', style: labelTextStyle),
                        const SizedBox(height: 10),
                        Controls(
                          value: widget.selectedMaxStroke,
                          onMinus: () {
                            if (widget.selectedMaxStroke > 1) {
                              widget.onMaxStrokeChanged
                                  ?.call(widget.selectedMaxStroke - 1);
                            }
                          },
                          onPlus: () {
                            if (widget.selectedMaxStroke < 100) {
                              widget.onMaxStrokeChanged
                                  ?.call(widget.selectedMaxStroke + 1);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: widget.onReset,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      'Reset',
                      style: labelTextStyle.copyWith(
                          color: primaryColor.withOpacity(0.8),
                          decoration: TextDecoration.underline,
                          decorationColor: primaryColor.withOpacity(0.8),
                          decorationThickness: 2),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({
    super.key,
    this.value = 0,
    this.onPlus,
    this.onMinus,
  });

  final num value;
  final VoidCallback? onPlus;
  final VoidCallback? onMinus;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: onMinus,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                border: Border.all(color: Colors.white, width: 0.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: const Icon(
                Icons.remove,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
              border: Border.all(color: Colors.white, width: 0.5),
            ),
            width: 70,
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                '${value.toInt()}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onPlus,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                border: Border.all(color: Colors.white, width: 0.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
