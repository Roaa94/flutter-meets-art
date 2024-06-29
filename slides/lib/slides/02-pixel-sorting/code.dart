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
