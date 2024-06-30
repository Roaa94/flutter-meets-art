import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app/algorithms/delaunay.dart';
import 'package:app/algorithms/voronoi.dart';

class VoronoiRelaxation {
  VoronoiRelaxation(
    this.inputCoords, {
    required this.min,
    required this.max,
  })  : _coords = inputCoords,
        _centroids = Float32List(inputCoords.length) {
    _init();
  }

  final Float32List inputCoords;
  final Point min;
  final Point max;

  final Float32List _coords;
  final Float32List _centroids;

  late Delaunay _delaunay;
  late Voronoi _voronoi;

  Delaunay get delaunay => _delaunay;

  Voronoi get voronoi => _voronoi;

  Float32List get coords => _coords;

  Float32List get centroids => _centroids;

  void _init() {
    _delaunay = Delaunay(_coords);
    _delaunay.update();
    _voronoi = delaunay.voronoi(min, max);
    _calcCentroids();
  }

  void update(double lerp) {
    _lerpCoords(lerp);
    _init();
  }

  void _calcCentroids() {
    for (int i = 0; i < _voronoi.cells.length; i++) {
      final cell = _voronoi.cells[i];
      Offset centroid = Offset.zero;
      double area = 0.0;

      for (int j = 0; j < cell.length; j++) {
        final v0 = cell[j];
        final v1 = cell[(j + 1) % cell.length];
        final crossValue = v0.dx * v1.dy - v1.dx * v0.dy;
        area += crossValue;
        centroid += Offset(
          (v0.dx + v1.dx) * crossValue,
          (v0.dy + v1.dy) * crossValue,
        );
      }

      area /= 2;
      centroid = Offset(
        centroid.dx / (6 * area),
        centroid.dy / (6 * area),
      );

      if (centroid.dx.isInfinite ||
          centroid.dx.isNaN ||
          centroid.dy.isInfinite ||
          centroid.dy.isNaN) {
        centroid = Offset.zero;
      }

      _centroids[i * 2] = centroid.dx;
      _centroids[i * 2 + 1] = centroid.dy;
    }
  }

  void _lerpCoords(double lerp) {
    for (int i = 0; i < _coords.length; i++) {
      final lerped = lerpDouble(
        _coords[i],
        _centroids[i],
        lerp,
      );
      _coords[i] = lerped ?? _coords[i];
    }
  }
}
