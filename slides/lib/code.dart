const loadImageAssetCode = '''
    final img = await rootBundle.load(widget.imagePath);
    var decodedImage = await decodeImageFromList(img.buffer.asUint8List());
    final imageBytes = await decodedImage.toByteData();
''';

const singleRunBubbleSortCode = '''
  _bubbleSort() {
    for (int i = 0; i < values.length; i++) {
      for (int j = 0; j < values.length - i - 1; j++) {
        final a = values[j];
        final b = values[j + 1];
        if (a > b) {
          _swap(values, j, j + 1);
        }
      }
    }
  }
''';