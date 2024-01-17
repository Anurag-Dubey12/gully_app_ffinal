import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:gully_app/config/preferences.dart';
import 'package:gully_app/data/model/notification_model.dart';
import 'package:gully_app/utils/app_logger.dart';

class NotificationController extends GetxController {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final Preferences preferences;
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  NotificationController({required this.preferences});
  @override
  void onInit() {
    super.onInit();
    logger.i("NotificationController onInit");
    getNotifications();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.i('Got a message whilst in the foreground!');
      logger.i('Message data: ${message.data}');

      if (message.notification != null) {
        logger.i(
            'Message also contained a notification: ${message.notification}');
        notifications.value.add(NotificationModel(
            title: message.notification?.title ?? 'Title N/A',
            body: message.notification?.body ?? '',
            image: null,
            deepLink: null,
            notificationType: null,
            notificationId: message.messageId,
            createdAt: DateTime.now()));
      }
      notifications.refresh();
      preferences.setNotifications(notifications);
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();

    logger.i("Handling a background message: ${message.messageId}");
  }

  Future<void> removeNotification(NotificationModel notification) async {
    notifications.value.remove(notification);
    notifications.refresh();
    preferences.setNotifications(notifications);
  }

  Future<void> clearNotifications() async {
    notifications.value.clear();
    notifications.refresh();
    preferences.setNotifications(notifications);
  }

  Future<void> getNotifications() async {
    notifications.value = preferences.getNotifications();
    notifications.refresh();
  }
}
