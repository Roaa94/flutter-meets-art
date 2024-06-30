import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:app/algorithms/delaunay.dart';
import 'package:app/algorithms/voronoi.dart';
import 'package:app/utils.dart';
import 'package:flutter/material.dart';

class VoronoiRelaxation {
  VoronoiRelaxation(
    this.inputCoords, {
    required this.min,
    required this.max,
    this.bytes,
    this.weighted = false,
  })  : _coords = inputCoords,
        _centroids = Float32List(inputCoords.length),
        _colors =
            List<Color>.filled(inputCoords.length ~/ 2, Colors.transparent) {
    _init();
  }

  final Float32List inputCoords;
  final Point min;
  final Point max;
  final ByteData? bytes;
  final bool weighted;

  final Float32List _coords;
  final Float32List _centroids;
  List<Color> _colors;

  late Delaunay _delaunay;
  late Voronoi _voronoi;

  Size get size => Size(
        (max.x - min.x).abs().toDouble(),
        (max.y - min.y).abs().toDouble(),
      );

  Delaunay get delaunay => _delaunay;

  Voronoi get voronoi => _voronoi;

  Float32List get coords => _coords;

  Float32List get centroids => _centroids;

  // Todo: change to Uint32List
  List<Color> get colors => _colors;

  void _init() {
    _delaunay = Delaunay(_coords);
    _delaunay.update();
    _voronoi = delaunay.voronoi(min, max);
    if (weighted && bytes != null) {
      _calcWeightedCentroids();
    } else {
      _calcCentroids();
    }
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

  void _calcWeightedCentroids() {
    if (bytes == null) {
      return;
    }
    final weightedCentroids = Float32List(delaunay.coords.length);
    final weights = Float32List(_coords.length ~/ 2);
    final colors = List<Color>.filled(_coords.length ~/ 2, Colors.transparent);

    int delaunayIndex = 0;
    for (int p = 0; p < bytes!.lengthInBytes ~/ 4; p++) {
      int x = p % size.width.toInt();
      int y = p ~/ size.width;

      final byteOffset = ((y * size.width.toInt()) + x) * 4;
      final rgbaColor = bytes!.getUint32(byteOffset);
      final color = Color(rgbaToArgb(rgbaColor));

      final brightness =
          0.2126 * color.red + 0.7152 * color.green + 0.0722 * color.blue;
      final w = 1 - brightness / 255;

      delaunayIndex = delaunay.find(
        x.toDouble(),
        y.toDouble(),
        delaunayIndex,
      );

      weightedCentroids[2 * delaunayIndex] += (x * w);
      weightedCentroids[2 * delaunayIndex + 1] += (y * w);
      weights[delaunayIndex] += w;

      // Update color blending
      if (weights[delaunayIndex] == w) {
        colors[delaunayIndex] = color;
      } else {
        final currentColor = colors[delaunayIndex];
        final totalWeight = weights[delaunayIndex];
        final r = (currentColor.red * (totalWeight - w) + color.red * w) ~/
            totalWeight;
        final g = (currentColor.green * (totalWeight - w) + color.green * w) ~/
            totalWeight;
        final b = (currentColor.blue * (totalWeight - w) + color.blue * w) ~/
            totalWeight;

        colors[delaunayIndex] = Color.fromARGB(255, r, g, b);
      }
    }

    for (int i = 0; i < weightedCentroids.length; i += 2) {
      if (weights[i ~/ 2] > 0) {
        weightedCentroids[i] /= weights[i ~/ 2];
        weightedCentroids[i + 1] /= weights[i ~/ 2];
        _centroids[i] = weightedCentroids[i];
        _centroids[i + 1] = weightedCentroids[i + 1];
      } else {
        _centroids[i] = _coords[i];
        _centroids[i + 1] = _coords[i + 1];
      }
    }

    // Assign colors to the class variable _colors
    _colors = colors;
  }
}
