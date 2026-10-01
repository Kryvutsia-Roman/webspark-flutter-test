import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project_webspark/data/models/point_dto.dart';
import 'package:flutter_project_webspark/data/models/result_dto.dart';
import 'package:flutter_project_webspark/data/models/task_dto.dart';
import 'package:flutter_project_webspark/domain/point_entity.dart';

void main() {
  group('PointDto', () {
    test('should parse from JSON with int and string values', () {
      final jsonInt = {'x': 1, 'y': 2};
      final jsonStr = {'x': '1', 'y': '2'};

      final dto1 = PointDto.fromJson(jsonInt);
      final dto2 = PointDto.fromJson(jsonStr);

      expect(dto1, equals(const PointDto(x: 1, y: 2)));
      expect(dto2, equals(const PointDto(x: 1, y: 2)));
      expect(dto1.toJson(), equals({'x': 1, 'y': 2}));
    });

    test('should convert to and from domain Point entity', () {
      const entity = Point(x: 5, y: 10);
      final dto = PointDto.fromEntity(entity);

      expect(dto, equals(const PointDto(x: 5, y: 10)));
      expect(dto.toEntity(), equals(entity));
    });
  });

  group('TaskDto', () {
    test('should parse correctly from GET JSON response and convert to grid', () {
      final json = {
        'id': 'task-123',
        'field': ['.X.', '.X.', '...'],
        'start': {'x': 0, 'y': 0},
        'end': {'x': 2, 'y': 2},
      };

      final taskDto = TaskDto.fromJson(json);

      expect(taskDto.id, equals('task-123'));
      expect(taskDto.start, equals(const PointDto(x: 0, y: 0)));
      expect(taskDto.end, equals(const PointDto(x: 2, y: 2)));
      expect(taskDto.toGrid(), equals([
        ['.', 'X', '.'],
        ['.', 'X', '.'],
        ['.', '.', '.'],
      ]));
    });
  });

  group('ResultDto', () {
    test('should construct correctly from path points and format POST JSON', () {
      const path = [
        Point(x: 0, y: 0),
        Point(x: 1, y: 1),
        Point(x: 2, y: 2),
      ];

      final resultDto = ResultDto.fromPath(
        id: 'task-123',
        path: path,
      );

      final json = resultDto.toJson();

      expect(json, equals({
        'id': 'task-123',
        'result': {
          'steps': [
            {'x': 0, 'y': 0},
            {'x': 1, 'y': 1},
            {'x': 2, 'y': 2},
          ],
          'path': '(0,0)->(1,1)->(2,2)',
        },
      }));
    });
  });
}
