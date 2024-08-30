const voronoiRelaxationCode1 = '''
void _calculate() {
  delaunay = Delaunay(points);
  delaunay.update();
  voronoi = delaunay.voronoi(...);             


}




''';

const voronoiRelaxationCode2 = '''
void _calculate() {
  delaunay = Delaunay(points);
  delaunay.update();
  voronoi = delaunay.voronoi(...);
  // (Some boring math 👇🏻)  
  centroids = calcCentroids(voronoi.cells);
}




''';

const voronoiRelaxationCode3 = '''
void _calculate() {
  delaunay = Delaunay(points);
  delaunay.update();
  voronoi = delaunay.voronoi(...);
                    
  centroids = calcCentroids(voronoi.cells);
}

void _update() {
  points = lerpPoints(points, centroids, 0.01);

}''';

const voronoiRelaxationCode4 = '''
void _calculate() {
  delaunay = Delaunay(points);
  delaunay.update();
  voronoi = delaunay.voronoi(...);
                    
  centroids = calcCentroids(voronoi.cells);
}

void _update() {
  points = lerpPoints(points, centroids, 0.01);
  _calculate();
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
