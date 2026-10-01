import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/result_dto.dart';
import '../../data/task_repository.dart';
import '../../domain/pathfinder_service.dart';
import '../../domain/point_entity.dart';
import 'process_event.dart';
import 'process_state.dart';

/// Parameter structure passed to background isolate for pathfinding.
class PathfinderIsolateParams {
  final Point start;
  final Point end;
  final List<List<String>> grid;

  PathfinderIsolateParams({
    required this.start,
    required this.end,
    required this.grid,
  });
}

/// Top-level worker function executed inside background isolate.
List<Point> runPathfinderIsolateWorker(PathfinderIsolateParams params) {
  final pathfinder = PathfinderService();
  return pathfinder.findPath(params.start, params.end, params.grid);
}

/// Function signature for executing pathfinding in isolate.
typedef PathfinderRunner = Future<List<Point>> Function(PathfinderIsolateParams params);

/// Business Logic Component managing pathfinding calculation and API submission states.
class ProcessBloc extends Bloc<ProcessEvent, ProcessState> {
  final TaskRepository _taskRepository;
  final PathfinderRunner _pathfinderRunner;
  List<ResultDto> _calculatedResults = [];

  ProcessBloc({
    required TaskRepository taskRepository,
    PathfinderRunner? pathfinderRunner,
  })  : _taskRepository = taskRepository,
        _pathfinderRunner = pathfinderRunner ?? _defaultIsolateRunner,
        super(const ProcessInitial()) {
    on<StartProcess>(_onStartProcess);
    on<SendResults>(_onSendResults);
  }

  static Future<List<Point>> _defaultIsolateRunner(PathfinderIsolateParams params) {
    return compute(runPathfinderIsolateWorker, params);
  }

  /// Handles fetching tasks and executing background isolate pathfinding for each grid.
  Future<void> _onStartProcess(
    StartProcess event,
    Emitter<ProcessState> emit,
  ) async {
    emit(const ProcessLoading());
    try {
      final tasks = await _taskRepository.fetchTasks(event.baseUrl);

      if (tasks.isEmpty) {
        _calculatedResults = [];
        emit(const ProcessCalculated([]));
        return;
      }

      final results = <ResultDto>[];

      for (int i = 0; i < tasks.length; i++) {
        final task = tasks[i];

        // Execute PathfinderService in a background isolate (compute / Isolate.run)
        // to prevent UI freezing on large grid matrices (e.g. 100x100).
        final params = PathfinderIsolateParams(
          start: task.start.toEntity(),
          end: task.end.toEntity(),
          grid: task.toGrid(),
        );

        final List<Point> path = await _pathfinderRunner(params);

        final result = ResultDto.fromPath(
          id: task.id,
          path: path,
        );
        results.add(result);

        final int percentage = ((i + 1) * 100) ~/ tasks.length;
        emit(ProcessCalculating(percentage));
      }

      _calculatedResults = results;
      emit(ProcessCalculated(results));
    } catch (e) {
      emit(ProcessError(_cleanErrorMessage(e)));
    }
  }

  /// Handles sending solved task results to API server.
  Future<void> _onSendResults(
    SendResults event,
    Emitter<ProcessState> emit,
  ) async {
    if (_calculatedResults.isEmpty && state is ProcessCalculated) {
      _calculatedResults = (state as ProcessCalculated).results;
    }

    emit(const ProcessSending());
    try {
      final success = await _taskRepository.sendResults(
        event.baseUrl,
        _calculatedResults,
      );

      if (success) {
        emit(const ProcessSuccess());
      } else {
        emit(const ProcessError('Failed to send results to server'));
      }
    } catch (e) {
      emit(ProcessError(_cleanErrorMessage(e)));
    }
  }

  String _cleanErrorMessage(dynamic error) {
    final msg = error.toString();
    if (msg.startsWith('Exception: ')) {
      return msg.substring(11);
    }
    return msg;
  }
}
