part of 'question_bloc.dart';

abstract class QuestionEvent extends Equatable {
  const QuestionEvent();
}

class GetQuestionsEvent extends QuestionEvent {
  const GetQuestionsEvent();
  @override
  List<Object> get props => [];
}
