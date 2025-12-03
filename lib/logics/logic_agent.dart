import 'dart:convert';
import 'dart:io';

import 'package:un/logics/logic.dart';
import 'package:un/models/agent.dart';
import 'package:un/models/find_agent.dart';

import 'dart:async';

import 'package:un/models/visit.dart';

abstract class AgentLogic extends WService {
  Future<List<Agent>> getAgents({required String codeStore});
  Future<Agent> getAgent({required String codeStore});
  Future<FindAgentResponse> updateAgent(
      {required Visit visit, required FindAgentResponse agentData});
}

class AgentForbiddenException implements Exception {}

class AgentFormatException implements Exception {}

class AgentServerException implements Exception {}

class AgentGenericException implements Exception {}

class SimpleAgent extends AgentLogic {
  List<Agent> agentList = [];
  Agent agent = Agent();

  @override
  Future<List<Agent>> getAgents({required String codeStore}) async {
    await forceSelfCertified();
    await loadSesionDataLocal();
    await loadHeaderTokenLocal();

    HttpClientRequest request = await client.getUrl(
        Uri.parse(url + 'agente/find/codestartingwith?code=$codeStore'));
    request.headers.set('content-type', contentType);
    request.headers.set(HttpHeaders.authorizationHeader, authorization);
    HttpClientResponse response = await request.close();
    print("agentes response code: ");
    print(response.statusCode);
    if (response.statusCode == 200) {
      var responseTransform = await response.transform(utf8.decoder).join();
      final decodeData = json.decode(responseTransform);
      final document = new Agents.fromJsonList(decodeData);
      agentList = document.items;
      return agentList;
    } else if (response.statusCode == 403 || response.statusCode == 401) {
      throw AgentForbiddenException;
    } else if (response.statusCode == 400) {
      throw AgentFormatException;
    } else if (response.statusCode == 500) {
      throw AgentServerException;
    } else {
      throw AgentGenericException;
    }
  }

  @override
  Future<Agent> getAgent({required String codeStore}) async {
    await forceSelfCertified();
    await loadSesionDataLocal();
    await loadHeaderTokenLocal();

    codeStore = (codeStore.isEmpty) ? this.codeStore : codeStore;

    HttpClientRequest request = await client.getUrl(Uri.parse(
        url + 'agente/find/codeofsix?code=$codeStore&estado=$stateStore'));
    request.headers.set('content-type', contentType);
    request.headers.set(HttpHeaders.authorizationHeader, authorization);
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      var responseTransform = await response.transform(utf8.decoder).join();
      final decodeData = json.decode(responseTransform);
      final document = new Agent.fromJson(decodeData);
      agent = document;
      return agent;
    } else if (response.statusCode == 403 || response.statusCode == 401) {
      throw AgentForbiddenException;
    } else if (response.statusCode == 400) {
      throw AgentFormatException;
    } else if (response.statusCode == 500) {
      throw AgentServerException;
    } else {
      throw AgentGenericException;
    }
  }

  @override
  Future<FindAgentResponse> updateAgent(
      {required Visit visit, required FindAgentResponse agentData}) async {
    await forceSelfCertified();
    await loadSesionDataLocal();
    await loadHeaderTokenLocal();

    HttpClientRequest request =
        await client.putUrl(Uri.parse(url + 'agente/update'));
    request.headers.set('content-type', contentType);
    request.headers.set(HttpHeaders.authorizationHeader, authorization);
    print("Auth:");
    print(authorization);

    final obj = jsonEncode({
      "id": null,
      "codigo": visit.codigo,
      "nombreComercio": visit.nombreComercio,
      "direccion": agentData.direccion,
      "latitud": visit.latitud,
      "longitud": visit.longitud,
      "nombreTitular": visit.nombreTitular,
      "telefono": visit.telefono,
      "correoElectronico": visit.correoElectronico?.toUpperCase() ?? '',
      "correoElectronico2": visit.correoElectronico2?.toUpperCase() ?? '',
      "telefonoContacto2": visit.telefonoContacto2,
      "esTitular": visit.esTitular,
      "fechaModificacion": null,
      "fechaInstalacion": agentData.fechaInstalacion,
      "esAgentePrueba": agentData.esAgentePrueba,
      "tipoTelefono": visit.tipoTelefono?.toUpperCase() ?? '',
      "tipoTelefonoContacto2": visit.tipoTelefonoContacto2?.toUpperCase() ?? '',
      "nombreOperador": visit.nombreOperador,
      "celularOperador": visit.celularOperador,
      "correoElectronicoOperador": visit.correoElectronicoOperador,
      "diasDisponibles": agentData.diasDisponibles,
      "horasDisponibles": agentData.horasDisponibles,
      "firmaActaDesinstalacion": visit.firmaActaDesinstalacion,
      "tipoGestion": null,
      "estado": agentData.estado
    });
    request.write(obj);
    HttpClientResponse response = await request.close();
    print(obj);
    if (response.statusCode == 200) {
      var responseTransform = await response.transform(utf8.decoder).join();
      final decodeData = json.decode(responseTransform);
      FindAgentResponse responseMethod =
          FindAgentResponse.fromJson(decodeData);
      return responseMethod;
    } else if (response.statusCode == 403 || response.statusCode == 401) {
      throw AgentForbiddenException;
    } else if (response.statusCode == 400) {
      throw AgentFormatException;
    } else if (response.statusCode == 500) {
      throw AgentServerException;
    } else {
      throw AgentGenericException;
    }
  }
}
