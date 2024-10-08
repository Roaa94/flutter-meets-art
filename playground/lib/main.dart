import 'package:flutter/material.dart';
import 'package:playground/widgets/camera/camera_image_stippling_demo_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: CameraImageStipplingDemoPage(),
    );
  }
}
