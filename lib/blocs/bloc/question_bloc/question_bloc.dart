import 'dart:async';

import 'package:un/logics/logic_question.dart';
import 'package:un/models/question.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final SimpleQuestion? questionLogic;

  QuestionBloc({this.questionLogic}) : super(QuestionInitial()) {
    on<GetQuestionsEvent>(_onGetQuestions);
  }

  Future<void> _onGetQuestions(GetQuestionsEvent event, Emitter<QuestionState> emit) async {
    emit(LoadingInQuestionState());
    List<Question> response;
    try {
      response = await questionLogic!.getQuestionsVisit();
      emit(GetQuestionsState(questions: response));
    } catch (e) {
      if (e is QuestionFormatException || e == QuestionFormatException) {
        emit(ErrorInQuestionState(
            response: 'Error de comunicación')); // Error en el formato de envío
      } else if (e is QuestionServerException || e == QuestionServerException) {
        emit(ErrorInQuestionState(response: 'Error en el servidor'));
      } else if (e is QuestionForbiddenException ||
          e == QuestionForbiddenException) {
        emit(TokenErrorInQuestionState());
      } else if (e is QuestionGenericException) {
        emit(ErrorInQuestionState(response: 'Ocurrió un error'));
      } else {
        emit(ErrorInQuestionState(response: 'Ocurrió un error'));
      }
    }
  }
}
