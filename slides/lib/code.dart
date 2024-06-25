const singleRunBubbleSortCode = '''_bubbleSort() {
  for (int i = 0; i < values.length; i++) {
    for (int j = 0; j < values.length - i - 1; j++) {
      final a = values[j];
      final b = values[j + 1];
      if (a > b) {
        _swap(values, j, j + 1);
      }
    }
  }
}''';

const loadImageAssetCode = '''
import 'package:flutter/services.dart';

final img = await rootBundle.load(widget.imagePath);
var decodedImage = await decodeImageFromList(img.buffer.asUint8List());
final imageBytes = await decodedImage.toByteData();''';

const loadImagePixelColorsCode = '''
List<Color> _getPixelColorsFromByteData(ByteData bytes, int imageWidth) {
  final pixelColors = List.filled(bytes.lengthInBytes ~/ 4, Colors.white);
  for (int i = 0; i < bytes.lengthInBytes; i++) {
    int x = (i ~/ 4) % imageWidth;
    int y = (i ~/ 4) ~/ imageWidth;
    int index = ((y * imageWidth) + x) * 4;
    final rgbaColor = bytes.getUint32(index);
    pixelColors[i ~/ 4] = Color(rgbaToArgb(rgbaColor));
  }
  return pixelColors;
}''';

const paintImagePixelsCode = '''
@override
void paint(Canvas canvas, Size size) {
  for (int i = 0; i < pixels.length; i++) {
    double x = i % imageSize.width;
    double y = i / imageSize.width;
    canvas.drawRect(
      Rect.fromLTWH(x, y, 1.1, 1.1),
      Paint()..color = pixels[i],
    );
  }
}''';

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
