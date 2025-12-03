import 'package:equatable/equatable.dart';

abstract class GeneralEvent extends Equatable {
  const GeneralEvent();
}

class MatchVersionEvent extends GeneralEvent {
  @override
  List<Object> get props => [];
}

class SetInteractionEvent extends GeneralEvent {
  final String modulo;
  final String subModulo;
  final int timer;

  const SetInteractionEvent({required this.modulo, required this.subModulo, required this.timer});

  @override
  List<Object> get props => [];
}
