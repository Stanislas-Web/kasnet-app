part of 'process_bloc.dart';

abstract class ProcessState extends Equatable {
  const ProcessState();
}

class ProcessInitial extends ProcessState {
  @override
  List<Object> get props => [];
}

class GetProcessesState extends ProcessState {
  final List<Process> process;

  const GetProcessesState({required this.process});
  @override
  List<Object> get props => [process];
}

class ErrorInProcessState extends ProcessState {
  final String response;
  const ErrorInProcessState({required this.response});
  @override
  List<Object> get props => [response];
}

class TokenErrorInProcessState extends ProcessState {
  const TokenErrorInProcessState();
  @override
  List<Object> get props => [];
}

class LoadingInProcessState extends ProcessState {
  const LoadingInProcessState();
  @override
  List<Object> get props => [];
}
