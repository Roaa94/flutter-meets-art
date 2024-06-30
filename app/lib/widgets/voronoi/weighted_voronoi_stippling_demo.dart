import 'dart:math';
import 'dart:ui';

import 'package:app/algorithms/voronoi_relaxation.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class WeightedVoronoiStipplingDemo extends StatefulWidget {
  const WeightedVoronoiStipplingDemo({
    super.key,
    this.pointsCount = 100,
    this.showImage = true,
    this.paintPoints = true,
    this.paintColors = true,
    this.showVoronoiPolygons = true,
    this.animate = false,
    this.weightedCentroids = false,
    this.pointStrokeWidth = 5,
    this.imagePath = 'assets/images/dash.jpg',
  });

  final int pointsCount;
  final bool showImage;
  final bool paintPoints;
  final bool paintColors;
  final bool showVoronoiPolygons;
  final bool animate;
  final bool weightedCentroids;
  final double pointStrokeWidth;
  final String imagePath;

  @override
  State<WeightedVoronoiStipplingDemo> createState() =>
      _WeightedVoronoiStipplingDemoState();
}

class _WeightedVoronoiStipplingDemoState
    extends State<WeightedVoronoiStipplingDemo>
    with SingleTickerProviderStateMixin {
  bool _isLoadingImage = false;
  late ByteData? _imageBytes;
  Size _imageSize = const Size(0, 0);
  final random = Random(1);
  late final Ticker _ticker;

  late VoronoiRelaxation _relaxation;

  void _init() {
    final points = generateRandomPointsFromPixels(
      _imageBytes!,
      _imageSize,
      widget.pointsCount,
      random,
    );
    _relaxation = VoronoiRelaxation(
      points,
      min: const Point(0, 0),
      max: Point(_imageSize.width, _imageSize.height),
      weighted: widget.weightedCentroids,
      bytes: _imageBytes,
    );
  }

  void _update() {
    _relaxation.update(0.1);
    setState(() {});
  }

  Future<void> _loadImagePixels() async {
    setState(() {
      _isLoadingImage = true;
    });
    final img = await rootBundle.load(widget.imagePath);
    var decodedImage = await decodeImageFromList(img.buffer.asUint8List());
    final imageBytes = await decodedImage.toByteData();
    int imgWidth = decodedImage.width;
    int imgHeight = decodedImage.height;

    setState(() {
      _imageBytes = imageBytes;
      _imageSize = Size(imgWidth.toDouble(), imgHeight.toDouble());
      _isLoadingImage = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) => _update());
    _loadImagePixels().then((_) {
      if (_imageSize == const Size(0, 0) || _imageBytes == null) {
        return;
      }
      _init();
      if (widget.animate) _ticker.start();
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingImage) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_imageBytes == null) {
      return const Center(
        child: Text('Failed to load image!'),
      );
    }
    return Center(
      child: SizedBox(
        width: _imageSize.width,
        height: _imageSize.height,
        child: Stack(
          children: [
            if (widget.showImage)
              Positioned.fill(
                child: Image.asset(widget.imagePath),
              ),
            Positioned.fill(
              child: CustomPaint(
                painter: StipplingCustomPainter(
                  // points: points,
                  // centroids: centroids,
                  // voronoi: voronoi,
                  relaxation: _relaxation,
                  bytes: _imageBytes!,
                  paintColors: widget.paintColors,
                  showVoronoiPolygons: widget.showVoronoiPolygons,
                  paintPoints: widget.paintPoints,
                  pointStrokeWidth: widget.pointStrokeWidth,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StipplingCustomPainter extends CustomPainter {
  StipplingCustomPainter({
    required this.relaxation,
    required this.bytes,
    this.paintColors = true,
    this.showVoronoiPolygons = true,
    this.paintPoints = true,
    this.pointStrokeWidth = 2,
  });

  final VoronoiRelaxation relaxation;
  final ByteData bytes;
  final bool paintColors;
  final bool paintPoints;
  final bool showVoronoiPolygons;
  final double pointStrokeWidth;

  final random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    // Todo: optimize by moving somewhere where the color is already calculated
    final colors = relaxation.colors;
    // final colors = List<Color>.filled(centroids.length ~/ 2, Colors.white);
    // if (paintColors) {
    //   final centroids = relaxation.centroids;
    //   for (int i = 0; i < centroids.length; i += 2) {
    //     final color = getPixelColorFromBytes(
    //       bytes: bytes,
    //       offset: Offset(centroids[i], centroids[i + 1]),
    //       size: size,
    //     );
    //     colors[i ~/ 2] = color;
    //   }
    // }

    if (showVoronoiPolygons) {
      final cells = relaxation.voronoi.cells;
      for (int j = 0; j < cells.length; j++) {
        final path = Path()..moveTo(cells[j][0].dx, cells[j][0].dy);
        for (int i = 1; i < cells[j].length; i++) {
          path.lineTo(cells[j][i].dx, cells[j][i].dy);
        }
        path.close();

        if (paintColors) {
          canvas.drawPath(
            path,
            Paint()..color = colors[j],
          );
        }
        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.black,
        );
      }
    }

    if (paintPoints) {
      if (paintColors) {
        for (int i = 0; i < relaxation.coords.length; i += 2) {
          canvas.drawCircle(
            Offset(relaxation.coords[i], relaxation.coords[i + 1]),
            pointStrokeWidth / 2,
            Paint()..color = colors[i ~/ 2],
          );
        }
      } else {
        canvas.drawRawPoints(
          PointMode.points,
          relaxation.coords,
          Paint()
            ..strokeWidth = pointStrokeWidth
            ..strokeCap = StrokeCap.round
            ..color = Colors.black,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
