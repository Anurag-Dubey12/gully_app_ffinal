import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'app_logger.dart';
void backgroundNotificationResponseHandler(
    NotificationResponse notification) async {
  debugPrint('Received background notification response: $notification');
}

class FirebaseNotification {
  final FlutterLocalNotificationsPlugin notificationPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationAndroidSettings =
    AndroidInitializationSettings('logo');

    const DarwinInitializationSettings initializationSettingIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      defaultPresentSound: true,
      defaultPresentAlert: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationAndroidSettings,
      iOS: initializationSettingIOS,
    );

    await notificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationSelected,
      onDidReceiveBackgroundNotificationResponse:
      backgroundNotificationResponseHandler,
    );
  }

  Future<void> onNotificationSelected(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      logger.d("Caught the notification");
    }
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    debugPrint('Showing notification: $id, $title, $body, $payload');
    await notificationPlugin.show(
      id,
      title,
      body,
      await notificationDetails(),
      payload: payload,
    );
  }

  Future<NotificationDetails> notificationDetails() async {
    return const NotificationDetails(
      iOS: DarwinNotificationDetails(),
      android: AndroidNotificationDetails(
        'Gully Team ',
        'Important',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@drawable/logo'
      ),
    );
  }
}
