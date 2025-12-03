part of 'agent_bloc.dart';

abstract class AgentEvent extends Equatable {
  const AgentEvent();
}

class GetAgentsEvent extends AgentEvent {
  final String codeStore;
  const GetAgentsEvent({required this.codeStore});
  @override
  List<Object> get props => [codeStore];
}

class GetAgentEvent extends AgentEvent {
  final String codeStore;
  const GetAgentEvent({required this.codeStore});
  @override
  List<Object> get props => [codeStore];
}

class UpdateAgentEvent extends AgentEvent {
  final Visit visit;
  final FindAgentResponse agent;
  const UpdateAgentEvent({required this.visit, required this.agent});
  @override
  List<Object> get props => [visit, agent];
}
