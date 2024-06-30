// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';
import 'dart:typed_data';

import 'package:app/algorithms/voronoi.dart';

final double _epsilon = pow(2.0, -52) as double;
final Uint32List _edgeStack = Uint32List(512);

/// A class for quickly calculating the Delaunay triangulation in 2D of a set
/// of points in the cartesian plane.
///
/// Example usage:
/// ```
/// Float32List points = Float32List.fromList(<double>[
///   143.0, 178.5,
///   50.2, -100.7,
///   ...
/// ]);
/// Delaunay delaunay = Delaunay(points);
/// delaunay.update();
/// for (int i = 0; i < delaunay.triangles.length; i += 3) {
///   int a = delaunay.triangles[i];
///   int b = delaunay.triangles[i + 1];
///   int c = delaunay.triangles[i + 3];
///
///   double ax = delaunay.coords[2*a];
///   double ay = delaunay.coords[2*a + 1];
///   ...
/// }
/// ...
/// points[0] = 140.0;
/// delaunay.update();
/// ...
/// ```
///
/// This implementation is adapted from the Delaunator JavaScript library.
/// See https://github.com/mapbox/delaunator
class Delaunay {
  /// Allocates memory for a Delaunay triangulation, keeping a reference to
  /// [coords].
  Delaunay(Float32List coords)
      : _inputCoords = coords,

        // Provisionally set _coords to the input list. Decide later whether to
        // sort and replace.
        _coords = coords,

        // Arrays that will store the triangulation graph.
        _triangles = Uint32List(max(coords.length - 5, 0) * 3),
        _halfEdges = Int32List(max(coords.length - 5, 0) * 3),
        _inedges = Int32List(coords.length ~/ 2),
        _hullIndex = Int32List(coords.length ~/ 2),
        _trianglesLen = 0,
        _hullSize = 0,
        _hull = Uint32List(0),

        // Temporary arrays for tracking the edges of the advancing convex hull.
        _hullStart = -1,
        _hullPrev = Uint32List(coords.length >> 1),
        _hullNext = Uint32List(coords.length >> 1),
        _hullTri = Uint32List(coords.length >> 1),
        _hashSize = 1 << (sqrt(coords.length << 1).ceil().bitLength + 1),
        _hashMask = (1 << (sqrt(coords.length << 1).ceil().bitLength + 1)) - 1,
        _hullHash =
            Int32List(1 << (sqrt(coords.length << 1).ceil().bitLength + 1))
              ..fillRange(
                  0, 1 << (sqrt(coords.length << 1).ceil().bitLength + 1), -1),
        _i0 = -1,
        _i1 = -1,
        _i2 = -1,
        _cx = 0.0,
        _cy = 0.0,
        // Arrays to help sort the points.
        _ids = Uint32List(coords.length >> 1),
        _dists = Float32List(coords.length >> 1),
        _colinear = false;

  /// Allocates memory for a Delaunay triangulation.
  ///
  /// Copies [points] into a [Float32List], available from the getter [coords].
  factory Delaunay.from(List<Point<double>> points) {
    final int n = points.length;
    final Float32List coords = Float32List(n << 1);
    for (int i = 0; i < n; i++) {
      final Point<double> p = points[i];
      coords[i * 2] = p.x;
      coords[(i * 2) + 1] = p.y;
    }
    return Delaunay(coords);
  }

  /// The list of triangles in the triagulation.
  ///
  /// Each three elements are the three points of a triangle given by
  /// indices into [coords]:
  ///
  /// ```
  /// int a = triangles[i];
  /// int b = triangles[i + 1];
  /// int c = triangles[i + 2];
  ///
  /// double ax = coords[2 * a];
  /// double ay = coords[2 * a + 1];
  /// ```
  Uint32List get triangles => Uint32List.sublistView(
        _triangles,
        0,
        _trianglesLen,
      );

  /// The list of edges in the triangulation.
  Int32List get halfEdges => Int32List.sublistView(
        _halfEdges,
        0,
        _trianglesLen,
      );

  /// The coordinates being triangulated.
  ///
  /// Even indices are the x coordinates of the points, and the odd indices
  /// are the y coordinates of the points. E.g.:
  ///
  /// ```
  /// double px = coords[2*i];
  /// double py = coords[2*i + 1];
  /// ```
  Float32List get coords => _coords;

  /// The indices in [coords] of the points on the convex hull of the input
  /// data, counter-clockwise.
  Uint32List get hull => _hull;

  Int32List get inedges => _inedges;

  /// `coords[i]` in the form of a `Point<double>`.
  Point<double> getPoint(int i) => Point<double>(
        _coords[2 * i],
        _coords[2 * i + 1],
      );

  /// Whether after a call to [initialize], it has been detected that this is
  /// the degenerate case of all points being colinear.
  bool get colinear => _colinear;

  // The coordinates given to the constructor.
  final Float32List _inputCoords;

  // If needed for performance, the list of coordinates sorted in order of
  // increasing distance from the seed triangle's circumcenter.
  Float32List? _sortedCoords;

  // A reference either to _inputCoords or _coords whichever is indicated
  // by the number of points.
  Float32List _coords;

  // The triangles.
  final Uint32List _triangles;

  // The edges.
  final Int32List _halfEdges;
  final Int32List _inedges;
  final Int32List _hullIndex;
  final int _hashSize;
  final int _hashMask;
  final Int32List _hullHash;
  int _hullStart;
  int _hullSize;
  Uint32List _hull;
  final Uint32List _hullPrev;
  final Uint32List _hullNext;
  final Uint32List _hullTri;

  // Temporary arrays for sorting points.
  final Uint32List _ids;
  final Float32List _dists;

  int _i0, _i1, _i2;
  double _cx;
  double _cy;
  int _trianglesLen;

  bool _colinear;

  /// Calculates or recalculates the Delaunay triangulation.
  ///
  /// Calls [initialize] and [processAllPoints]. This can be called to
  /// perform the initial calculation, or to recalculate the triangulation
  /// if the contents of [coords] is modified.
  void update() {
    initialize();
    processAllPoints();
  }

  /// Initializes the Delaunay triangulation by finding the seed triangle and
  /// sorting the points in increasing distance from the seed triangle's
  /// circumcenter.
  void initialize() {
    final int n = _inputCoords.length >> 1;
    if (n < 3) {
      return;
    }

    // Populate an array of point indices; calculate input data bbox.
    double minX = double.maxFinite;
    double minY = double.maxFinite;
    double maxX = -double.maxFinite;
    double maxY = -double.maxFinite;
    for (int i = 0; i < n; i++) {
      final double x = _inputCoords[2 * i];
      final double y = _inputCoords[2 * i + 1];
      if (x < minX) {
        minX = x;
      }
      if (y < minY) {
        minY = y;
      }
      if (x > maxX) {
        maxX = x;
      }
      if (y > maxY) {
        maxY = y;
      }
      _ids[i] = i;
    }
    final double cx = (maxX + minX) / 2.0;
    final double cy = (maxY + minY) / 2.0;

    double minDist = double.maxFinite;
    int i0 = 0;
    int i1 = 0;
    int i2 = 0;

    // Pick a seed point close to the center.
    for (int i = 0; i < n; i++) {
      final double d = _dist(
        cx,
        cy,
        _inputCoords[2 * i],
        _inputCoords[2 * i + 1],
      );
      if (d < minDist) {
        i0 = i;
        minDist = d;
      }
    }
    final double i0x = _inputCoords[2 * i0];
    final double i0y = _inputCoords[2 * i0 + 1];

    // Find the point closest to the seed.
    minDist = double.maxFinite;
    for (int i = 0; i < n; i++) {
      if (i == i0) {
        continue;
      }
      final double d = _dist(
        i0x,
        i0y,
        _inputCoords[2 * i],
        _inputCoords[2 * i + 1],
      );
      if (d < minDist && d > 0.0) {
        i1 = i;
        minDist = d;
      }
    }
    double i1x = _inputCoords[2 * i1];
    double i1y = _inputCoords[2 * i1 + 1];

    // Find the third point which forms the smallest circumcircle with the first
    // two.
    double minRadius = double.maxFinite;
    for (int i = 0; i < n; i++) {
      if (i == i0 || i == i1) {
        continue;
      }
      final double r = _circumradius(
        i0x,
        i0y,
        i1x,
        i1y,
        _inputCoords[2 * i],
        _inputCoords[2 * i + 1],
      );
      if (r < minRadius) {
        i2 = i;
        minRadius = r;
      }
    }
    double i2x = _inputCoords[2 * i2];
    double i2y = _inputCoords[2 * i2 + 1];

    if (minRadius == double.maxFinite) {
      // Order collinear points by dx (or dy if all x are identical)
      // and return the list as a hull
      for (int i = 0; i < n; i++) {
        final double dx = _inputCoords[2 * i] - _inputCoords[0];
        _dists[i] = dx != 0.0 ? dx : _inputCoords[2 * i + 1] - _inputCoords[1];
      }
      _quicksort(_ids, _dists, 0, n - 1);
      final Uint32List hull = Uint32List(n);
      int j = 0;
      double d0 = -double.maxFinite;
      for (int i = 0; i < n; i++) {
        final int id = _ids[i];
        if (_dists[id] > d0) {
          hull[j++] = id;
          d0 = _dists[id];
        }
      }
      _hull = hull.sublist(0, j);
      _colinear = true;
      return;
    }

    // Swap the order of the seed points for counter-clockwise orientation.
    if (_orient(i0x, i0y, i1x, i1y, i2x, i2y)) {
      final int i = i1;
      final double x = i1x;
      final double y = i1y;
      i1 = i2;
      i1x = i2x;
      i1y = i2y;
      i2 = i;
      i2x = x;
      i2y = y;
    }

    // Sort the points by distance from the seed triangle circumcenter
    final Point<double> center = circumcenter(i0x, i0y, i1x, i1y, i2x, i2y);
    _cx = center.x;
    _cy = center.y;
    for (int i = 0; i < n; i++) {
      _dists[i] = _dist(_inputCoords[2 * i], _inputCoords[2 * i + 1], _cx, _cy);
    }
    _quicksort(_ids, _dists, 0, n - 1);

    if (n <= 100000) {
      _i0 = i0;
      _i1 = i1;
      _i2 = i2;
      _coords = _inputCoords;
    } else {
      // When there are more than ~100000 points, improving the locality of
      // access to the coordinate list improves performance.
      _sortedCoords ??= Float32List(_inputCoords.length);
      final Float32List localSorted = _sortedCoords!;
      for (int i = 0; i < n; i++) {
        if (_ids[i] == i0) {
          _i0 = i;
        }
        if (_ids[i] == i1) {
          _i1 = i;
        }
        if (_ids[i] == i2) {
          _i2 = i;
        }
        localSorted[2 * i] = _inputCoords[2 * _ids[i]];
        localSorted[2 * i + 1] = _inputCoords[2 * _ids[i] + 1];
        _ids[i] = i;
      }
      _coords = localSorted;
    }

    // Set up the seed triangle as the starting hull.
    _hullStart = _i0;
    _hullSize = 3;
    _hullNext[_i0] = _hullPrev[_i2] = _i1;
    _hullNext[_i1] = _hullPrev[_i0] = _i2;
    _hullNext[_i2] = _hullPrev[_i1] = _i0;

    _hullTri[_i0] = 0;
    _hullTri[_i1] = 1;
    _hullTri[_i2] = 2;

    _hullHash.fillRange(0, _hullHash.length, -1);
    _hullHash[_hashKey(i0x, i0y)] = _i0;
    _hullHash[_hashKey(i1x, i1y)] = _i1;
    _hullHash[_hashKey(i2x, i2y)] = _i2;

    _trianglesLen = 0;
    _addTriangle(_i0, _i1, _i2, -1, -1, -1);
  }

  /// Iterates over all the points in order of increasing distance from the seed
  /// triangle's circumcenter, adding them to the triangulation.
  ///
  /// After this call, the getters [triangles], [halfEdges], and [hull] will
  /// have meaningful contents.
  void processAllPoints() {
    final int n = _coords.length >> 1;
    if (n < 3 || _colinear) {
      return;
    }
    double xp = 0.0, yp = 0.0;
    for (int i = 0; i < n; i++) {
      final int idx = _ids[i];
      final double x = _coords[2 * idx];
      final double y = _coords[2 * idx + 1];

      if (i > 0 && (x - xp).abs() <= _epsilon && (y - yp).abs() <= _epsilon) {
        // Too close to the previous point. Skip it.
        continue;
      }
      xp = x;
      yp = y;

      // Skip seed triangle points.
      if (idx == _i0 || idx == _i1 || idx == _i2) {
        continue;
      }

      _hullSize = _processNextPoint(_hullSize, idx, x, y);
    }

    _hull = Uint32List(_hullSize);
    int e = _hullStart;
    for (int i = 0; i < _hullSize; i++) {
      _hull[i] = e;
      e = _hullNext[e];
    }

    // Initialize inedges array
    _inedges.fillRange(0, _inedges.length, -1);
    for (int e = 0, n = _halfEdges.length; e < n; e++) {
      final p = _triangles[e % 3 == 2 ? e - 2 : e + 1];
      if (_halfEdges[e] == -1 || _inedges[p] == -1) {
        _inedges[p] = e;
      }
    }

    // Initialize hullIndex array
    _hullIndex.fillRange(0, _hullIndex.length, -1);
    for (int i = 0, n = _hull.length; i < n; ++i) {
      final hullFoo = _hull[i];
      _hullIndex[hullFoo] = i;
    }
  }

  int _processNextPoint(int hullSize, int i, double x, double y) {
    // Find a visible edge on the convex hull using edge hash.
    int start = 0;
    final int key = _hashKey(x, y);
    for (int j = 0; j < _hashSize; j++) {
      start = _hullHash[(key + j) & _hashMask];
      if (start != -1 && start != _hullNext[start]) {
        break;
      }
    }

    start = _hullPrev[start];
    int e = start;
    int q;
    while (true) {
      q = _hullNext[e];
      final bool orient = _orient(
        x,
        y,
        _coords[2 * e],
        _coords[2 * e + 1],
        _coords[2 * q],
        _coords[2 * q + 1],
      );
      if (orient) {
        break;
      }
      e = q;
      if (e == start) {
        e = -1;
        break;
      }
    }
    if (e == -1) {
      // Likely a near-duplicate point; skip it.
      return hullSize;
    }

    // Add the first triangle from the point.
    int t = _addTriangle(e, i, _hullNext[e], -1, -1, _hullTri[e]);

    // Recursively flip triangles from the point until they satisfy the
    // Delaunay condition.
    _hullTri[i] = _legalize(t + 2);
    _hullTri[e] = t; // Keep track of boundary triangles on the hull.
    hullSize++;

    // Walk forward through the hull, adding more triangles and flipping
    // recursively.
    int n = _hullNext[e];
    while (true) {
      q = _hullNext[n];
      final bool orient = _orient(
        x,
        y,
        _coords[2 * n],
        _coords[2 * n + 1],
        _coords[2 * q],
        _coords[2 * q + 1],
      );
      if (!orient) {
        break;
      }
      t = _addTriangle(n, i, q, _hullTri[i], -1, _hullTri[n]);
      _hullTri[i] = _legalize(t + 2);
      _hullNext[n] = n; // Mark as removed.
      hullSize--;
      n = q;
    }

    // Walk backward from the other side, adding more triangles and flipping.
    if (e == start) {
      while (true) {
        q = _hullPrev[e];
        final bool orient = _orient(
          x,
          y,
          _coords[2 * q],
          _coords[2 * q + 1],
          _coords[2 * e],
          _coords[2 * e + 1],
        );
        if (!orient) {
          break;
        }
        t = _addTriangle(q, i, e, -1, _hullTri[e], _hullTri[q]);
        _legalize(t + 2);
        _hullTri[q] = t;
        _hullNext[e] = e; // Mark as removed.
        hullSize--;
        e = q;
      }
    }

    // Update the hull indices.
    _hullStart = _hullPrev[i] = e;
    _hullNext[e] = _hullPrev[n] = i;
    _hullNext[i] = n;

    // Save the two new edges in the hash table.
    _hullHash[_hashKey(x, y)] = i;
    _hullHash[_hashKey(_coords[2 * e], _coords[2 * e + 1])] = e;
    return hullSize;
  }

  int _hashKey(double x, double y) {
    return (_pseudoAngle(x - _cx, y - _cy) * _hashSize).floor() & _hashMask;
  }

  // Monotonically increases with real angle, but doesn't need expensive
  // trigonometry. Search for 'Diamond Angle'.
  double _pseudoAngle(double dx, double dy) {
    final double p = dx / (dx.abs() + dy.abs());
    return (dy > 0.0 ? 3.0 - p : 1.0 + p) / 4.0; // [0..1]
  }

  // We know that the indices will be no bigger than 32-bit ints, so we
  // perform 'mod 3' using the 32-bit multiplicative inverse instead of
  // division, which is much slower. See, among others:
  // https://stackoverflow.com/questions/44212301/efficient-mod-3-in-x86-assembly
  int _mod3(int a) {
    final int r = a * 0xaaaaaaab;
    final int q = r >> 33;
    final int q3 = (q << 1) + q;
    return a - q3;
  }

  int _legalize(int a) {
    int i = 0;
    int ar = 0;

    // Recursion eliminated with a fixed-size stack.
    while (true) {
      final int b = _halfEdges[a];

      // If the pair of triangles doesn't satisfy the Delaunay condition
      // (p1 is inside the circumcircle of [p0, pl, pr]), flip them,
      // then do the same check/flip recursively for the new pair of triangles.
      //
      //           pl                    pl
      //          /||\                  /  \
      //       al/ || \bl            al/    \a
      //        /  ||  \              /      \
      //       /  a||b  \    flip    /___ar___\
      //     p0\   ||   /p1   =>   p0\---bl---/p1
      //        \  ||  /              \      /
      //       ar\ || /br             b\    /br
      //          \||/                  \  /
      //           pr                    pr
      //
      final int a0 = a - _mod3(a);
      ar = a0 + _mod3(a + 2);

      if (b == -1) {
        // Convex hull edge.
        if (i == 0) {
          break;
        }
        a = _edgeStack[--i];
        continue;
      }

      final int b0 = b - _mod3(b);
      final int al = a0 + _mod3(a + 1);
      final int bl = b0 + _mod3(b + 2);

      final int p0 = _triangles[ar];
      final int pr = _triangles[a];
      final int pl = _triangles[al];
      final int p1 = _triangles[bl];

      bool illegal;
      {
        // Check whether p1 is in the circumcircle of p0, pr, and pl.
        final double ax = _coords[2 * p0];
        final double ay = _coords[2 * p0 + 1];
        final double bx = _coords[2 * pr];
        final double by = _coords[2 * pr + 1];
        final double cx = _coords[2 * pl];
        final double cy = _coords[2 * pl + 1];
        final double px = _coords[2 * p1];
        final double py = _coords[2 * p1 + 1];
        final double dx = ax - px;
        final double dy = ay - py;
        final double ex = bx - px;
        final double ey = by - py;
        final double fx = cx - px;
        final double fy = cy - py;

        final double ap = dx * dx + dy * dy;
        final double bp = ex * ex + ey * ey;
        final double cp = fx * fx + fy * fy;

        illegal = dx * (ey * cp - bp * fy) -
                dy * (ex * cp - bp * fx) +
                ap * (ex * fy - ey * fx) <
            0.0;
      }

      if (illegal) {
        _triangles[a] = p1;
        _triangles[b] = p0;

        final int hbl = _halfEdges[bl];

        // Edge swapped on the other side of the hull (rare); fix the halfedge
        // reference.
        if (hbl == -1) {
          int e = _hullStart;
          do {
            if (_hullTri[e] == bl) {
              _hullTri[e] = a;
              break;
            }
            e = _hullPrev[e];
          } while (e != _hullStart);
        }
        _link(a, hbl);
        _link(b, _halfEdges[ar]);
        _link(ar, bl);

        final int br = b0 + _mod3(b + 1);

        // Don't worry about hitting the cap: it can only happen on extremely
        // Degenerate input.
        if (i < _edgeStack.length) {
          _edgeStack[i++] = br;
        }
      } else {
        if (i == 0) {
          break;
        }
        a = _edgeStack[--i];
      }
    }

    return ar;
  }

  double _circumradius(
    double ax,
    double ay,
    double bx,
    double by,
    double cx,
    double cy,
  ) {
    final double dx = bx - ax;
    final double dy = by - ay;
    final double ex = cx - ax;
    final double ey = cy - ay;

    final double bl = dx * dx + dy * dy;
    final double cl = ex * ex + ey * ey;
    final double d = 0.5 / (dx * ey - dy * ex);

    final double x = (ey * bl - dy * cl) * d;
    final double y = (dx * cl - ex * bl) * d;

    return x * x + y * y;
  }

  Point<double> circumcenter(
    double ax,
    double ay,
    double bx,
    double by,
    double cx,
    double cy,
  ) {
    final double dx = bx - ax;
    final double dy = by - ay;
    final double ex = cx - ax;
    final double ey = cy - ay;

    final double bl = dx * dx + dy * dy;
    final double cl = ex * ex + ey * ey;
    final double d = 0.5 / (dx * ey - dy * ex);

    final double x = ax + (ey * bl - dy * cl) * d;
    final double y = ay + (dx * cl - ex * bl) * d;

    return Point<double>(x, y);
  }

  void _link(int a, int b) {
    _halfEdges[a] = b;
    if (b != -1) {
      _halfEdges[b] = a;
    }
  }

  // Add a new triangle given vertex indices and adjacent half-edge ids.
  int _addTriangle(int i0, int i1, int i2, int a, int b, int c) {
    final int t = _trianglesLen;

    _triangles[t] = i0;
    _triangles[t + 1] = i1;
    _triangles[t + 2] = i2;

    _link(t, a);
    _link(t + 1, b);
    _link(t + 2, c);

    _trianglesLen += 3;

    return t;
  }

  double _dist(double ax, double ay, double bx, double by) {
    final double dx = ax - bx;
    final double dy = ay - by;
    return dx * dx + dy * dy;
  }

  // Return 2d orientation sign if we're confident in it through J. Shewchuk's
  // error bound check.
  double _orientIfSure(
    double px,
    double py,
    double rx,
    double ry,
    double qx,
    double qy,
  ) {
    final double l = (ry - py) * (qx - px);
    final double r = (rx - px) * (qy - py);
    return (l - r).abs() >= 3.3306690738754716e-16 * (l + r).abs()
        ? l - r
        : 0.0;
  }

  // A more robust orientation test that's stable in a given triangle (to fix
  // robustness issues).
  bool _orient(
    double rx,
    double ry,
    double qx,
    double qy,
    double px,
    double py,
  ) {
    double orientation = _orientIfSure(px, py, rx, ry, qx, qy);
    if (orientation != 0.0) {
      return orientation < 0.0;
    }
    orientation = _orientIfSure(rx, ry, qx, qy, px, py);
    if (orientation != 0.0) {
      return orientation < 0.0;
    }
    orientation = _orientIfSure(qx, qy, px, py, rx, ry);
    if (orientation != 0.0) {
      return orientation < 0.0;
    }
    return true;
  }

  void _quicksort(Uint32List ids, Float32List dists, int left, int right) {
    if (right - left <= 20) {
      for (int i = left + 1; i <= right; i++) {
        final int temp = ids[i];
        final double tempDist = dists[temp];
        int j = i - 1;
        while (j >= left && dists[ids[j]] > tempDist) {
          ids[j + 1] = ids[j--];
        }
        ids[j + 1] = temp;
      }
    } else {
      final int median = (left + right) >> 1;
      int i = left + 1;
      int j = right;
      swap(ids, median, i);
      if (dists[ids[left]] > dists[ids[right]]) {
        swap(ids, left, right);
      }
      if (dists[ids[i]] > dists[ids[right]]) {
        swap(ids, i, right);
      }
      if (dists[ids[left]] > dists[ids[i]]) {
        swap(ids, left, i);
      }

      final int temp = ids[i];
      final double tempDist = dists[temp];
      while (true) {
        do {
          i++;
        } while (dists[ids[i]] < tempDist);
        do {
          j--;
        } while (dists[ids[j]] > tempDist);
        if (j < i) {
          break;
        }
        swap(ids, i, j);
      }
      ids[left + 1] = ids[j];
      ids[j] = temp;

      if (right - i + 1 >= j - left) {
        _quicksort(ids, dists, i, right);
        _quicksort(ids, dists, left, j - 1);
      } else {
        _quicksort(ids, dists, left, j - 1);
        _quicksort(ids, dists, i, right);
      }
    }
  }

  void swap(Uint32List arr, int i, int j) {
    final int tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
  }

  int find(double x, double y, [int i = 0]) {
    if (x.isNaN || y.isNaN) return -1;
    int i0 = i;
    int c;
    while ((c = _step(i, x, y)) >= 0 && c != i && c != i0) {
      i = c;
    }
    return c;
  }

  int _step(int i, double x, double y) {
    final coords = _coords;
    final halfEdges = _halfEdges;
    final triangles = _triangles;

    if (coords.length < 2) return -1;
    if (_inedges[i] == -1) return (i + 1) % (coords.length >> 1);

    int c = i;
    num dc = pow(x - coords[2 * i], 2) + pow(y - coords[2 * i + 1], 2);
    final int e0 = _inedges[i];
    int e = e0;

    do {
      final int t = triangles[e];
      final num dt = pow(x - coords[2 * t], 2) + pow(y - coords[2 * t + 1], 2);
      if (dt < dc) {
        dc = dt;
        c = t;
      }
      e = e % 3 == 2 ? e - 2 : e + 1;
      if (triangles[e] != i) break; // bad triangulation
      e = halfEdges[e];
      if (e == -1) {
        e = _hull[(_hullIndex[i] + 1) % _hull.length];
        if (e != t) {
          if (pow(x - coords[2 * e], 2) + pow(y - coords[2 * e + 1], 2) < dc) {
            return e;
          }
        }
        break;
      }
    } while (e != e0);

    return c;
  }

  voronoi(Point min, Point max) {
    return Voronoi(delaunay: this, min: min, max: max);
  }
}
