import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/result_dto.dart';
import '../../data/models/task_dto.dart';
import '../bloc/process_bloc.dart';
import 'preview_screen.dart';

/// Screen 3: Result List Screen displaying list of solved task path strings.
class ResultListScreen extends StatelessWidget {
  final List<ResultDto>? results;
  final List<TaskDto>? tasks;

  const ResultListScreen({
    super.key,
    this.results,
    this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    List<ResultDto> displayResults = results ?? [];
    List<TaskDto> displayTasks = tasks ?? [];

    if (results == null || tasks == null) {
      try {
        final bloc = context.read<ProcessBloc>();
        displayResults = results ?? bloc.results;
        displayTasks = tasks ?? bloc.tasks;
      } catch (_) {
        // Fallback if ProcessBloc is not present in BuildContext
      }
    }

    final taskMap = {for (var t in displayTasks) t.id: t};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result list screen'),
      ),
      body: SafeArea(
        child: displayResults.isEmpty
            ? const Center(child: Text('No results available'))
            : ListView.separated(
                itemCount: displayResults.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  thickness: 1,
                ),
                itemBuilder: (context, index) {
                  final resultDto = displayResults[index];
                  final pathString = resultDto.result.path;
                  final matchingTask = taskMap[resultDto.id];

                  return InkWell(
                    onTap: () {
                      if (matchingTask == null) return;

                      final steps = resultDto.result.steps
                          .map((s) => s.toEntity())
                          .toList();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PreviewScreen(
                            pathString: pathString,
                            steps: steps,
                            grid: matchingTask.toGrid(),
                            start: matchingTask.start.toEntity(),
                            end: matchingTask.end.toEntity(),
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 16.0,
                      ),
                      child: Text(
                        pathString,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
