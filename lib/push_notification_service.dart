import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // 獲取 FCM token
    String? token = await _fcm.getToken();
    if (kDebugMode) {
      print("FCM Token: $token");
    }

    // 處理前台消息
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Received a message while in the foreground!');
        print('Message data: ${message.data}');
      }

      if (message.notification != null) {
        RemoteNotification notification = message.notification!;
        if (kDebugMode) {
          print('Message also contained a notification:');
          print('Title: ${notification.title}');
          print('Body: ${notification.body}');
        }
      }
    });

    // 處理應用在背景或已終止時的消息
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Message clicked!');
      }
    });
  }
}
