import 'package:equatable/equatable.dart';

/// Base class for all events handled by [ProcessBloc].
abstract class ProcessEvent extends Equatable {
  const ProcessEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered to start fetching tasks and calculating shortest paths.
class StartProcess extends ProcessEvent {
  final String baseUrl;

  const StartProcess(this.baseUrl);

  @override
  List<Object?> get props => [baseUrl];
}

/// Event triggered to send calculated results to server.
class SendResults extends ProcessEvent {
  final String baseUrl;

  const SendResults(this.baseUrl);

  @override
  List<Object?> get props => [baseUrl];
}
