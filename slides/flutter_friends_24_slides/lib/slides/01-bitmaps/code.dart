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

      canvas.drawRect(
        Rect.fromLTWH(x, y, 1, 1),
        _paint,
      );
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

const generateRandomPointsFromPixelsCode = '''
final coords = Float32List(pointsCount * 2);
for (int i = 0; i < pointsCount; i++) {
  final x = size.width * random.nextDouble();
  final y = size.height * random.nextDouble();
  final offset = Offset(x, y);
  final color =
      getPixelColorFromBytes(bytes: bytes, offset: offset, size: size);
  final brightness = color.computeLuminance();
  coords[i] = offset.dx;
  coords[i + 1] = offset.dy;
}''';