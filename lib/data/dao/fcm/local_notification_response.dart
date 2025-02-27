import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'fcm_remote_message.dart';

class LocalNotificationResponse {
  final NotificationResponse notificationResponse;

  LocalNotificationResponse(this.notificationResponse);

  String? get payload => notificationResponse.payload;

  @override
  String toString() {
    return 'LocalNotificationResponse{notificationResponse: $notificationResponse}';
  }

  NotificationData get notificationData {
    try {
      return NotificationData.fromMap(jsonDecode(payload ?? '{}'));
    } catch (e) {
      return NotificationData();
    }
  }
}
