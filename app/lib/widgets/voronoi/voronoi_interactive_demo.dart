import 'dart:math';

import 'package:app/widgets/voronoi/voronoi_painter_wrapper.dart';
import 'package:flutter/material.dart';

class VoronoiInteractiveDemoPage extends StatelessWidget {
  const VoronoiInteractiveDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: VoronoiInteractiveDemo(),
    );
  }
}

class VoronoiInteractiveDemo extends StatefulWidget {
  const VoronoiInteractiveDemo({
    super.key,
    this.size = const Size(1000.0, 650.0),
  });

  final Size size;

  @override
  State<VoronoiInteractiveDemo> createState() => _VoronoiInteractiveDemoState();
}

class _VoronoiInteractiveDemoState extends State<VoronoiInteractiveDemo> {
  final random = Random(3);
  int _pointsCount = 100;
  bool _showSeedPoints = true;
  bool _showDelaunayTriangles = false;
  bool _showCircumcircles = false;
  bool _showVoronoiPolygons = true;
  bool _fillVoronoiPolygons = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckboxListTile(
                        value: _showSeedPoints,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _showSeedPoints = value);
                          }
                        },
                        title: const Text('Show seed points'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        value: _showDelaunayTriangles,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _showDelaunayTriangles = value);
                          }
                        },
                        title: const Text('Show Delaunay triangles'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        value: _showVoronoiPolygons,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _showVoronoiPolygons = value);
                          }
                        },
                        title: const Text('Show Voronoi polygons'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        value: _fillVoronoiPolygons,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _fillVoronoiPolygons = value);
                          }
                        },
                        title: const Text('Fill Voronoi polygons'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        value: _showCircumcircles,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _showCircumcircles = value);
                          }
                        },
                        title: const Text('Show circumcircles'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('Seed Points Count: $_pointsCount'),
                      ),
                      Slider(
                        value: _pointsCount.toDouble(),
                        min: 5,
                        label: '$_pointsCount',
                        max: 800,
                        divisions: 794 ~/ 10,
                        onChanged: (value) =>
                            setState(() => _pointsCount = value.toInt()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: VoronoiPainterWrapper(
                size: widget.size,
                pointsCount: _pointsCount,
                showSeedPoints: _showSeedPoints,
                showDelaunayTriangles: _showDelaunayTriangles,
                showCircumcircles: _showCircumcircles,
                showVoronoiPolygons: _showVoronoiPolygons,
                fillVoronoiPolygons: _fillVoronoiPolygons,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
