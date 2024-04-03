import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:gully_app/data/model/notification_model.dart';
import 'package:gully_app/utils/app_logger.dart';

class Preferences {
  late final GetStorage _prefs = GetStorage();

  Future<void> storeToken(String token) async {
    _prefs.write('token', token);
  }

  String? getToken() {
    return _prefs.read('token');
  }

  bool get languageSelected => _prefs.read('languageSelected') ?? false;

  String setLanguage(String code) {
    _prefs.write('language', code);
    _prefs.write('languageSelected', true);

    return code;
  }

  String getLanguage() {
    return _prefs.read('language') ?? "en";
  }

  void setLanguageFalse() {
    logger.d("Language set to false");
    _prefs.write('languageSelected', false);
  }

  void clear() {
    _prefs.erase();
  }

  Future<void> setNotifications(List<NotificationModel> notification) async {
    final json = notification.map((e) => e.toJson()).toList().toString();
    final string = jsonEncode(json);
    await _prefs.write('notifications', string);
    logger.d(string);
  }

  Future<List<NotificationModel>> getNotifications() async {
    final string = _prefs.read('notifications') ?? "";

    if (string == "") return [];
    final notifications = jsonDecode(string ?? "")
        .map<NotificationModel>((e) => NotificationModel.fromJson(e))
        .toList<List<NotificationModel>>();

    return notifications;
  }
}
