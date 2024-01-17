import 'dart:convert';

import 'package:gully_app/data/model/notification_model.dart';
import 'package:gully_app/utils/app_logger.dart';
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

  Future<void> setNotifications(List<NotificationModel> notification) async {
    // encode json to string and store
    final json = notification.map((e) => e.toJson()).toList().toString();
    final string = jsonEncode(json);
    _prefs.setString('notifications', string);
    logger.d(string);
  }

  List<NotificationModel> getNotifications() {
    // get string and decode json
    final string = _prefs.getString('notifications');
    final notifications = jsonDecode(string!)
        .map<NotificationModel>((e) => NotificationModel.fromJson(e))
        .toList<List<NotificationModel>>();

    return notifications;
  }
}
