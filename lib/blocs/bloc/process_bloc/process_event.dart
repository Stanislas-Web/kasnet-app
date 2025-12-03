part of 'process_bloc.dart';

abstract class ProcessEvent extends Equatable {
  const ProcessEvent();
}

class GetProcessesEvent extends ProcessEvent {
  const GetProcessesEvent();
  @override
  List<Object> get props => [];
}
