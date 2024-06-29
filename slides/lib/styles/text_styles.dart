import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextStyles {
  static const defaultFontFamily = 'Poppins';
  static const codeFontFamily = 'JetBrainsMono';

  static const footer = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 16,
  );

  static const windowTitle = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  static const title = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 50,
    fontWeight: FontWeight.w500,
  );

  static const h1 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 32,
    fontWeight: FontWeight.w500,
  );

  static const h2 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 30,
    fontWeight: FontWeight.w400,
  );

  static const subtitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 22,
  );
}
