import 'dart:async';

import 'package:un/logics/logic_visit.dart';
import 'package:un/models/agent_data.dart';
import 'package:un/models/find_agent.dart';
import 'package:un/models/get_photos.dart';
import 'package:un/models/visit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'visit_bloc_event.dart';
part 'visit_bloc_state.dart';

class VisitBloc extends Bloc<VisitBlocEvent, VisitBlocState> {
  final SimpleVisit? visitLogic;

  VisitBloc({this.visitLogic}) : super(VisitBlocInitial()) {
    on<RegisterVisitEvent>(_onRegisterVisit);
    on<UpdateVisitEvent>(_onUpdateVisit);
    on<UpdateQuestionVisitEvent>(_onUpdateQuestionVisit);
    on<AddPhototEvent>(_onAddPhoto);
    on<GetLocationEvent>(_onGetLocation);
    on<GetPhotosEvent>(_onGetPhotos);
    on<DeletePhotosEvent>(_onDeletePhotos);
  }

  Future<void> _onRegisterVisit(RegisterVisitEvent event, Emitter<VisitBlocState> emit) async {
    await _registerVisit(event, emit);
  }

  Future<void> _onUpdateVisit(UpdateVisitEvent event, Emitter<VisitBlocState> emit) async {
    await _updateVisit(event, emit);
  }

  Future<void> _onUpdateQuestionVisit(UpdateQuestionVisitEvent event, Emitter<VisitBlocState> emit) async {
    await _updateQuestionVisit(event, emit);
  }

  Future<void> _onAddPhoto(AddPhototEvent event, Emitter<VisitBlocState> emit) async {
    await _addPhoto(event, emit);
  }

  Future<void> _onGetLocation(GetLocationEvent event, Emitter<VisitBlocState> emit) async {
    await _getLocation(event, emit);
  }

  Future<void> _onGetPhotos(GetPhotosEvent event, Emitter<VisitBlocState> emit) async {
    await _getPhotos(event, emit);
  }

  Future<void> _onDeletePhotos(DeletePhotosEvent event, Emitter<VisitBlocState> emit) async {
    await _deletePhotos(event, emit);
  }

  Future<void> _registerVisit(RegisterVisitEvent event, Emitter<VisitBlocState> emit) async {
    emit(LoadingVisitState());
    Visit response;
    try {
      response = await visitLogic!.registerVisit(
          codeStore: event.codeStore, state: event.state);
      emit(RegisterVisitState(visit: response));
    } catch (e) {
      if (e is VisitFormatException || e == VisitFormatException) {
        emit(ErrorInVisitState(
            response: 'Error de comunicación')); // Error en el formato de envío
      } else if (e is VisitServerException || e == VisitServerException) {
        emit(ErrorInVisitState(response: 'Error en el servidor'));
      } else if (e is VisitForbiddenException || e == VisitForbiddenException) {
        emit(TokenErrorInVisitState());
      } else if (e is VisitGenericException) {
        emit(ErrorInVisitState(response: 'Ocurrió un error'));
      } else {
        emit(ErrorInVisitState(response: 'Ocurrió un error'));
      }
    }
  }

  Future<void> _updateVisit(UpdateVisitEvent event, Emitter<VisitBlocState> emit) async {
    emit(LoadingVisitState());
    Visit response;
    try {
      response = await visitLogic!.updateVisit(visit: event.visit);
      emit(UpdateVisitState(visit: response));
    } catch (e) {
      if (e is VisitFormatException || e == VisitFormatException) {
        emit(ErrorInVisitState(
            response: 'Error de comunicación')); // Error en el formato de envío
      } else if (e is VisitServerException || e == VisitServerException) {
        emit(ErrorInVisitState(response: 'Error en el servidor'));
      } else if (e is VisitForbiddenException || e == VisitForbiddenException) {
        emit(TokenErrorInVisitState());
      } else if (e is VisitGenericException) {
        emit(ErrorInVisitState(response: 'Ocurrió un error'));
      } else {
        emit(ErrorInVisitState(response: 'Ocurrió un error'));
      }
    }
  }

  Future<void> _updateQuestionVisit(
      UpdateQuestionVisitEvent event, Emitter<VisitBlocState> emit) async {
    emit(LoadingVisitState());
    Visit response;
    try {
      response = await visitLogic!.updateVisitQuestion(
          visit: event.visit,
          numQuestion: event.numQuestion,
          answer: event.answer,
          idQuestion: event.idQuestion);
      emit(UpdateVisitState(visit: response));
    } catch (e) {
      if (e is VisitFormatException || e == VisitFormatException) {
        emit(ErrorInVisitState(
            response: 'Error de comunicación')); // Error en el formato de envío
      } else if (e is VisitServerException || e == VisitServerException) {
        emit(ErrorInVisitState(response: 'Error en el servidor'));
      } else if (e is VisitForbiddenException || e == VisitForbiddenException) {
        emit(TokenErrorInVisitState());
      } else if (e is VisitGenericException) {
        emit(ErrorInVisitState(response: 'Ocurrió un error'));
      } else {
        emit(ErrorInVisitState(response: 'Ocurrió un error'));
      }
    }
  }

  Future<void> _addPhoto(AddPhototEvent event, Emitter<VisitBlocState> emit) async {
    emit(LoadingVisitState());
    AgentData response;
    try {
      response = await visitLogic!.addPhotos(
          fileData: event.fileData, id: event.id, type: event.type);
      emit(AddPhotoState(agentData: response, id: event.id, type: event.type));
    } catch (e) {
      if (e is VisitFormatException || e == VisitFormatException) {
        emit(ErrorInVisitState(
            response: 'Error de comunicación')); // Error en el formato de envío
      } else if (e is VisitServerException || e == VisitServerException) {
        emit(ErrorInVisitState(response: 'Error en el servidor'));
      } else if (e is VisitForbiddenException || e == VisitForbiddenException) {
        emit(TokenErrorInVisitState());
      } else if (e is VisitGenericException) {
        emit(ErrorInVisitState(response: 'Ocurrió un error'));
      } else {
        emit(ErrorInVisitState(response: 'Ocurrió un error'));
      }
    }
  }

  Future<void> _getLocation(GetLocationEvent event, Emitter<VisitBlocState> emit) async {
    emit(LoadingVisitState());
    FindAgentResponse response;
    try {
      response = await visitLogic!.getLocation(
          codeStore: event.codeStore, state: event.state);
      emit(GetLocationState(agentData: response, codeStore: event.codeStore, state: event.state.toString()));
    } catch (e) {
      if (e is VisitFormatException || e == VisitFormatException) {
        emit(ErrorInVisitState(
            response: 'Error de comunicación')); // Error en el formato de envío
      } else if (e is VisitServerException || e == VisitServerException) {
        emit(ErrorInVisitState(response: 'Error en el servidor'));
      } else if (e is VisitForbiddenException || e == VisitForbiddenException) {
        emit(TokenErrorInVisitState());
      } else if (e is VisitGenericException) {
        emit(ErrorInVisitState(response: 'Ocurrió un error'));
      } else {
        emit(ErrorInVisitState(response: 'Ocurrió un error'));
      }
    }
  }

  Future<void> _getPhotos(GetPhotosEvent event, Emitter<VisitBlocState> emit) async {
    emit(LoadingVisitState());
    List<GetPhotosResponse> response;
    try {
      response = await visitLogic!.getPhotos(id: event.id, type: event.type);
      emit(GetPhotoState(photos: response));
    } catch (e) {
      if (e is VisitFormatException || e == VisitFormatException) {
        emit(ErrorInVisitState(
            response: 'Error de comunicación')); // Error en el formato de envío
      } else if (e is VisitServerException || e == VisitServerException) {
        emit(ErrorInVisitState(response: 'Error en el servidor'));
      } else if (e is VisitForbiddenException || e == VisitForbiddenException) {
        emit(TokenErrorInVisitState());
      } else if (e is VisitGenericException) {
        emit(ErrorInVisitState(response: 'Ocurrió un error'));
      } else {
        emit(ErrorInVisitState(response: 'Ocurrió un error'));
      }
    }
  }

  Future<void> _deletePhotos(DeletePhotosEvent event, Emitter<VisitBlocState> emit) async {
    emit(LoadingVisitState());
    Visit response;
    try {
      response = await visitLogic!.delelePhotos(id: event.id, type: event.type);
      emit(DeletePhotoState(photos: response));
    } catch (e) {
      if (e is VisitFormatException || e == VisitFormatException) {
        emit(ErrorInVisitState(
            response: 'Error de comunicación')); // Error en el formato de envío
      } else if (e is VisitServerException || e == VisitServerException) {
        emit(ErrorInVisitState(response: 'Error en el servidor'));
      } else if (e is VisitForbiddenException || e == VisitForbiddenException) {
        emit(TokenErrorInVisitState());
      } else if (e is VisitGenericException) {
        emit(ErrorInVisitState(response: 'Ocurrió un error'));
      } else {
        emit(ErrorInVisitState(response: 'Ocurrió un error'));
      }
    }
  }
}
