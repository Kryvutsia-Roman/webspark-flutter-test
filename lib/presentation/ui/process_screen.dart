import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/process_bloc.dart';
import '../bloc/process_event.dart';
import '../bloc/process_state.dart';
import 'result_list_screen.dart';

/// Screen 2: Process Screen for tracking task calculations and submitting results.
class ProcessScreen extends StatefulWidget {
  final String baseUrl;

  const ProcessScreen({
    super.key,
    required this.baseUrl,
  });

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProcessBloc>().add(StartProcess(widget.baseUrl));
  }

  void _onSendResults() {
    context.read<ProcessBloc>().add(SendResults(widget.baseUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Process screen'),
      ),
      body: SafeArea(
        child: BlocConsumer<ProcessBloc, ProcessState>(
          listener: (context, state) {
            if (state is ProcessError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is ProcessSuccess) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const ResultListScreen(),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProcessLoading || state is ProcessCalculating) {
              final int percentage = state is ProcessCalculating
                  ? state.progressPercentage
                  : 0;

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          strokeWidth: 6.0,
                          value: state is ProcessCalculating
                              ? percentage / 100.0
                              : null,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '$percentage%',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final bool isSending = state is ProcessSending;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Text(
                    'All calculations has finished, you can send your results to server',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isSending ? null : _onSendResults,
                      child: isSending
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text('Send results to server'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
