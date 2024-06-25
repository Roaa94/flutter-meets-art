import 'package:flutter/material.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

class CodeHighlight extends StatelessWidget {
  const CodeHighlight(
    this.highlighter, {
    super.key,
    required this.code,
    this.fontSize = 20,
  });

  final Highlighter highlighter;
  final String code;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 30,
        right: 40,
      ),
      color: Colors.black,
      child: Text.rich(
        highlighter.highlight(code),
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'JetBrainsMono',
          height: 1.5,
        ),
      ),
    );
  }
}
