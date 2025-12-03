part of 'visit_bloc.dart';

abstract class VisitBlocState extends Equatable {
  const VisitBlocState();
}

class VisitBlocInitial extends VisitBlocState {
  @override
  List<Object> get props => [];
}

class RegisterVisitState extends VisitBlocState {
  final Visit visit;
  const RegisterVisitState({required this.visit});
  @override
  List<Object> get props => [visit];
}

class UpdateVisitState extends VisitBlocState {
  final Visit visit;
  const UpdateVisitState({required this.visit});
  @override
  List<Object> get props => [visit];
}

class ErrorInVisitState extends VisitBlocState {
  final String response;
  const ErrorInVisitState({required this.response});
  @override
  List<Object> get props => [response];
}

class TokenErrorInVisitState extends VisitBlocState {
  const TokenErrorInVisitState();
  @override
  List<Object> get props => [];
}

class LoadingVisitState extends VisitBlocState {
  const LoadingVisitState();
  @override
  List<Object> get props => [];
}

class AddPhotoState extends VisitBlocState {
  final AgentData agentData;
  final int id;
  final int type;
  const AddPhotoState({required this.agentData, required this.id, required this.type});
  @override
  List<Object> get props => [agentData, id, type];
}

class GetLocationState extends VisitBlocState {
  final FindAgentResponse agentData;
  final String codeStore;
  final String state;
  const GetLocationState({required this.agentData, required this.codeStore, required this.state});
  @override
  List<Object> get props => [agentData, codeStore, state];
}

class GetPhotoState extends VisitBlocState {
  final List<GetPhotosResponse> photos;

  const GetPhotoState({required this.photos});
  @override
  List<Object> get props => [photos];
}

class DeletePhotoState extends VisitBlocState {
  final Visit photos;

  const DeletePhotoState({required this.photos});
  @override
  List<Object> get props => [photos];
}
