import 'dart:convert';
import 'dart:io';

import 'package:un/logics/logic.dart';
import 'package:un/models/agent.dart';
import 'package:un/models/agent_data.dart';
import 'package:un/models/get_photos.dart';
import 'package:un/models/visit.dart';
import 'package:un/models/find_agent.dart';
import 'dart:async';

abstract class AgentLogic extends WService {
  Future<Visit> registerVisit({required String codeStore, required int state});
  Future<Visit> updateVisit({required Visit visit});
  Future<Visit> updateVisitQuestion({required int idQuestion, required Visit visit, required int numQuestion, required String answer});
  Future<AgentData> addPhotos({required String fileData, required int id, required int type});
  Future<FindAgentResponse> getLocation({required String codeStore, required int state});
  Future<List<GetPhotosResponse>> getPhotos({required int id, required int type});
  Future<Visit> delelePhotos({required int id, required int type});
}

class VisitForbiddenException implements Exception {}

class VisitFormatException implements Exception {}

class VisitServerException implements Exception {}

class VisitGenericException implements Exception {}

class SimpleVisit extends AgentLogic {
  List<Agent> agentList = [];
  Agent agent = Agent();
  String data = '';

  @override
  Future<Visit> registerVisit({required String codeStore, required int state}) async {
    List codeStoreList = codeStore.split(" ");
    String _stateStore = "";
    codeStore = codeStoreList[0];
    if (state == 0) {
      _stateStore = "BAJA";
    } else if (state == 1) {
      _stateStore = "PREAGENTE";
    } else if (state == 2) {
      _stateStore = "INSTALADO";
    } else {
      _stateStore = "BAJA";
    }

    await forceSelfCertified();
    await saveDataSessionLocal(key: "CODESTORE", data: codeStore);
    await saveDataSessionLocal(key: "STATESTORE", data: _stateStore);
    await loadSesionDataLocal();
    await loadHeaderTokenLocal();

    HttpClientRequest request = await client.postUrl(Uri.parse(url +
        'visita/addvisita?codigoAgente=$codeStore&estado=$state&username=$sessionEmail'));
    request.headers.set('content-type', contentType);
    request.headers.set(HttpHeaders.authorizationHeader, authorization);
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      var responseTransform = await response.transform(utf8.decoder).join();
      final decodeData = json.decode(responseTransform);
      Visit responseMethod = Visit.fromJson(decodeData);
      return responseMethod;
    } else if (response.statusCode == 403 || response.statusCode == 401) {
      throw VisitForbiddenException;
    } else if (response.statusCode == 400) {
      throw VisitFormatException;
    } else if (response.statusCode == 500) {
      throw VisitServerException;
    } else {
      throw VisitGenericException;
    }
  }

  @override
  Future<Visit> updateVisit({required Visit visit}) async {
    await forceSelfCertified();
    await loadSesionDataLocal();
    await loadHeaderTokenLocal();
    await saveDataSessionLocal(
        key: "STATESTORESELECT", data: visit.estadoAgente ?? '');
    if ((visit.tipoGestion?.length ?? 0) > 0) {
      WService.visitPrefTipo.clear();
      WService.visitPrefTipo.addAll(visit.tipoGestion ?? []);
    }
    if (visit.esTitular?.isNotEmpty ?? false) {
      WService.visitPref = visit;
    }
    if (visit.diasDisponibles != null &&
        (visit.diasDisponibles?.length ?? 0) > 0 &&
        (visit.horasDisponibles?.length ?? 0) > 0) {
      WService.diasDisponibles.clear();
      WService.diasDisponibles.addAll(visit.diasDisponibles ?? []);
      WService.horasDisponibles.clear();
      WService.horasDisponibles.addAll(visit.horasDisponibles ?? []);
    }
    if (visit.comentario?.isNotEmpty ?? false) {
      WService.comentaryPref = visit.comentario ?? '';
    }
    HttpClientRequest request =
        await client.putUrl(Uri.parse(url + 'visita/update'));
    request.headers.set('content-type', contentType);
    request.headers.set(HttpHeaders.authorizationHeader, authorization);
    print("Auth:");
    print(authorization);

    if (WService.stateAgent == 0) {
      visit.esTitular = "";
    } else if (visit.estadoAgente != null &&
        visit.estadoAgente?.toLowerCase() == "cerrado") {
      visit.esTitular = "";
    } else if (WService.stateAgent == 2 &&
        visit.esTitular != null &&
        visit.esTitular?.toLowerCase() == "si") {
      visit.celularOperador = "";
      visit.correoElectronicoOperador = "";
    } else if (WService.stateAgent == 2 &&
        visit.esTitular != null &&
        visit.esTitular?.toLowerCase() == "no") {
      visit.nombreTitular = "";
      visit.telefono = "";
      visit.telefonoContacto2 = "";
      visit.tipoTelefono = "";
      visit.tipoTelefonoContacto2 = "";
      visit.correoElectronico = "";
      visit.correoElectronico2 = null;
    } else if (WService.stateAgent != null && WService.stateAgent != 0) {
      visit.firmaActaDesinstalacion = null;
    }

    final obj = jsonEncode({
      "celularOperador": visit.celularOperador,
      "codigo": visit.codigo,
      "comentario": visit.comentario,
      "correoElectronico": visit.correoElectronico,
      "correoElectronico2": visit.correoElectronico2,
      "correoElectronicoOperador": visit.correoElectronicoOperador,
      "diasDisponibles": visit.diasDisponibles,
      "esTitular": visit.esTitular,
      "estado": visit.estado,
      "estadoAgente": visit.estadoAgente?.toUpperCase() ?? '',
      "fechaCreacion": visit.fechaCreacion,
      "fechaInstalacion": visit.fechaInstalacion,
      "firmaActaDesinstalacion": visit.firmaActaDesinstalacion,
      "horasDisponibles": visit.horasDisponibles,
      "id": visit.id,
      "latitud": visit.latitud,
      "longitud": visit.longitud,
      "nombreComercio": visit.nombreComercio?.toUpperCase() ?? '',
      "nombreOperador": visit.nombreOperador,
      "nombreTitular": visit.nombreTitular,
      "telefono": visit.telefono,
      "telefonoContacto2": visit.telefonoContacto2,
      "tiposGestion": visit.tipoGestion,
      "tipoTelefono": visit.tipoTelefono,
      "tipoTelefonoContacto2": visit.tipoTelefonoContacto2,
      "trpreguntaXvisitaList": visit.trpreguntaXvisitaList,
      "tsmedioList": visit.tsmedioList,
      "username": visit.username
    });
    request.write(obj);
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      var responseTransform = await response.transform(utf8.decoder).join();
      final decodeData = json.decode(responseTransform);
      Visit responseMethod = Visit.fromJson(decodeData);
      return responseMethod;
    } else if (response.statusCode == 403 || response.statusCode == 401) {
      throw VisitForbiddenException;
    } else if (response.statusCode == 400) {
      throw VisitFormatException;
    } else if (response.statusCode == 500) {
      throw VisitServerException;
    } else {
      throw VisitGenericException;
    }
  }

  @override
  Future<Visit> updateVisitQuestion(
      {required int idQuestion, required Visit visit, required int numQuestion, required String answer}) async {
    await forceSelfCertified();
    await loadSesionDataLocal();
    await loadHeaderTokenLocal();
    HttpClientRequest request = await client.putUrl(
        Uri.parse(url + 'visita/addpreguntas?id=' + visit.id.toString()));
    request.headers.set('content-type', contentType);
    request.headers.set(HttpHeaders.authorizationHeader, authorization);
    print("Auth:");
    print(authorization);
    visit.trpreguntaXvisitaList?[numQuestion]["tppregunta"]["id"] = idQuestion;
    final obj = json.encode({
      "tppregunta": visit.trpreguntaXvisitaList?[numQuestion]["tppregunta"],
      "valor": answer,
      "trpreguntaXvisitaPK": {"preguntaId": 0, "visitaId": 0},
    });
    request.write(obj);
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      if (WService.questionSelected.length > idQuestion) {
        WService.questionSelected[idQuestion - 1] =
            visit.trpreguntaXvisitaList?[numQuestion];
      } else {
        WService.questionSelected.add(visit.trpreguntaXvisitaList?[numQuestion]);
      }
      var responseTransform = await response.transform(utf8.decoder).join();
      final decodeData = json.decode(responseTransform);
      Visit responseMethod = Visit.fromJson(decodeData);
      return responseMethod;
    } else if (response.statusCode == 403 || response.statusCode == 401) {
      throw VisitForbiddenException;
    } else if (response.statusCode == 400) {
      throw VisitFormatException;
    } else if (response.statusCode == 500) {
      throw VisitServerException;
    } else {
      throw VisitGenericException;
    }
  }

  @override
  Future<AgentData> addPhotos({required String fileData, required int id, required int type}) async {
    await forceSelfCertified();
    await loadSesionDataLocal();
    await loadHeaderTokenLocal();
    HttpClientRequest request = await client
        .putUrl(Uri.parse(url + 'visita/addfotos?id=' + id.toString()));
    request.headers.set('content-type', contentType);
    request.headers.set(HttpHeaders.authorizationHeader, authorization);
    print("Auth:");
    print(authorization);
    final obj = jsonEncode({
      "id": 0,
      "imagen": fileData,
      "nombreImagen": "",
      "ruta": "",
      "tipo": type
    });
    request.write(obj);
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      var responseTransform = await response.transform(utf8.decoder).join();
      final decodeData = json.decode(responseTransform);
      AgentData responseMethod = AgentData.fromJson(decodeData);
      if (type == 0) {
        WService.fotoFachada++;
      } else if (type == 1) {
        WService.fotoVoucher++;
      }
      return responseMethod;
    } else if (response.statusCode == 403 || response.statusCode == 401) {
      throw VisitForbiddenException;
    } else if (response.statusCode == 400) {
      throw VisitFormatException;
    } else if (response.statusCode == 500) {
      throw VisitServerException;
    } else {
      throw VisitGenericException;
    }
  }

  @override
  Future<FindAgentResponse> getLocation({required String codeStore, required int state}) async {
    HttpClientResponse? response;
    await forceSelfCertified();
    await loadSesionDataLocal();
    await loadHeaderTokenLocal();
    String _stateStore = stateStore;
    print(Uri.parse(
        url + 'agente/find/codeofsix?code=$codeStore&estado=$_stateStore'));
    try {
      HttpClientRequest request = await client.getUrl(Uri.parse(
          url + 'agente/find/codeofsix?code=$codeStore&estado=$_stateStore'));
      request.headers.set('content-type', contentType);
      request.headers.set(HttpHeaders.authorizationHeader, authorization);
      response = await request.close();
    } catch (e) {
      print(e);
    }
    if (response?.statusCode == 200) {
      var responseTransform = await response!.transform(utf8.decoder).join();
      final decodeData = json.decode(responseTransform);
      FindAgentResponse responseMethod =
          FindAgentResponse.fromJson(decodeData);
      return responseMethod;
    } else if (response?.statusCode == 403 || response?.statusCode == 401) {
      throw VisitForbiddenException;
    } else if (response?.statusCode == 400) {
      throw VisitFormatException;
    } else if (response?.statusCode == 500) {
      throw VisitServerException;
    } else {
      throw VisitGenericException;
    }
  }

  @override
  Future<List<GetPhotosResponse>> getPhotos({required int id, required int type}) async {
    HttpClientResponse? response;
    await forceSelfCertified();
    await loadSesionDataLocal();
    await loadHeaderTokenLocal();
    print(Uri.parse(url + 'visita/find/fotos?id=$id&tipo=$type'));
    try {
      HttpClientRequest request = await client
          .getUrl(Uri.parse(url + 'visita/find/fotos?id=$id&tipo=$type'));
      request.headers.set('content-type', contentType);
      request.headers.set(HttpHeaders.authorizationHeader, authorization);
      response = await request.close();
    } catch (e) {
      print(e);
    }
    if (response?.statusCode == 200) {
      try {
        var responseTransform = await utf8.decoder.bind(response!).join();
        final decodeData = json.decode(responseTransform);
        List<GetPhotosResponse> responseMethod =
            GetPhotosResponseList.fromJsonList(decodeData).items.cast<GetPhotosResponse>();
        return responseMethod;
      } catch (e) {
        print(e);
        throw VisitGenericException;
      }
    } else if (response?.statusCode == 403 || response?.statusCode == 401) {
      throw VisitForbiddenException;
    } else if (response?.statusCode == 400) {
      throw VisitFormatException;
    } else if (response?.statusCode == 500) {
      throw VisitServerException;
    } else {
      throw VisitGenericException;
    }
  }

  @override
  Future<Visit> delelePhotos({required int id, required int type}) async {
    HttpClientResponse? response;
    await forceSelfCertified();
    await loadSesionDataLocal();
    await loadHeaderTokenLocal();
    print(Uri.parse(url + 'visita/deletemedios?id=$id&tipo=$type'));
    try {
      HttpClientRequest request = await client
          .deleteUrl(Uri.parse(url + 'visita/deletemedios?id=$id&tipo=$type'));
      request.headers.set('content-type', contentType);
      request.headers.set(HttpHeaders.authorizationHeader, authorization);
      response = await request.close();
    } catch (e) {
      print(e);
    }
    if (response?.statusCode == 200) {
      try {
        var responseTransform = await utf8.decoder.bind(response!).join();
        final decodeData = json.decode(responseTransform);
        Visit responseMethod = Visit.fromJson(decodeData);
        return responseMethod;
      } catch (e) {
        print(e);
        throw VisitGenericException;
      }
    } else if (response?.statusCode == 403 || response?.statusCode == 401) {
      throw VisitForbiddenException;
    } else if (response?.statusCode == 400) {
      throw VisitFormatException;
    } else if (response?.statusCode == 500) {
      throw VisitServerException;
    } else {
      throw VisitGenericException;
    }
  }
}
