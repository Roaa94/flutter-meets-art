import 'package:app/widgets/voronoi/interactive_spiral_voronoi.dart';
import 'package:flutter/material.dart';

class VoronoiArtPlaygroundPage extends StatelessWidget {
  const VoronoiArtPlaygroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: InteractiveSpiralVoronoi(size: screenSize),
    );
  }
}