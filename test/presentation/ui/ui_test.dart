import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project_webspark/data/models/point_dto.dart';
import 'package:flutter_project_webspark/data/models/result_dto.dart';
import 'package:flutter_project_webspark/data/models/task_dto.dart';
import 'package:flutter_project_webspark/domain/point_entity.dart';
import 'package:flutter_project_webspark/presentation/ui/preview_screen.dart';
import 'package:flutter_project_webspark/presentation/ui/result_list_screen.dart';

void main() {
  group('PreviewScreen Widget Tests', () {
    testWidgets('renders PreviewScreen with correct title, route text and grid cells', (WidgetTester tester) async {
      const pathString = '(0,0)->(1,1)->(2,2)';
      const steps = [
        Point(x: 0, y: 0),
        Point(x: 1, y: 1),
        Point(x: 2, y: 2),
      ];
      final grid = [
        ['.', '.', '.'],
        ['.', 'X', '.'],
        ['.', '.', '.'],
      ];
      const start = Point(x: 0, y: 0);
      const end = Point(x: 2, y: 2);

      await tester.pumpWidget(
        MaterialApp(
          home: PreviewScreen(
            pathString: pathString,
            steps: steps,
            grid: grid,
            start: start,
            end: end,
          ),
        ),
      );

      expect(find.text('Preview screen'), findsOneWidget);
      expect(find.text(pathString), findsOneWidget);
      expect(find.text('(0,0)'), findsOneWidget);
    });
  });

  group('ResultListScreen Widget Tests', () {
    testWidgets('renders list of results and navigates to PreviewScreen on tap', (WidgetTester tester) async {
      final task = TaskDto(
        id: 'task-1',
        field: const ['.X.', '.X.', '...'],
        start: const PointDto(x: 0, y: 0),
        end: const PointDto(x: 2, y: 2),
      );

      final result = ResultDto.fromPath(
        id: 'task-1',
        path: const [
          Point(x: 0, y: 0),
          Point(x: 1, y: 1),
          Point(x: 2, y: 2),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ResultListScreen(
            results: [result],
            tasks: [task],
          ),
        ),
      );

      expect(find.text('Result list screen'), findsOneWidget);
      expect(find.text('(0,0)->(1,1)->(2,2)'), findsOneWidget);

      await tester.tap(find.text('(0,0)->(1,1)->(2,2)'));
      await tester.pumpAndSettle();

      expect(find.text('Preview screen'), findsOneWidget);
    });
  });
}
