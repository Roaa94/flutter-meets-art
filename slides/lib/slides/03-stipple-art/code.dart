const delaunayClassInputCode = '''
class Delaunay {
  // [x1, y1, x2, y2, x3, y3, ..... ]
  Delaunay(Float32List coords);
  //...
}''';

const randomRawPointsGenerationCode = '''
Float32List generateRandomPoints({
  required Random random,
  required Size canvasSize,
  required int count,
}) {
  final points = Float32List(count * 2);
  for (int i = 0; i < points.length; i += 2) {
    points[i] = random.nextDouble() * canvasSize.width;
    points[i + 1] = random.nextDouble() * canvasSize.height;
  }
  return points;
}''';

const initDelaunayCode = '''
final seedPoints = generateRandomPoints(
  random: random,
  canvasSize: size,
  count: pointsCount,
);
final delaunay = Delaunay(seedPoints);
delaunay.update();''';

const paintDelaunayTrianglesCode = '''
final triangles = delaunay.triangles;

for (int i = 0; i < triangles.length; i += 3) {
  final t1 = triangles[i];
  final t2 = triangles[i + 1];
  final t3 = triangles[i + 2];

  final x = delaunay.getPoint(t1);
  final y = delaunay.getPoint(t2);
  final z = delaunay.getPoint(t3);

  canvas.drawPath(
    Path()
      ..moveTo(x.x, x.y)
      ..lineTo(y.x, y.y)..lineTo(z.x, z.y)
      ..close(),
    Paint()
      ..color = Colors.black,
  );
}''';
