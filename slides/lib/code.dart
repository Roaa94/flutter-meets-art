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
