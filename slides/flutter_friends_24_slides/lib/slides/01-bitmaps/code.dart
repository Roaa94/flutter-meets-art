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

const getColorsListFromImageCode1 = '''
final pixelColors = <Color>[];
for (int i = 0; i < imageBytes.lengthInBytes; i += 4) { // ⬅️ Increment by 4
  final rgbaColor = imageBytes.getUint32(i);
  
  
}''';

const getColorsListFromImageCode2 = '''
final pixelColors = <Color>[];
for (int i = 0; i < imageBytes.lengthInBytes; i += 4) { // ⬅️ Increment by 4
  final rgbaColor = imageBytes.getUint32(i);
  final color = Color(rgbaToArgb(rgbaColor)); //  ⬅️ RGBA => ARGB
  pixelColors.add(color);
}''';

const paintImagePixelsCode = '''
@override
void paint(Canvas canvas, Size size) {
  for (int i = 0; i < pixelColors.length; i++) {
    double x = i % imageSize.width;
    double y = i / imageSize.width;
    canvas.drawRect(
      Rect.fromLTWH(x, y, 1, 1),
      _paint..color = pixels[i],
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