import 'package:app/playgrounds/weighted_voronoi_stippling_playground.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WeightedVoronoiStipplingPlayground(),
    );
  }
}
