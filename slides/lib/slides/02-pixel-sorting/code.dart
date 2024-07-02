const loadImageBytesCode = '''
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
      Paint()..color = pixelColors[i],
    );
  }
}''';

const getHSLColorsListFromImageCode2 = '''
final pixelColors = <HSLColor>[];
for (int i = 0; i < imageBytes.lengthInBytes; i += 4) { // ⬅️ Increment by 4
  final rgbaColor = imageBytes.getUint32(i);
  final color = HSLColor.fromColor(Color(rgbaToArgb(rgbaColor)));
  pixelColors.add(color);
}''';