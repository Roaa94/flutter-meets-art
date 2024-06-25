import 'package:flutter/material.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class CodeHighlight extends StatelessWidget {
  const CodeHighlight(
    this.highlighter, {
    super.key,
    required this.code,
    this.fontSize = 27,
  });

  final Highlighter highlighter;
  final String code;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      color: Colors.black,
      child: Text.rich(
        highlighter.highlight(code),
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'JetBrainsMono',
          height: 1.9,
        ),
      ),
    );
  }
}
