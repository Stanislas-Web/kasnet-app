part of 'agent_bloc.dart';

abstract class AgentState extends Equatable {
  const AgentState();
}

class AgentInitial extends AgentState {
  @override
  List<Object> get props => [];
}

class GetAgentsState extends AgentState {
  final List<Agent> agents;
  const GetAgentsState({required this.agents});
  @override
  List<Object> get props => [];
}

class UpdateAgentState extends AgentState {
  final FindAgentResponse visit;
  const UpdateAgentState({required this.visit});
  @override
  List<Object> get props => [];
}

class GetAgentState extends AgentState {
  final Agent agent;
  const GetAgentState({required this.agent});
  @override
  List<Object> get props => [];
}

class ErrorInAgentState extends AgentState {
  final String response;
  const ErrorInAgentState({required this.response});
  @override
  List<Object> get props => [response];
}

class TokenErrorInAgentState extends AgentState {
  @override
  List<Object> get props => [];
}

class LoadingGetAgentState extends AgentState {
  const LoadingGetAgentState();
  @override
  List<Object> get props => [];
}
