const loadImageBytesCode1 = '''
import 'dart:typed_data';


final ByteData img = await rootBundle.load('path/to/image');


''';

const loadImageBytesCode2 = '''
import 'dart:typed_data';
import 'dart:ui' as ui;

final ByteData img = await rootBundle.load('path/to/image');
final ui.Image decodedImage = 
    await decodeImageFromList(img.buffer.asUint8List());
final imageBytes = await decodedImage.toByteData();''';


const paintImagePixelsCode1 = '''
@override
void paint(Canvas canvas, Size size) {
    for (int i = 0; i < size.width * size.height; i++) {
      double x = i % size.width;
      double y = i / size.width;

      final rgbaColor = bytes.getUint32(i * 4); // ⬅️ byte offset     


    }
}''';


const paintImagePixelsCode2 = '''
@override
void paint(Canvas canvas, Size size) {
    for (int i = 0; i < size.width * size.height; i++) {
      double x = i % size.width;
      double y = i / size.width;

      final rgbaColor = bytes.getUint32(i * 4);
      _paint.color = Color(rgbaToArgb(rgbaColor)); //  ⬅️ RGBA => ARGB
      //...
    }
}''';

const getHSLColorsListFromImageCode = '''
final pixelColors = <HSLColor>[];
for (int i = 0; i < imageBytes.lengthInBytes; i += 4) {
  final rgbaColor = imageBytes.getUint32(i);
  // Use `HSL` colors 👇🏻
  final color = HSLColor.fromColor(Color(rgbaToArgb(rgbaColor)));
  pixelColors.add(color);
}''';

const generateRandomlyDistributedPointsCode1 = '''
import 'dart:typed_data';

// [x1, y1, x2, y2, x3, y3, ..... ]
final points = Float32List(count * 2);                    



''';

const generateRandomlyDistributedPointsCode2 = '''
import 'dart:typed_data';

// [x1, y1, x2, y2, x3, y3, ..... ]
final points = Float32List(count * 2);
for (int i = 0; i < points.length; i += 2) {
  points[i] = random.nextDouble() * canvasSize.width;
  points[i + 1] = random.nextDouble() * canvasSize.height;
}''';

const generateRandomlyDistributedPointsCode3 = '''
for (int i = 0; i < points; i += 2) {
  canvas.drawCircle(
    Offset(points[i], points[i + 1]),
    1,
    _paint,
  );
}''';