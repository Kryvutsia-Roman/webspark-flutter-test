import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project_webspark/domain/point_entity.dart';

void main() {
  group('Point Entity', () {
    test('should instantiate correctly with x and y coordinates', () {
      const point = Point(x: 2, y: 5);
      expect(point.x, equals(2));
      expect(point.y, equals(5));
    });

  test('should support value equality via Equatable', () {
      const point1 = Point(x: 3, y: 4);
      const point2 = Point(x: 3, y: 4);
      const point3 = Point(x: 1, y: 4);

      expect(point1, equals(point2));
      expect(point1 == point3, isFalse);
    });

    test('should convert to and from JSON correctly', () {
      final json = {'x': 10, 'y': 20};
      final point = Point.fromJson(json);

      expect(point, equals(const Point(x: 10, y: 20)));
      expect(point.toJson(), equals(json));
    });

    test('should format toString as (x,y)', () {
      const point = Point(x: 0, y: 7);
      expect(point.toString(), equals('(0,7)'));
    });
  });
}
