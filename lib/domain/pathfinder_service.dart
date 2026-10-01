import 'dart:collection';

import 'point_entity.dart';

/// Service implementing shortest path finding on a 2D grid matrix using BFS algorithm.
class PathfinderService {
  /// The 8 allowed directions for movement (horizontal, vertical, diagonal).
  static const List<Point> _directions = [
    Point(x: 0, y: -1),  // Up
    Point(x: 1, y: -1),  // Up-Right
    Point(x: 1, y: 0),   // Right
    Point(x: 1, y: 1),   // Down-Right
    Point(x: 0, y: 1),   // Down
    Point(x: -1, y: 1),  // Down-Left
    Point(x: -1, y: 0),  // Left
    Point(x: -1, y: -1), // Up-Left
  ];

  /// Blocked cell identifier.
  static const String _blockedSymbol = 'X';

  /// Finds the shortest path from [start] to [end] on the given 2D [grid].
  ///
  /// - [start]: Starting coordinate (Point).
  /// - [end]: Target destination coordinate (Point).
  /// - [grid]: 2D grid matrix where 'X' represents a blocked cell and empty/other string is passable.
  ///
  /// Returns a [List<Point>] representing the path from [start] to [end] inclusive.
  /// Returns an empty list `[]` if no valid path exists or if start/end points are invalid.
  List<Point> findPath(Point start, Point end, List<List<String>> grid) {
    if (grid.isEmpty || grid[0].isEmpty) {
      return [];
    }

    final int height = grid.length;

    if (!_isValidPoint(start, grid, height) || !_isValidPoint(end, grid, height)) {
      return [];
    }

    if (start == end) {
      return [start];
    }

    final Queue<Point> queue = Queue<Point>();
    final Set<Point> visited = <Point>{};
    final Map<Point, Point> parent = <Point, Point>{};

    queue.add(start);
    visited.add(start);

    while (queue.isNotEmpty) {
      final Point current = queue.removeFirst();

      if (current == end) {
        return _reconstructPath(parent, end);
      }

      for (final dir in _directions) {
        final Point neighbor = Point(
          x: current.x + dir.x,
          y: current.y + dir.y,
        );

        if (_isValidPoint(neighbor, grid, height) && !visited.contains(neighbor)) {
          visited.add(neighbor);
          parent[neighbor] = current;
          queue.add(neighbor);
        }
      }
    }

    return [];
  }

  /// Verifies whether [point] is within grid boundaries and is not blocked by 'X'.
  bool _isValidPoint(Point point, List<List<String>> grid, int height) {
    if (point.y < 0 || point.y >= height) {
      return false;
    }
    final int width = grid[point.y].length;
    if (point.x < 0 || point.x >= width) {
      return false;
    }
    return grid[point.y][point.x] != _blockedSymbol;
  }

  /// Reconstructs path from [end] back to [start] using the [parent] map.
  List<Point> _reconstructPath(Map<Point, Point> parent, Point end) {
    final List<Point> path = <Point>[];
    Point? current = end;

    while (current != null) {
      path.add(current);
      current = parent[current];
    }

    return path.reversed.toList();
  }
}
