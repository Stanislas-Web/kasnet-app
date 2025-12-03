import 'dart:convert';
import 'dart:io';

import 'package:un/logics/logic.dart';
import 'package:un/models/agent.dart';
import 'package:un/models/question.dart';
import 'dart:async';

abstract class QuestionLogic extends WService {
  Future<List<Question>> getQuestionsVisit();
}

class QuestionForbiddenException implements Exception {}

class QuestionFormatException implements Exception {}

class QuestionServerException implements Exception {}

class QuestionGenericException implements Exception {}

class SimpleQuestion extends QuestionLogic {
  List<Agent> agentList = [];
  Agent agent = Agent();
  List<Question> questionList = [];

  @override
  Future<List<Question>> getQuestionsVisit() async {
    List codeStoreList = codeStore.split(" ");
    codeStore = codeStoreList[0];
    await forceSelfCertified();
    await saveDataSessionLocal(key: "CODESTORE", data: codeStore);
    await loadSesionDataLocal();
    await loadHeaderTokenLocal();

    HttpClientRequest request =
        await client.getUrl(Uri.parse(url + 'pregunta/findallactive'));
    request.headers.set('content-type', contentType);
    request.headers.set(HttpHeaders.authorizationHeader, authorization);
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      var responseTransform = await response.transform(utf8.decoder).join();
      final decodeData = json.decode(responseTransform);
      final document = new Questions.fromJsonList(decodeData);
      questionList = document.items;
      return questionList;
    } else if (response.statusCode == 403 || response.statusCode == 401) {
      throw QuestionForbiddenException;
    } else if (response.statusCode == 400) {
      throw QuestionFormatException;
    } else if (response.statusCode == 500) {
      throw QuestionServerException;
    } else {
      throw QuestionGenericException;
    }
  }
}
