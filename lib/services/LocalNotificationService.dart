import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initilize() {
    InitializationSettings initializationSettings =
        const InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  static Future<void> showNotificationOnForeground(
      RemoteMessage message) async {
    try {
      var notificationDetail = const NotificationDetails(
          android: AndroidNotificationDetails(
              "firebase_push_notification", "firebase_push_notification",
              importance: Importance.max, priority: Priority.high));

      await _notificationsPlugin.show(
        DateTime.now().microsecond,
        message.notification!.title,
        message.notification!.body,
        notificationDetail,
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
