import 'dart:async';

import 'package:un/logics/logic_agent.dart';
import 'package:un/models/agent.dart';
import 'package:un/models/find_agent.dart';
import 'package:un/models/visit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'agent_event.dart';
part 'agent_state.dart';

class AgentBloc extends Bloc<AgentEvent, AgentState> {
  final AgentLogic? agentLogic;

  AgentBloc({this.agentLogic}) : super(AgentInitial()) {
    on<GetAgentsEvent>(_onGetAgents);
    on<GetAgentEvent>(_onGetAgent);
    on<UpdateAgentEvent>(_onUpdateAgent);
  }

  Future<void> _onGetAgents(GetAgentsEvent event, Emitter<AgentState> emit) async {
    await _getAgents(event, emit);
  }

  Future<void> _onGetAgent(GetAgentEvent event, Emitter<AgentState> emit) async {
    await _getAgent(event, emit);
  }

  Future<void> _onUpdateAgent(UpdateAgentEvent event, Emitter<AgentState> emit) async {
    await _updateAgent(event, emit);
  }

  Future<void> _getAgents(GetAgentsEvent event, Emitter<AgentState> emit) async {
    emit(LoadingGetAgentState());
    dynamic response;
    try {
      response = await agentLogic!.getAgents(codeStore: event.codeStore);
      emit(GetAgentsState(agents: response));      
    } catch(e){
      if(e is AgentFormatException || e == AgentFormatException){
        emit(ErrorInAgentState(response:'Error de comunicación'));// Error en el formato de envío
      }else if(e is AgentServerException || e == AgentServerException){
        emit(ErrorInAgentState(response:'Error en el servidor'));
      }else if(e is AgentForbiddenException || e == AgentForbiddenException){
        emit(TokenErrorInAgentState());
      }else if(e is AgentGenericException){
        emit(ErrorInAgentState(response:'Ocurrió un error'));
      }else{
        emit(ErrorInAgentState(response:'Ocurrió un error'));
      }
    }
  }

  Future<void> _getAgent(GetAgentEvent event, Emitter<AgentState> emit) async {
    emit(LoadingGetAgentState());
    dynamic response;
    try {
      response = await agentLogic!.getAgent(codeStore: event.codeStore);
      emit(GetAgentState(agent: response));      
    } catch(e){
      if(e is AgentFormatException || e == AgentFormatException){
        emit(ErrorInAgentState(response:'Error de comunicación'));// Error en el formato de envío
      }else if(e is AgentServerException || e == AgentServerException){
        emit(ErrorInAgentState(response:'Error en el servidor'));
      }else if(e is AgentForbiddenException || e == AgentForbiddenException){
        emit(TokenErrorInAgentState());
      }else if(e is AgentGenericException){
        emit(ErrorInAgentState(response:'Ocurrió un error'));
      }else{
        emit(ErrorInAgentState(response:'Ocurrió un error'));
      }
    }
  }

  Future<void> _updateAgent(UpdateAgentEvent event, Emitter<AgentState> emit) async {
    emit(LoadingGetAgentState());
    dynamic response;
    try {
      response = await agentLogic!.updateAgent(visit: event.visit,agentData: event.agent);
      emit(UpdateAgentState(visit: response));      
    } catch(e){
      if(e is AgentFormatException || e == AgentFormatException){
        emit(ErrorInAgentState(response:'Error de comunicación'));// Error en el formato de envío
      }else if(e is AgentServerException || e == AgentServerException){
        emit(ErrorInAgentState(response:'Error en el servidor'));
      }else if(e is AgentForbiddenException || e == AgentForbiddenException){
        emit(TokenErrorInAgentState());
      }else if(e is AgentGenericException){
        emit(ErrorInAgentState(response:'Ocurrió un error'));
      }else{
        emit(ErrorInAgentState(response:'Ocurrió un error'));
      }
    }
  }

  
  
}
