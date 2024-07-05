import 'package:app/app.dart';
import 'package:app/playgrounds/splash_demo_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashDemoPage(),
    );
  }
}
