import 'package:equatable/equatable.dart';

import '../../data/models/result_dto.dart';

/// Base class for all states emitted by [ProcessBloc].
abstract class ProcessState extends Equatable {
  const ProcessState();

  @override
  List<Object?> get props => [];
}

/// Initial idle state before processing starts.
class ProcessInitial extends ProcessState {
  const ProcessInitial();
}

/// State emitted while fetching tasks from server.
class ProcessLoading extends ProcessState {
  const ProcessLoading();
}

/// State emitted after processing each task with updated progress percentage (1..100).
class ProcessCalculating extends ProcessState {
  final int progressPercentage;

  const ProcessCalculating(this.progressPercentage);

  @override
  List<Object?> get props => [progressPercentage];
}

/// State emitted when all tasks have been solved and results are prepared.
class ProcessCalculated extends ProcessState {
  final List<ResultDto> results;

  const ProcessCalculated(this.results);

  @override
  List<Object?> get props => [results];
}

/// State emitted while sending solved results to server via POST request.
class ProcessSending extends ProcessState {
  const ProcessSending();
}

/// State emitted when results are successfully sent to server.
class ProcessSuccess extends ProcessState {
  const ProcessSuccess();
}

/// State emitted when an error occurs during fetching, calculating, or sending.
class ProcessError extends ProcessState {
  final String message;

  const ProcessError(this.message);

  @override
  List<Object?> get props => [message];
}
