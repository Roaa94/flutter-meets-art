import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app/delaunay/delaunay.dart';
import 'package:app/delaunay/voronoi.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class WeightedVoronoiStippling extends StatefulWidget {
  const WeightedVoronoiStippling({
    super.key,
    this.pointsCount = 100,
    this.showImage = true,
    this.paintPoints = true,
    this.paintColors = true,
    this.showVoronoiPolygons = true,
    this.animate = false,
    this.weightedCentroids = false,
    this.pointStrokeWidth = 5,
  });

  final int pointsCount;
  final bool showImage;
  final bool paintPoints;
  final bool paintColors;
  final bool showVoronoiPolygons;
  final bool animate;
  final bool weightedCentroids;
  final double pointStrokeWidth;

  @override
  State<WeightedVoronoiStippling> createState() =>
      _WeightedVoronoiStipplingState();
}

class _WeightedVoronoiStipplingState extends State<WeightedVoronoiStippling>
    with SingleTickerProviderStateMixin {
  bool _isLoadingImage = false;
  late ByteData? _imageBytes;
  Size _imageSize = const Size(0, 0);
  final random = Random(1);
  late final Ticker _ticker;

  static const imagePath = 'assets/images/dash.jpg';

  late Float32List points;
  late Float32List centroids;
  late Delaunay delaunay;
  late Voronoi voronoi;

  void _calculate() {
    delaunay = Delaunay(points);
    delaunay.update();
    voronoi = delaunay.voronoi(
      const Point(0, 0),
      Point(_imageSize.width, _imageSize.height),
    );
    if (widget.weightedCentroids) {
      centroids = calcWeightedCentroids(delaunay, _imageSize, _imageBytes!);
    } else {
      centroids = calcCentroids(voronoi.cells);
    }
  }

  void _init() {
    points = generateRandomPointsFromPixels(
      _imageBytes!,
      _imageSize,
      widget.pointsCount,
      random,
    );
    _calculate();
  }

  void _update() {
    points = lerpPoints(points, centroids, 0.08);
    _calculate();
    setState(() {});
  }

  Future<void> _loadImagePixels(String imageAssetPath) async {
    setState(() {
      _isLoadingImage = true;
    });
    final img = await rootBundle.load(imageAssetPath);
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
    _loadImagePixels(imagePath).then((_) {
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
                child: Image.asset(
                  imagePath,
                  package: 'app',
                ),
              ),
            Positioned.fill(
              child: CustomPaint(
                painter: StipplingCustomPainter(
                  points: points,
                  centroids: centroids,
                  voronoi: voronoi,
                  delaunay: delaunay,
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
    required this.points,
    required this.centroids,
    required this.voronoi,
    required this.delaunay,
    required this.bytes,
    this.paintColors = true,
    this.showVoronoiPolygons = true,
    this.paintPoints = true,
    this.pointStrokeWidth = 2,
  });

  final Float32List points;
  final Float32List centroids;
  final Delaunay delaunay;
  final Voronoi voronoi;
  final ByteData bytes;
  final bool paintColors;
  final bool paintPoints;
  final bool showVoronoiPolygons;
  final double pointStrokeWidth;

  final random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final cells = voronoi.cells;

    // Todo: optimize by moving somewhere where the color is already calculated
    final colors = List<Color>.filled(centroids.length ~/ 2, Colors.white);
    if (paintColors) {
      for (int i = 0; i < centroids.length; i += 2) {
        final color = getPixelColorFromBytes(
          bytes: bytes,
          offset: Offset(centroids[i], centroids[i + 1]),
          size: size,
        );
        colors[i ~/ 2] = color;
      }
    }

    if (showVoronoiPolygons) {
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
        for (int i = 0; i < delaunay.coords.length; i += 2) {
          canvas.drawCircle(
            Offset(delaunay.coords[i], delaunay.coords[i + 1]),
            pointStrokeWidth / 2,
            Paint()..color = colors[i ~/ 2],
          );
        }
      } else {
        canvas.drawRawPoints(
          PointMode.points,
          delaunay.coords,
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