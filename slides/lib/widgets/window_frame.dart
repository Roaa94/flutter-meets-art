import 'package:flutter/material.dart';
import 'package:slides/styles/text_styles.dart';

const barHeight = 30.0;

class WindowFrame extends StatelessWidget {
  const WindowFrame({
    super.key,
    this.child,
    this.margin,
    this.label,
    this.size,
  });

  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final String? label;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: size?.width,
      height: size != null ? (size!.height + barHeight + 3) : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
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
                      label ?? 'Demo',
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
          if (child != null) _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    Widget content = ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(8),
      ),
      child: ColoredBox(
        color: Colors.black,
        child: child!,
      ),
    );
    if (size != null) {
      content = SizedBox(
        width: size?.width,
        height: size?.height,
        child: content,
      );
    } else {
      content = Expanded(
        child: content,
      );
    }
    return content;
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
