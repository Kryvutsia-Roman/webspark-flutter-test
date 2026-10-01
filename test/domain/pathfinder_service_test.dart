import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project_webspark/domain/point_entity.dart';
import 'package:flutter_project_webspark/domain/pathfinder_service.dart';

void main() {
  late PathfinderService pathfinder;

  setUp(() {
    pathfinder = PathfinderService();
  });

  group('PathfinderService', () {
    test('should return direct diagonal path on clear grid', () {
      final grid = [
        ['.', '.', '.'],
        ['.', '.', '.'],
        ['.', '.', '.'],
      ];
      const start = Point(x: 0, y: 0);
      const end = Point(x: 2, y: 2);

      final path = pathfinder.findPath(start, end, grid);

      expect(path, equals([
        const Point(x: 0, y: 0),
        const Point(x: 1, y: 1),
        const Point(x: 2, y: 2),
      ]));
    });

    test('should navigate around obstacle X', () {
      final grid = [
        ['.', '.', '.'],
        ['.', 'X', '.'],
        ['.', '.', '.'],
      ];
      const start = Point(x: 0, y: 0);
      const end = Point(x: 2, y: 2);

      final path = pathfinder.findPath(start, end, grid);

      expect(path.isNotEmpty, isTrue);
      expect(path.first, equals(start));
      expect(path.last, equals(end));
      expect(path.contains(const Point(x: 1, y: 1)), isFalse);
    });

    test('should return empty list if target is unreachable', () {
      final grid = [
        ['.', 'X', '.'],
        ['X', 'X', '.'],
        ['.', '.', '.'],
      ];
      const start = Point(x: 0, y: 0);
      const end = Point(x: 2, y: 2);

      final path = pathfinder.findPath(start, end, grid);

      expect(path, isEmpty);
    });

    test('should return single point if start equals end', () {
      final grid = [
        ['.', '.'],
        ['.', '.'],
      ];
      const point = Point(x: 1, y: 1);

      final path = pathfinder.findPath(point, point, grid);

      expect(path, equals([point]));
    });

    test('should return empty list if start or end point is blocked by X', () {
      final grid = [
        ['X', '.'],
        ['.', '.'],
      ];
      const start = Point(x: 0, y: 0);
      const end = Point(x: 1, y: 1);

      final path = pathfinder.findPath(start, end, grid);

      expect(path, isEmpty);
    });

    test('should return empty list if start or end point is out of bounds', () {
      final grid = [
        ['.', '.'],
        ['.', '.'],
      ];
      const start = Point(x: -1, y: 0);
      const end = Point(x: 1, y: 1);

      final path = pathfinder.findPath(start, end, grid);

      expect(path, isEmpty);
    });

    test('should return empty list on empty grid', () {
      final path = pathfinder.findPath(
        const Point(x: 0, y: 0),
        const Point(x: 0, y: 0),
        [],
      );

      expect(path, isEmpty);
    });

    test('should support empty string cells as passable', () {
      final grid = [
        ['', ''],
        ['', ''],
      ];
      const start = Point(x: 0, y: 0);
      const end = Point(x: 1, y: 1);

      final path = pathfinder.findPath(start, end, grid);

      expect(path, equals([
        const Point(x: 0, y: 0),
        const Point(x: 1, y: 1),
      ]));
    });
  });
}
