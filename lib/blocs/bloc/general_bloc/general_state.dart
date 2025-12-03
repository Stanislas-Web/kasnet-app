import 'package:equatable/equatable.dart';

abstract class GeneralState extends Equatable {
  const GeneralState();
}

class GeneralInitial extends GeneralState {
  @override
  List<Object> get props => [];
}

class VersionGettedState extends GeneralState {
  final Map version;

  const VersionGettedState({required this.version});

  @override
  List<Object> get props => [version];
}

class VersionErrorState extends GeneralState {
  const VersionErrorState();

  @override
  List<Object> get props => [];
}
