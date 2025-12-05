import 'dart:io';
import 'dart:convert';
import 'package:un/logics/logic.dart';

abstract class LoginLogic extends WService {
  Future<Map> login({required String token, required String email});
}

class LoginForbiddenException implements Exception {}

class LoginFormatException implements Exception {}

class LoginServerException implements Exception {}

class LoginGenericException implements Exception {}

class SimpleLoginLogic extends LoginLogic {
  @override
  Future<Map> login({required String token, required String email}) async {
    await forceSelfCertified();
    await saveDataSessionLocal(key: "EMAIL", data: email);
    await saveDataSessionLocal(key: "TOKEN", data: token);
    await loadSesionDataLocal();
    await loadHeaderTokenLocal();

    print('🌐 URL Backend: $url');
    print('📧 Email: $email');
    print('🔑 Token: ${token.substring(0, 20)}...');
    
    final requestUrl = url + 'login/authorize?email=$email';
    print('📍 URL complète: $requestUrl');
    
    try {
      HttpClientRequest request = await client.getUrl(Uri.parse(requestUrl));
      request.headers.set('content-type', contentType);
      request.headers.set(HttpHeaders.authorizationHeader, authorization);
      print('📤 Requête envoyée...');
      HttpClientResponse response = await request.close();
      // HttpClientResponse response = await request.close();
      print('📥 Réponse reçue: ${response.statusCode}');
      if (response.statusCode == 200) {
        var responseTransform = await response.transform(utf8.decoder).join();
        final decodeData = json.decode(responseTransform);
        print('✅ Login réussi: $decodeData');
        return decodeData;
      } else if (response.statusCode == 403 || response.statusCode == 401) {
        print('❌ Erreur 403/401: Non autorisé');
        throw LoginForbiddenException;
      } else if (response.statusCode == 400) {
        print('❌ Erreur 400: Format invalide');
        throw LoginFormatException;
      } else if (response.statusCode == 500) {
        print('❌ Erreur 500: Erreur serveur');
        throw LoginServerException;
      } else {
        print('❌ Erreur ${response.statusCode}: Erreur générique');
        throw LoginGenericException;
      }
    } catch (e) {
      print('💥 Exception durant la requête: $e');
      print('💥 Type: ${e.runtimeType}');
      rethrow;
    }
  }
}
