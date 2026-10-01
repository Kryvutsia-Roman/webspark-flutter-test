import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_project_webspark/data/api_client.dart';
import 'package:flutter_project_webspark/data/models/point_dto.dart';
import 'package:flutter_project_webspark/data/models/result_dto.dart';
import 'package:flutter_project_webspark/data/task_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late TaskRepository repository;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    repository = TaskRepository(apiClient: mockApiClient);
  });

  group('TaskRepository - fetchTasks', () {
    const baseUrl = 'https://flutter.webspark.dev/flutter/api';

    final mockDataResponse = {
      'error': false,
      'message': 'Success',
      'data': [
        {
          'id': '7864f981-d130-4be6-8e5c-cbefbe187a55',
          'field': ['.X.', '.X.', '...'],
          'start': {'x': 0, 'y': 0},
          'end': {'x': 2, 'y': 2},
        }
      ]
    };

    final mockListResponse = [
      {
        'id': 'task-2',
        'field': ['..', '..'],
        'start': {'x': 0, 'y': 0},
        'end': {'x': 1, 'y': 1},
      }
    ];

    test('should return list of TaskDto on successful GET response with "data" key', () async {
      when(() => mockApiClient.get(baseUrl)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: baseUrl),
          data: mockDataResponse,
          statusCode: 200,
        ),
      );

      final tasks = await repository.fetchTasks(baseUrl);

      expect(tasks.length, equals(1));
      expect(tasks.first.id, equals('7864f981-d130-4be6-8e5c-cbefbe187a55'));
      expect(tasks.first.start, equals(const PointDto(x: 0, y: 0)));
      expect(tasks.first.end, equals(const PointDto(x: 2, y: 2)));
      verify(() => mockApiClient.get(baseUrl)).called(1);
    });

    test('should return list of TaskDto on successful GET response with direct List data', () async {
      when(() => mockApiClient.get(baseUrl)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: baseUrl),
          data: mockListResponse,
          statusCode: 200,
        ),
      );

      final tasks = await repository.fetchTasks(baseUrl);

      expect(tasks.length, equals(1));
      expect(tasks.first.id, equals('task-2'));
      verify(() => mockApiClient.get(baseUrl)).called(1);
    });

    test('should throw Exception on network/server error during fetchTasks', () async {
      when(() => mockApiClient.get(baseUrl)).thenThrow(
        Exception('Server error (500): Internal server error'),
      );

      expect(
        () => repository.fetchTasks(baseUrl),
        throwsA(isA<Exception>()),
      );
      verify(() => mockApiClient.get(baseUrl)).called(1);
    });

    test('should throw Exception when server response data is empty or invalid format', () async {
      when(() => mockApiClient.get(baseUrl)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: baseUrl),
          data: null,
          statusCode: 200,
        ),
      );

      expect(
        () => repository.fetchTasks(baseUrl),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('TaskRepository - sendResults', () {
    const baseUrl = 'https://flutter.webspark.dev/flutter/api';

    final results = [
      const ResultDto(
        id: '7864f981-d130-4be6-8e5c-cbefbe187a55',
        result: ResultDataDto(
          steps: [
            PointDto(x: 0, y: 0),
            PointDto(x: 1, y: 1),
            PointDto(x: 2, y: 2),
          ],
          path: '(0,0)->(1,1)->(2,2)',
        ),
      )
    ];

    test('should return true on successful POST response', () async {
      final payload = results.map((r) => r.toJson()).toList();

      when(() => mockApiClient.post(baseUrl, payload)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: baseUrl),
          data: {'error': false, 'message': 'Results saved successfully'},
          statusCode: 200,
        ),
      );

      final success = await repository.sendResults(baseUrl, results);

      expect(success, isTrue);
      verify(() => mockApiClient.post(baseUrl, payload)).called(1);
    });

    test('should throw Exception on unsuccessful status code or network error during sendResults', () async {
      final payload = results.map((r) => r.toJson()).toList();

      when(() => mockApiClient.post(baseUrl, payload)).thenThrow(
        Exception('Server error (400): Bad Request'),
      );

      expect(
        () => repository.sendResults(baseUrl, results),
        throwsA(isA<Exception>()),
      );
      verify(() => mockApiClient.post(baseUrl, payload)).called(1);
    });
  });
}
