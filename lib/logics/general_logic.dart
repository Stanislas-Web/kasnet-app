import 'dart:convert';
import 'dart:io';
import 'logic.dart';

abstract class GeneralLogic extends WService {
  Future<Map> matchVersionApp();
}

class CampaignGenericException implements Exception {}

class CampaignTokenException implements Exception {}

class CollectionException implements Exception {}

class CategoriesException implements Exception {}

class SimpleGeneral extends GeneralLogic {
  Map<String, dynamic> responseWS = {};
  static final String currentVersionApp = "1.0.4";

  @override
  Future<Map> matchVersionApp() async {
    await forceSelfCertified();
    await loadSesionDataLocal();
    await loadHeaderTokenLocal();
    HttpClientRequest request = await client
        .getUrl(Uri.parse(url + 'app/needUpdate?version=$currentVersionApp'));
    print(Uri.parse(url + 'app/needUpdate?version=$currentVersionApp'));
    request.headers.set('content-type', contentType);
    request.headers.set(HttpHeaders.authorizationHeader, authorization);
    HttpClientResponse response = await request.close();
    if (response.statusCode == 200) {
      var responseTransform = await response.transform(utf8.decoder).join();
      final decodeData = json.decode(responseTransform);
      if (decodeData) {
        responseWS.addAll({"versionOk": true});
        return responseWS;
      } else {
        responseWS.addAll({"versionOk": false});
        return responseWS;
      }
    } else if (response.statusCode == 401) {
      throw CampaignTokenException();
    } else if (response.statusCode == 403) {
      throw CampaignTokenException();
    } else {
      throw CampaignGenericException();
    }
  }
}
