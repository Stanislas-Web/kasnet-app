import 'dart:io';

import 'package:un/models/visit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WService {
  static const env = String.fromEnvironment('env', defaultValue: "dev");
   final url = env == "dev" ? "http://10.0.2.2:8080/" : env == "qa" ? "" : env == "prod" ? "" : "";
  HttpClient client = HttpClient();
  String sessionToken = "";
  String sessionnEmail = "";
  String sessionEmail = "";
  String contentType = "";
  String authorization = "";
  String codeStore = "";
  String stateStore = "";
  static Visit? visitPref;
  static List visitPrefTipo = [];
  static List diasDisponibles = [];
  static List horasDisponibles = [];
  static List questionSelected = [];
  static String comentaryPref = "";
  static bool editLocation = false;
  static LatLng? location;
  static int? stateAgent;
  String versionApp = "";
  static int fotoFachada = 0;
  static int fotoVoucher = 0;
  static String? acta;

  static clearPref() async {
    visitPref = null;
    visitPrefTipo = [];
    diasDisponibles = [];
    horasDisponibles = [];
    questionSelected = [];
    comentaryPref = "";
    editLocation = false;
    location = null;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.remove("CODESTORE");
    await _prefs.remove("STATESTORESELECT");
    await _prefs.remove("PICTURE2");
    await _prefs.remove("PICTURE1");
    fotoFachada = 0;
    fotoVoucher = 0;
    acta = null;
    return;
  }

  Future loadVersionAppLocal() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    versionApp = _prefs.getString('VERSION') ?? "";
  }

  forceSelfCertified() {
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  }

  Future saveDataSessionLocal({required String key, required String data}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(key, data);
  }

  Future loadSesionDataLocal() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    sessionToken = _prefs.getString('TOKEN') ?? "";
    sessionEmail = _prefs.getString('EMAIL') ?? "";
    codeStore = _prefs.getString('CODESTORE') ?? "";
    stateStore = _prefs.getString('STATESTORE') ?? "";
  }

  Future loadHeaderTokenLocal() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    sessionToken = _prefs.getString('TOKEN') ?? "";
    contentType = 'application/json; charset=utf-8';
    authorization = "Bearer $sessionToken";
  }
}
