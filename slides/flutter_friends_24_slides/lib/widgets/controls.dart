import 'package:flutter/material.dart';
import 'package:flutter_friends_24_slides/styles/app_colors.dart';

class Controls extends StatelessWidget {
  const Controls({
    super.key,
    this.onMinus,
    this.onPlus,
    this.icon,
    this.label,
    this.size = 75,
    this.iconSize = 40,
    this.centerColor = AppColors.primary,
    this.borderRadius = 20,
  });

  final VoidCallback? onMinus;
  final VoidCallback? onPlus;
  final IconData? icon;
  final double size;
  final double iconSize;
  final Widget? label;
  final Color centerColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ControlsButton(
          icon: Icons.remove,
          iconSize: iconSize,
          onTap: onMinus,
          size: size,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
          ),
        ),
        Container(
          height: size,
          width: size,
          color: centerColor,
          child: label != null
              ? Center(child: label)
              : Icon(
                  icon,
                  size: iconSize,
                ),
        ),
        ControlsButton(
          size: size,
          onTap: onPlus,
          iconSize: iconSize,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(borderRadius),
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
    this.label,
    this.onTap,
    this.borderRadius,
    this.iconSize = 40,
  });

  final double size;
  final Color color;
  final IconData? icon;
  final Widget? label;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final double iconSize;

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
        child: label != null
            ? Center(child: label)
            : Icon(
                icon,
                size: iconSize,
              ),
      ),
    );
  }
}
