import 'package:gully_app/config/api_client.dart';
import 'package:gully_app/utils/app_logger.dart';

import '../../config/preferences.dart';
import '../model/user_model.dart';

class AuthApi extends GetConnectClient {
  final Preferences _prefs;

  AuthApi(this._prefs);

  Future<UserModel> loginViaGoogle(Map<String, dynamic> user) async {
    try {
      var response = await post('/auth/google/google-login', user);
      if (response.statusCode != 200) {
        throw Exception(
            response.body['message'] ?? 'Unable to Process Request');
      }

      logger.f(response.body['accessToken']);
      _prefs.storeToken(response.body['accessToken']);
      return UserModel.fromJson(response.body['data']['user']);
    } on Exception {
      rethrow;
    }
  }
}
