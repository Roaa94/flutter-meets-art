import 'package:app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slides/styles/app_colors.dart';
import 'package:slides/templates/build_template_slide.dart';
import 'package:slides/widgets/window_frame.dart';

class ImagePixelsPainterSlide extends FlutterDeckSlideWidget {
  const ImagePixelsPainterSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/painting-image-pixels-demo',
            title: 'Painting Image Pixels',
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return buildTemplateSlide(
      context,
      title: 'Painting Image Pixels',
      showHeader: true,
      content: WindowFrame(
        margin: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 40),
        label: 'Bitmap',
        child: Stack(
          children: [
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.white,
                child: ImagePixelsDemo(
                  imagePath: 'assets/images/dash-200x200.jpg',
                  zoom: 1,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ControlsButton(
                    icon: Icons.remove,
                    onTap: () {},
                  ),
                  const SizedBox(width: 5),
                  const ControlsButton(
                    color: AppColors.primary,
                    icon: Icons.search,
                  ),
                  const SizedBox(width: 5),
                  ControlsButton(
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ControlsButton extends StatelessWidget {
  const ControlsButton({
    super.key,
    this.size = 75,
    this.color = Colors.black,
    this.icon = Icons.add,
    this.onTap,
  });

  final double size;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: color.withOpacity(0.3),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 35,
        ),
      ),
    );
  }
}
