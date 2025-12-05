import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
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
    try {
      print("🔍 Chargement des processus depuis le fichier JSON local");
      final String jsonString = await rootBundle.loadString('assets/process.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      
      print("📊 Processus trouvés: ${jsonData.length}");
      
      final document = Processes.fromJsonList(jsonData);
      processList = document.items;
      return processList;
    } catch (e) {
      print("❌ Erreur lors de la lecture du fichier JSON: $e");
      throw ProcessGenericException();
    }
  }
}
