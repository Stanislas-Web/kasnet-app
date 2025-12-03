part of 'listcheckbox_bloc.dart';

abstract class ListcheckboxState extends Equatable {
  const ListcheckboxState();
}

class ListcheckboxInitial extends ListcheckboxState {
  @override
  List<Object> get props => [];
}

class RepaintListCheckboxState extends ListcheckboxState {
  final List<Day> days;

  const RepaintListCheckboxState({required this.days});

  @override
  List<Object> get props => [days];
}
