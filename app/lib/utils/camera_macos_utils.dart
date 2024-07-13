import 'dart:typed_data';

import 'package:camera_macos/camera_macos.dart';

/// Utility method from the example app in the camera_macos package
/// Source: https://github.com/riccardo-lomazzi/camera_macos/blob/main/example/lib/input_image.dart
///
/// Can be used with the image stream to read image byte data as follows:
/// ```dart
///  final decodedImage =
///      await decodeImageFromList(argb2bitmap(streamedImage).bytes);
///  final imageBytes = await decodedImage.toByteData();
/// ```
/// Consecutively, `imageBytes` can be used to read color data
CameraImageData argb2bitmap(CameraImageData content) {
  final Uint8List updated = Uint8List(content.bytes.length);
  for (int i = 0; i < updated.length; i += 4) {
    updated[i] = content.bytes[i + 1];
    updated[i + 1] = content.bytes[i + 2];
    updated[i + 2] = content.bytes[i + 3];
    updated[i + 3] = content.bytes[i];
  }

  const int headerSize = 122;
  final int contentSize = content.bytes.length;
  final int fileLength = contentSize + headerSize;

  final Uint8List headerIntList = Uint8List(fileLength);

  final ByteData bd = headerIntList.buffer.asByteData();
  bd.setUint8(0x0, 0x42);
  bd.setUint8(0x1, 0x4d);
  bd.setInt32(0x2, fileLength, Endian.little);
  bd.setInt32(0xa, headerSize, Endian.little);
  bd.setUint32(0xe, 108, Endian.little);
  bd.setUint32(0x12, content.width, Endian.little);
  bd.setUint32(0x16, -content.height, Endian.little); //-height
  bd.setUint16(0x1a, 1, Endian.little);
  bd.setUint32(0x1c, 32, Endian.little); // pixel size
  bd.setUint32(0x1e, 3, Endian.little); //BI_BITFIELDS
  bd.setUint32(0x22, contentSize, Endian.little);
  bd.setUint32(0x36, 0x000000ff, Endian.little);
  bd.setUint32(0x3a, 0x0000ff00, Endian.little);
  bd.setUint32(0x3e, 0x00ff0000, Endian.little);
  bd.setUint32(0x42, 0xff000000, Endian.little);

  headerIntList.setRange(
    headerSize,
    fileLength,
    updated,
  );

  return CameraImageData(
    bytes: headerIntList,
    width: content.width,
    height: content.height,
    bytesPerRow: content.bytesPerRow,
  );
}
