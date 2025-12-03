import 'dart:convert';
import 'dart:io';

import 'package:un/logics/logic.dart';
import 'package:un/models/process.dart';
import 'dart:async';

abstract class ProcessLogic extends WService {
  Future<List<Process>> getProcesses();
}

class ProcessForbiddenException implements Exception {}

class ProcessFormatException implements Exception {}

class ProcessServerException implements Exception {}

class ProcessGenericException implements Exception {}

class SimpleProcess extends ProcessLogic {
  List<Process> processList = [];
  Process process = Process();

  @override
  Future<List<Process>> getProcesses() async {
    await forceSelfCertified();
    await loadSesionDataLocal();
    await loadHeaderTokenLocal();

    HttpClientRequest request =
        await client.getUrl(Uri.parse(url + 'tipoGestion/find'));
    request.headers.set('content-type', contentType);
    request.headers.set(HttpHeaders.authorizationHeader, authorization);
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      var responseTransform = await response.transform(utf8.decoder).join();
      final decodeData = json.decode(responseTransform);
      final document = new Processes.fromJsonList(decodeData);
      processList = document.items;
      return processList;
    } else if (response.statusCode == 403 || response.statusCode == 401) {
      throw ProcessForbiddenException;
    } else if (response.statusCode == 400) {
      throw ProcessFormatException;
    } else if (response.statusCode == 500) {
      throw ProcessServerException;
    } else {
      throw ProcessGenericException;
    }
  }
}
