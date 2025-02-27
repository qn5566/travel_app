import 'package:firebase_messaging/firebase_messaging.dart';

class FCMRemoteMessage {
  final RemoteMessage _remoteMessage;

  FCMRemoteMessage(this._remoteMessage);

  String? get title => _remoteMessage.notification?.title;

  String? get body => _remoteMessage.notification?.body;

  Map<String, dynamic> get data => _remoteMessage.data;

  bool hasNotification() => _remoteMessage.notification != null;

  Map<String, dynamic> toMap() => _remoteMessage.toMap();

  NotificationData get notificationData => NotificationData.fromMap(data);
}

class NotificationData {
  final String? id;
  final String? route;
  final String? title;
  final String? odr; // 轉訂單

  NotificationData({this.id, this.route, this.title, this.odr});

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    return NotificationData(
        id: map['id'] as String?,
        route: map['route'] as String?,
        title: map['title'] as String?,
        odr: map['odr'] as String?);
  }

  @override
  String toString() {
    return 'NotificationData(id: $id, route: $route, title: $title, odr: $odr)';
  }
}
