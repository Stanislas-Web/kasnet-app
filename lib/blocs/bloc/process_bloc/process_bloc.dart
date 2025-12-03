import 'dart:async';

import 'package:un/logics/logic_process.dart';
import 'package:un/models/process.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'process_event.dart';
part 'process_state.dart';

class ProcessBloc extends Bloc<ProcessEvent, ProcessState> {
  final ProcessLogic? processLogic;

  ProcessBloc({this.processLogic}) : super(ProcessInitial()) {
    on<GetProcessesEvent>(_onGetProcesses);
  }

  Future<void> _onGetProcesses(GetProcessesEvent event, Emitter<ProcessState> emit) async {
    emit(LoadingInProcessState());
    dynamic response;
    try {
      response = await processLogic!.getProcesses();
      emit(GetProcessesState(process: response));
    } catch (e) {
      if (e is ProcessFormatException || e == ProcessFormatException) {
        emit(ErrorInProcessState(
            response: 'Error de comunicación')); // Error en el formato de envío
      } else if (e is ProcessServerException || e == ProcessServerException) {
        emit(ErrorInProcessState(response: 'Error en el servidor'));
      } else if (e is ProcessForbiddenException ||
          e == ProcessForbiddenException) {
        emit(TokenErrorInProcessState());
      } else if (e is ProcessGenericException) {
        emit(ErrorInProcessState(response: 'Ocurrió un error'));
      } else {
        emit(ErrorInProcessState(response: 'Ocurrió un error'));
      }
    }
  }
}
