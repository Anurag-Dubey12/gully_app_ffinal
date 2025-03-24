import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:gully_app/data/model/notification_model.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void clear() async {
    final prefs = await SharedPreferences.getInstance();
    String language = getLanguage();
    _prefs.erase();
    prefs.clear();
    setLanguage(language);
  }

  // Future<void> setNotifications(List<NotificationModel> notification) async {
  //   final List<Map<String, dynamic>> notificationsJson =
  //       notification.map((e) => e.toJson()).toList();
  //   final json = notification.map((e) => e.toJson()).toList().toString();
  //   // final string = jsonEncode(json);
  //   final String jsonString = jsonEncode(notificationsJson);
  //   await _prefs.write('notifications', jsonString);
  //   logger.d(jsonString);
  // }
  //
  // Future<List<NotificationModel>> getNotifications() async {
  //   final String? jsonString = _prefs.read('notifications') ?? "";
  //   if (jsonString == null || jsonString.isEmpty) {
  //     return [];
  //   }
  //   final List<dynamic> decodedList = jsonDecode(jsonString);
  //   return decodedList.map((e) => NotificationModel.fromJson(e)).toList();
  // }

//Notification using Shared Preference


//Previously, GetStorage was used for storing notifications, but it was not functioning properly.
//SharedPreferences is used instead now,This can be changed if needed in the future.
  Future<void> setNotifications(List<NotificationModel> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> notificationsJson =
        notifications.map((e) => e.toJson()).toList();
    final String jsonString = jsonEncode(notificationsJson);
    await prefs.setString('notifications', jsonString);
    logger.d(jsonString);
  }

  Future<List<NotificationModel>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('notifications');
    logger.d("Retrieved Notifications: $jsonString");

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List<dynamic> decodedList = jsonDecode(jsonString);
    return decodedList.map((e) => NotificationModel.fromJson(e)).toList();
  }
}
