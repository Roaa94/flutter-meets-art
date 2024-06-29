import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides/main.dart';

class CodeHighlight extends ConsumerWidget {
  const CodeHighlight(
    this.code, {
    super.key,
    this.fontSize = 27,
  });

  final String code;
  final double fontSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text.rich(
        ref.watch(highlighterProvider).highlight(code),
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'JetBrainsMono',
          height: 1.9,
        ),
      ),
    );
  }
}
