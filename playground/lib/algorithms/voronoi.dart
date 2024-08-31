import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:playground/algorithms/delaunay.dart';

/// An implementation of the Voronoi diagram that works by extending the
/// Delaunay class
/// The algorithm is very buggy and can be optimized in many ways
/// Resources:
/// - Original JavaScript Delaunter library:
///   https://github.com/mapbox/delaunator?tab=readme-ov-file
/// - D3's Voronoi implementation:
///   https://github.com/d3/d3-delaunay/blob/main/src/voronoi.js
/// - The Guide this implementation is based on:
///   https://mapbox.github.io/delaunator/
class Voronoi {
  Voronoi({
    required this.delaunay,
    required this.min,
    required this.max,
  }) : assert(max.x > min.x && max.y > min.y, 'Invalid Bounds') {
    initialize();
  }

  final Delaunay delaunay;
  final Point min;
  final Point max;

  late Float32List _circumcenters;
  late Delaunay _reflectedDelaunay;

  late Float32List _edges;
  late List<List<Offset>> _cells;

  late Size _size;

  Float32List get circumcenters => _circumcenters;

  Delaunay get reflectedDelaunay => _reflectedDelaunay;

  Float32List get edges => _edges;

  List<List<Offset>> get cells => _cells;

  update() {
    delaunay.update();
    initialize();
  }

  initialize() {
    _computeSize();
    _computeCircumcenters();
    _computeEdges();
    _computeReflectedDelaunay();
    _computeCellPolygons();
  }

  void _computeSize() {
    final width = (max.x - min.x).abs().toDouble();
    final height = (max.y - min.y).abs().toDouble();
    _size = Size(width, height);
  }

  void _computeCircumcenters() {
    final triangles = delaunay.triangles;
    final coords = delaunay.coords;
    final n = triangles.length ~/ 3;
    _circumcenters = Float32List(n * 2);

    for (var t = 0; t < n; t++) {
      final i = t * 3;
      final j = t * 2;
      final ax = coords[triangles[i] * 2];
      final ay = coords[triangles[i] * 2 + 1];
      final bx = coords[triangles[i + 1] * 2];
      final by = coords[triangles[i + 1] * 2 + 1];
      final cx = coords[triangles[i + 2] * 2];
      final cy = coords[triangles[i + 2] * 2 + 1];

      final center = delaunay.circumcenter(ax, ay, bx, by, cx, cy);
      _circumcenters[j] = center.x;
      _circumcenters[j + 1] = center.y;
    }
  }

  void _computeEdges() {
    final halfEdges = delaunay.halfEdges;
    final triangles = delaunay.triangles;
    final list = <double>[];

    for (var e = 0; e < triangles.length; e++) {
      if (e < halfEdges[e]) {
        final j = e ~/ 3 * 2;
        final k = halfEdges[e] ~/ 3 * 2;
        list.addAll([
          _circumcenters[j],
          _circumcenters[j + 1],
          _circumcenters[k],
          _circumcenters[k + 1],
        ]);
      }
    }
    _edges = Float32List.fromList(list);
  }

  void _computeReflectedDelaunay() {
    final coords = delaunay.coords;

    final reflectedPoints = reflectRawPoints(
      originalPoints: coords,
      bounds: _size,
    );

    _reflectedDelaunay = Delaunay(reflectedPoints);
    _reflectedDelaunay.update();
  }

  void _computeCellPolygons() {
    // Todo: optimize
    // Todo: fix bug of points on bounds not getting polygon cells
    _cells = <List<Offset>>[];
    final index = {}; // point id to half-edge id
    final cellPolygons = <Offset>[];
    for (var e = 0; e < _reflectedDelaunay.triangles.length; e++) {
      final endpoint = _reflectedDelaunay.triangles[nextHalfEdge(e)];
      if (!index.containsKey(endpoint) ||
          _reflectedDelaunay.halfEdges[e] == -1) {
        index[endpoint] = e;
      }
    }
    for (var p = 0; p < delaunay.coords.length; p++) {
      final incoming = index[p];
      if (incoming != null) {
        final edges = edgesAroundPoint(_reflectedDelaunay, incoming);
        final triangles = edges.map(triangleOfEdge);
        final vertices =
            triangles.map((t) => triangleCenter(_reflectedDelaunay, t));
        final allOffsets = vertices
            .map((v) => Offset(v.x < 1e-9 ? 0 : v.x, v.y < 1e-9 ? 0 : v.y))
            .toList();
        final uniqueOffsets = <Offset>[];
        for (final offset in allOffsets) {
          if(!uniqueOffsets.contains(offset)) {
            uniqueOffsets.add(offset);
          }
        }
        final insideBounds = uniqueOffsets.every((offset) {
          final approxOffset = Offset(
            offset.dx.abs() < 1e-9 ? 0 : offset.dx,
            offset.dy.abs() < 1e-9 ? 0 : offset.dy,
          );
          final value = (_size + const Offset(0.1, 0.1)).contains(approxOffset);
          return value;
        });
        if (insideBounds) _cells.add(uniqueOffsets);
      }
    }
    if (cellPolygons.isNotEmpty) _cells.add(cellPolygons);
  }
}

List<int> edgesOfTriangle(int t) {
  return [3 * t, 3 * t + 1, 3 * t + 2];
}

List<int> pointsOfTriangle(Delaunay delaunay, int t) {
  return edgesOfTriangle(t).map((e) => delaunay.triangles[e]).toList();
}

triangleOfEdge(int e) {
  return (e / 3).floor();
}

Point<double> triangleCenter(Delaunay delaunay, int t) {
  final vertices =
      pointsOfTriangle(delaunay, t).map((p) => delaunay.getPoint(p)).toList();
  return delaunay.circumcenter(
    vertices[0].x,
    vertices[0].y,
    vertices[1].x,
    vertices[1].y,
    vertices[2].x,
    vertices[2].y,
  );
}

List<int> edgesAroundPoint(Delaunay delaunay, int start) {
  final result = <int>[];
  var incoming = start;
  do {
    result.add(incoming);
    final outgoing = nextHalfEdge(incoming);
    incoming = delaunay.halfEdges[outgoing];
  } while (incoming != -1 && incoming != start);
  return result;
}

nextHalfEdge(e) {
  return (e % 3 == 2) ? e - 2 : e + 1;
}

prevHalfEdge(e) {
  return (e % 3 == 0) ? e + 2 : e - 1;
}

Float32List reflectRawPoints({
  required Float32List originalPoints,
  required Size bounds,
}) {
  final int length = originalPoints.length;
  final Float32List reflectedPoints = Float32List(length * 5);

  for (int i = 0; i < length; i += 2) {
    final double x = originalPoints[i];
    final double y = originalPoints[i + 1];

    // Original point
    reflectedPoints[i] = x;
    reflectedPoints[i + 1] = y;

    // Top reflection
    reflectedPoints[length + i] = x;
    reflectedPoints[length + i + 1] = -y;

    // Bottom reflection
    reflectedPoints[2 * length + i] = x;
    reflectedPoints[2 * length + i + 1] = 2 * bounds.height - y;

    // Left reflection
    reflectedPoints[3 * length + i] = -x;
    reflectedPoints[3 * length + i + 1] = y;

    // Right reflection
    reflectedPoints[4 * length + i] = 2 * bounds.width - x;
    reflectedPoints[4 * length + i + 1] = y;
  }

  return reflectedPoints;
}
