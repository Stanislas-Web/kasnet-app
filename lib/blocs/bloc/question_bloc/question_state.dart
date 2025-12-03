part of 'question_bloc.dart';

abstract class QuestionState extends Equatable {
  const QuestionState();
}

class QuestionInitial extends QuestionState {
  @override
  List<Object> get props => [];
}

class GetQuestionsState extends QuestionState {
  final List<Question> questions;

  const GetQuestionsState({required this.questions});
  @override
  List<Object> get props => [questions];
}

class LoadingInQuestionState extends QuestionState {
  const LoadingInQuestionState();
  @override
  List<Object> get props => [];
}

class ErrorInQuestionState extends QuestionState {
  final String response;
  const ErrorInQuestionState({required this.response});
  @override
  List<Object> get props => [response];
}

class TokenErrorInQuestionState extends QuestionState {
  const TokenErrorInQuestionState();
  @override
  List<Object> get props => [];
}
