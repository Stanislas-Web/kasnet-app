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

    HttpClientRequest request =
        await client.getUrl(Uri.parse(url + 'login/authorize?email=$email'));
    request.headers.set('content-type', contentType);
    request.headers.set(HttpHeaders.authorizationHeader, authorization);
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      var responseTransform = await response.transform(utf8.decoder).join();
      final decodeData = json.decode(responseTransform);
      return decodeData;
    } else if (response.statusCode == 403 || response.statusCode == 401) {
      throw LoginForbiddenException;
    } else if (response.statusCode == 400) {
      throw LoginFormatException;
    } else if (response.statusCode == 500) {
      throw LoginServerException;
    } else {
      throw LoginGenericException;
    }
  }
}
