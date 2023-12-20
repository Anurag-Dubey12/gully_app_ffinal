import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  late SharedPreferences _prefs;
  Preferences() {
    init();
  }
  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void storeToken(String token) async {
    _prefs.setString('token', token);
  }

  String? getToken() {
    return _prefs.getString('token');
  }

  void clear() {
    _prefs.clear();
  }
}
