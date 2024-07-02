import 'package:flutter/material.dart';

class TextStyles {
  static const defaultFontFamily = 'Poppins';
  static const codeFontFamily = 'JetBrainsMono';

  static const footer = TextStyle(
      fontFamily: defaultFontFamily, fontSize: 16, fontWeight: FontWeight.w300);

  static const label = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: Color(0x88ffffff),
  );

  static const windowTitle = TextStyle(
    fontFamily: defaultFontFamily,
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  static const title = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 75,
    fontWeight: FontWeight.w600,
  );

  static const subtitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 60,
    fontWeight: FontWeight.w500,
  );

  static const titleXL = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 100,
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
}
