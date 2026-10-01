import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_project_webspark/data/models/point_dto.dart';
import 'package:flutter_project_webspark/data/models/task_dto.dart';
import 'package:flutter_project_webspark/data/task_repository.dart';
import 'package:flutter_project_webspark/presentation/bloc/process_bloc.dart';
import 'package:flutter_project_webspark/presentation/bloc/process_event.dart';
import 'package:flutter_project_webspark/presentation/bloc/process_state.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late ProcessBloc processBloc;
  late MockTaskRepository mockTaskRepository;

  const baseUrl = 'https://flutter.webspark.dev/flutter/api';

  final sampleTask = TaskDto(
    id: 'task-1',
    field: const ['.X.', '.X.', '...'],
    start: const PointDto(x: 0, y: 0),
    end: const PointDto(x: 2, y: 2),
  );

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    processBloc = ProcessBloc(
      taskRepository: mockTaskRepository,
      pathfinderRunner: (params) async => runPathfinderIsolateWorker(params),
    );
  });

  tearDown(() {
    processBloc.close();
  });

  test('initial state should be ProcessInitial', () {
    expect(processBloc.state, equals(const ProcessInitial()));
  });

  group('StartProcess event', () {
    blocTest<ProcessBloc, ProcessState>(
      'emits [ProcessLoading, ProcessCalculating(100), ProcessCalculated] when tasks are successfully fetched and solved',
      build: () {
        when(() => mockTaskRepository.fetchTasks(baseUrl))
            .thenAnswer((_) async => [sampleTask]);
        return processBloc;
      },
      act: (bloc) => bloc.add(const StartProcess(baseUrl)),
      expect: () => [
        const ProcessLoading(),
        const ProcessCalculating(100),
        isA<ProcessCalculated>().having(
          (state) => state.results.length,
          'results length',
          1,
        ),
      ],
      verify: (_) {
        verify(() => mockTaskRepository.fetchTasks(baseUrl)).called(1);
      },
    );

    blocTest<ProcessBloc, ProcessState>(
      'emits [ProcessLoading, ProcessError] when fetchTasks throws an exception',
      build: () {
        when(() => mockTaskRepository.fetchTasks(baseUrl))
            .thenThrow(Exception('Failed to connect to API server'));
        return processBloc;
      },
      act: (bloc) => bloc.add(const StartProcess(baseUrl)),
      expect: () => [
        const ProcessLoading(),
        const ProcessError('Failed to connect to API server'),
      ],
      verify: (_) {
        verify(() => mockTaskRepository.fetchTasks(baseUrl)).called(1);
      },
    );
  });

  group('SendResults event', () {
    blocTest<ProcessBloc, ProcessState>(
      'emits [ProcessSending, ProcessSuccess] when sendResults succeeds',
      build: () {
        when(() => mockTaskRepository.sendResults(baseUrl, any()))
            .thenAnswer((_) async => true);
        return processBloc;
      },
      act: (bloc) => bloc.add(const SendResults(baseUrl)),
      expect: () => [
        const ProcessSending(),
        const ProcessSuccess(),
      ],
      verify: (_) {
        verify(() => mockTaskRepository.sendResults(baseUrl, any())).called(1);
      },
    );

    blocTest<ProcessBloc, ProcessState>(
      'emits [ProcessSending, ProcessError] when sendResults throws an exception',
      build: () {
        when(() => mockTaskRepository.sendResults(baseUrl, any()))
            .thenThrow(Exception('Server error (500)'));
        return processBloc;
      },
      act: (bloc) => bloc.add(const SendResults(baseUrl)),
      expect: () => [
        const ProcessSending(),
        const ProcessError('Server error (500)'),
      ],
      verify: (_) {
        verify(() => mockTaskRepository.sendResults(baseUrl, any())).called(1);
      },
    );
  });
}
