import 'dart:async';

import 'package:un/logics/general_logic.dart';
import 'package:bloc/bloc.dart';
import 'bloc.dart';

class GeneralBloc extends Bloc<GeneralEvent, GeneralState> {
  final GeneralLogic? generalLogin;

  GeneralBloc({this.generalLogin}) : super(GeneralInitial()) {
    on<MatchVersionEvent>(_onMatchVersion);
    on<SetInteractionEvent>(_onSetInteraction);
  }

  Future<void> _onMatchVersion(MatchVersionEvent event, Emitter<GeneralState> emit) async {
    await _matchVersion(emit);
  }

  Future<void> _onSetInteraction(SetInteractionEvent event, Emitter<GeneralState> emit) async {}

  Future<void> _matchVersion(Emitter<GeneralState> emit) async {
    try {
      Map response = await generalLogin!.matchVersionApp();
      emit(VersionGettedState(version: response));
    } catch (e) {
      emit(VersionErrorState());
    }
  }
}
