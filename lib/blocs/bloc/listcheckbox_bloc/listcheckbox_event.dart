part of 'listcheckbox_bloc.dart';

abstract class ListcheckboxEvent extends Equatable {
  const ListcheckboxEvent();
}

class RepaintListCheckboxEvent extends ListcheckboxEvent {
  final List<Day> days;

  const RepaintListCheckboxEvent({required this.days});

  @override
  List<Object> get props => [days];
}
