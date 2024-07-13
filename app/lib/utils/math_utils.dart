import 'dart:math';

(Point<double>, double) calculateCircumcenterAndRadius(
  double x1,
  double y1,
  double x2,
  double y2,
  double x3,
  double y3,
) {
  final double dx = x2 - x1;
  final double dy = y2 - y1;
  final double ex = x3 - x1;
  final double ey = y3 - y1;

  final ab = (dx * ey - dy * ex) * 2;

  if (ab.abs() < 1e-9) {
    final cx = (x1 + x2 + x3) / 3;
    final cy = (y1 + y2 + y3) / 3;
    return (Point<double>(cx, cy), 0);
  }

  final double bl = dx * dx + dy * dy;
  final double cl = ex * ex + ey * ey;
  final double d = 0.5 / (dx * ey - dy * ex);

  final double x = x1 + (ey * bl - dy * cl) * d;
  final double y = y1 + (dx * cl - ex * bl) * d;

  // Circumradius: Calculate the distance from the circumcenter
  // to one of the vertices
  final double dx1 = x - x1;
  final double dy1 = y - y1;

  final circumradius = sqrt(dx1 * dx1 + dy1 * dy1);

  return (Point<double>(x, y), circumradius);
}

double map(
  double value,
  double start1,
  double stop1,
  double start2,
  double stop2,
) {
  double newValue =
      start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1));
  if (start2 < stop2) {
    newValue = newValue.clamp(start2, stop2);
  } else {
    newValue = newValue.clamp(stop2, start2);
  }
  return newValue;
}
