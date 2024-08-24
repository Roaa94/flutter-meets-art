import 'package:playground/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_friends_24_slides/widgets/controls.dart';
import 'package:flutter_friends_24_slides/widgets/window_frame.dart';

class BitmapDemo extends StatefulWidget {
  const BitmapDemo({super.key});

  @override
  State<BitmapDemo> createState() => _BitmapDemoState();
}

class _BitmapDemoState extends State<BitmapDemo> {
  double zoom = 3.0;
  double increment = 1.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
      child: Stack(
        children: [
          Positioned.fill(
            child: WindowFrame(
              label: '100x100 Bitmap',
              child: ColoredBox(
                color: Colors.white,
                child: ImagePixelsDemo(
                  imagePath: 'assets/images/dash-100x100.jpg',
                  zoom: zoom,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 0,
            left: 0,
            child: Center(
              child: Controls(
                size: 65,
                onPlus: () => setState(() => zoom += increment),
                onMinus: () => setState(() => zoom -= increment),
                icon: Icons.search,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
