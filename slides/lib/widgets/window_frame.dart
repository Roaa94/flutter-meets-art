import 'package:flutter/material.dart';
import 'package:slides/styles/text_styles.dart';

const barHeight = 30.0;

class WindowFrame extends StatelessWidget {
  const WindowFrame({
    super.key,
    this.child,
    this.margin,
    this.label = 'Demo',
  });

  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            height: barHeight,
            margin: const EdgeInsets.all(0.1),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              color: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.0),
                    child: Row(
                      children: [
                        WindowButton(Color(0xfff45d55)),
                        WindowButton(Color(0xfff3b52e)),
                        WindowButton(Color(0xff29c040)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyles.windowTitle,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
          if (child != null)
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                child: ColoredBox(
                  color: Colors.black,
                  child: child!,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class WindowButton extends StatelessWidget {
  const WindowButton(this.color, {super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: barHeight * 0.55,
      height: barHeight * 0.55,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
    );
  }
}
