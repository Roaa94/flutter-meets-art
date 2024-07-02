import 'package:flutter/material.dart';
import 'package:slides/styles/app_colors.dart';

class Controls extends StatelessWidget {
  const Controls({
    super.key,
    this.onMinus,
    this.onPlus,
    this.icon,
    this.label,
    this.size = 75,
  });

  final VoidCallback? onMinus;
  final VoidCallback? onPlus;
  final IconData? icon;
  final double size;
  final Widget? label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ControlsButton(
          icon: Icons.remove,
          onTap: onMinus,
          size: size,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
          ),
        ),
        Container(
          height: size,
          width: size,
          decoration: const BoxDecoration(
            color: AppColors.primary,
          ),
          child: label ?? Icon(icon, size: 35),
        ),
        ControlsButton(
          size: size,
          onTap: onPlus,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
          ),
        ),
      ],
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
    this.borderRadius,
  });

  final double size;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius ?? BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: color.withOpacity(0.3),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 40,
        ),
      ),
    );
  }
}
