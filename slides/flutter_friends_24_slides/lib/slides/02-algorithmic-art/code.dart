const delaunayClassInputCode = '''
class Delaunay {
  // [x1, y1, x2, y2, x3, y3, ..... ]
  Delaunay(Float32List coords);
  //...
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

const delaunayVoronoiExtensionCode = '''
class Delaunay {
  Delaunay(Float32List coords);
  //...
  //...
  voronoi(Point min, Point max) {
    return Voronoi(delaunay: this, min: min, max: max);
  }
}''';

const initializeVoronoiCode = '''
final delaunay = Delaunay(seedPoints);
delaunay.update();

final Voronoi voronoi = delaunay.voronoi(
  const Point(0, 0),
  Point(size.width, size.height),
);''';

const paintVoronoiEdgesCode1 = '''
for (int j = 0; j < voronoi.cells.length; j++) {
  final path = Path()
    ..moveTo(voronoi.cells[j][0].dx, voronoi.cells[j][0].dy);
  for (int i = 1; i < voronoi.cells[j].length; i++) {
    path.lineTo(voronoi.cells[j][i].dx, voronoi.cells[j][i].dy);
  }
  path.close();
  
  
  
  
  
  
  
  
}''';

const paintVoronoiEdgesCode2 = '''
for (int j = 0; j < voronoi.cells.length; j++) {
  final path = Path()
    ..moveTo(voronoi.cells[j][0].dx, voronoi.cells[j][0].dy);
  for (int i = 1; i < voronoi.cells[j].length; i++) {
    path.lineTo(voronoi.cells[j][i].dx, voronoi.cells[j][i].dy);
  }
  path.close();

  canvas.drawPath(
    path,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.black,
  );
}''';

const voronoiRelaxationInitializationCode = '''
void _calculate() {
  delaunay = Delaunay(points);
  delaunay.update();
  voronoi = delaunay.voronoi(
    const Point(0, 0),
    Point(widget.size.width, widget.size.height),
  );
  // Some boring math 👇🏻
  centroids = calcCentroids(voronoi.cells);
}''';

const voronoiRelaxationUpdateCode = '''
void _update() {
  points = lerpPoints(points, centroids, 0.01);
  _calculate();
  setState(() {});
}''';

const lerpPointsCode = '''
Float32List lerpPoints(Float32List a, Float32List b, double value) {
  final newPoints = Float32List(a.length);
  for (int i = 0; i < a.length; i++) {
    final lerp = lerpDouble(
      a[i],
      b[i],
      value,
    );
    newPoints[i] = lerp ?? a[i];
  }
  return newPoints;
}''';

const voronoiRelaxationTickerCode = '''
_ticker = createTicker((_) => _update());''';

const cameraImageStreamCode1 = '''
CameraMacOSView(
    //...
    onCameraInizialized: (CameraMacOSController controller) {
      setState(() {
        macOSController = controller;
      });
      macOSController?.startImageStream((image) {
        _loadPixelsFromStreamedImage(image);
      });
    },
    //...
)
''';

const cameraImageStreamCode2 = '''
Future<void> _loadPixelsFromStreamedImage(
  CameraImageData? streamedImage,
) async {
  if (streamedImage != null) {
    var decodedImage =
        await decodeImageFromList(argb2bitmap(streamedImage).bytes);
    final imageBytes = await decodedImage.toByteData();
    _streamedImage = streamedImage;
    _cameraImagePixels = imageBytes;
    // relaxation algorithm
  }
}
''';