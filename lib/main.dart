import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/task_repository.dart';
import 'presentation/bloc/process_bloc.dart';
import 'presentation/ui/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final taskRepository = TaskRepository();

    return BlocProvider<ProcessBloc>(
      create: (_) => ProcessBloc(taskRepository: taskRepository),
      child: MaterialApp(
        title: 'Webspark Pathfinder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
