part of 'visit_bloc.dart';

abstract class VisitBlocEvent extends Equatable {
  const VisitBlocEvent();
}

class RegisterVisitEvent extends VisitBlocEvent {
  final String codeStore;
  final int state;
  const RegisterVisitEvent({required this.codeStore, required this.state});
  @override
  List<Object> get props => [codeStore, state];
}

class UpdateVisitEvent extends VisitBlocEvent {
  final Visit visit;
  const UpdateVisitEvent({required this.visit});
  @override
  List<Object> get props => [visit];
}

class UpdateQuestionVisitEvent extends VisitBlocEvent {
  final Visit visit;
  final String answer;
  final int numQuestion;
  final int idQuestion;
  const UpdateQuestionVisitEvent(
      {required this.idQuestion, required this.answer, required this.numQuestion, required this.visit});
  @override
  List<Object> get props => [visit];
}

class AddPhototEvent extends VisitBlocEvent {
  final String fileData;
  final int id;
  final int type;
  const AddPhototEvent({required this.fileData, required this.id, required this.type});
  @override
  List<Object> get props => [fileData, id, type];
}

class GetLocationEvent extends VisitBlocEvent {
  final String codeStore;
  final int state;
  const GetLocationEvent({required this.codeStore, required this.state});
  @override
  List<Object> get props => [codeStore, state];
}

class GetPhotosEvent extends VisitBlocEvent {
  final int id;
  final int type;
  const GetPhotosEvent({required this.id, required this.type});
  @override
  List<Object> get props => [id, type];
}

class DeletePhotosEvent extends VisitBlocEvent {
  final int id;
  final int type;
  const DeletePhotosEvent({required this.id, required this.type});
  @override
  List<Object> get props => [id, type];
}
