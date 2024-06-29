import 'dart:math';
import 'dart:typed_data';

import 'package:app/delaunay/delaunay.dart';
import 'package:app/delaunay/voronoi.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';

class AnimatedSpiralVoronoi extends StatefulWidget {
  const AnimatedSpiralVoronoi({
    super.key,
    required this.size,
    this.animateAngle = true,
    this.animateRadius = false,
  });

  final Size size;
  final bool animateAngle;
  final bool animateRadius;

  @override
  State<AnimatedSpiralVoronoi> createState() => _AnimatedSpiralVoronoiState();
}

class _AnimatedSpiralVoronoiState extends State<AnimatedSpiralVoronoi>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _angleAnimation;
  late final Animation<double> _radiusAnimation;
  final pointsCount = 1400;
  final radiusIncrement = 1.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animateRadius
          ? const Duration(seconds: 1)
          : const Duration(minutes: 2),
    );
    _animationController.repeat(reverse: true);
    _angleAnimation =
        Tween<double>(begin: 10, end: 10.1).animate(_animationController);
    _radiusAnimation =
        Tween<double>(begin: 1, end: 1.2).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return CustomPaint(
            painter: AnimatedSpiralVoronoiPainter(
              seedPoints: generateSpiralPoints(
                pointsCount: pointsCount,
                angleIncrement:
                    widget.animateAngle ? -_angleAnimation.value : 18,
                radiusIncrement:
                    widget.animateRadius ? _radiusAnimation.value : 1,
                center: Offset(widget.size.width / 2, widget.size.height / 2),
                bounds: widget.size,
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedSpiralVoronoiPainter extends CustomPainter {
  AnimatedSpiralVoronoiPainter({
    required this.seedPoints,
  });

  final Float32List seedPoints;

  @override
  void paint(Canvas canvas, Size size) {
    final delaunay = Delaunay(seedPoints);
    delaunay.update();

    final colors = generateIncrementalHSLColors(
      seedPoints.length,
      initialHue: 350,
      saturation: 0.6,
    );

    final Voronoi voronoi = delaunay.voronoi(
      const Point(0, 0),
      Point(size.width, size.height),
    );

    final cells = voronoi.cells;
    for (int j = 0; j < cells.length; j++) {
      final path = Path()..moveTo(cells[j][0].dx, cells[j][0].dy);
      for (int i = 1; i < cells[j].length; i++) {
        path.lineTo(cells[j][i].dx, cells[j][i].dy);
      }
      path.close();

      canvas.drawPath(
        path,
        Paint()..color = colors[j],
      );

      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = colors[j],
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
