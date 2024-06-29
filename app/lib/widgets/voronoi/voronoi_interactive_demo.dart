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
  bool _paintDelaunayTriangles = false;
  bool _paintCircumcircles = false;
  bool _paintVoronoiPolygonEdges = true;
  bool _paintVoronoiPolygonFills = false;

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
                        value: _paintDelaunayTriangles,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _paintDelaunayTriangles = value);
                          }
                        },
                        title: const Text('Show Delaunay triangles'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        value: _paintVoronoiPolygonEdges,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _paintVoronoiPolygonEdges = value);
                          }
                        },
                        title: const Text('Show Voronoi polygons'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        value: _paintVoronoiPolygonFills,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _paintVoronoiPolygonFills = value);
                          }
                        },
                        title: const Text('Fill Voronoi polygons'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        value: _paintCircumcircles,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _paintCircumcircles = value);
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
                paintDelaunayTriangles: _paintDelaunayTriangles,
                paintCircumcircles: _paintCircumcircles,
                paintVoronoiPolygonEdges: _paintVoronoiPolygonEdges,
                paintVoronoiPolygonFills: _paintVoronoiPolygonFills,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
