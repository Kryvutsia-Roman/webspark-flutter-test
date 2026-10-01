import 'package:flutter/material.dart';

import '../../domain/point_entity.dart';

/// Screen 4: Preview Screen for visualizing the grid and calculated shortest path.
class PreviewScreen extends StatelessWidget {
  final String pathString;
  final List<Point> steps;
  final List<List<String>> grid;
  final Point start;
  final Point end;

  const PreviewScreen({
    super.key,
    required this.pathString,
    required this.steps,
    required this.grid,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    final int height = grid.length;
    final int width = height > 0 ? grid[0].length : 0;
    final int itemCount = height * width;

    final Set<Point> stepSet = steps.toSet();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview screen'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                pathString,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: width == 0
                  ? const Center(child: Text('Empty grid'))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: width,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 0,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          final int y = index ~/ width;
                          final int x = index % width;
                          final Point currentPoint = Point(x: x, y: y);

                          Color cellColor;
                          Color textColor;

                          if (currentPoint == start) {
                            cellColor = const Color(0xFF64FFDA);
                            textColor = Colors.black;
                          } else if (currentPoint == end) {
                            cellColor = const Color(0xFF009688);
                            textColor = Colors.white;
                          } else if (grid[y][x] == 'X') {
                            cellColor = const Color(0xFF000000);
                            textColor = Colors.white;
                          } else if (stepSet.contains(currentPoint)) {
                            cellColor = const Color(0xFF4CAF50);
                            textColor = Colors.white;
                          } else {
                            cellColor = const Color(0xFFFFFFFF);
                            textColor = Colors.black;
                          }

                          return Container(
                            decoration: BoxDecoration(
                              color: cellColor,
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    '($x,$y)',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
