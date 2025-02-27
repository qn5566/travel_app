import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';
import '../../global/console.dart';
import '../dao/fcm/fcm_remote_message.dart';

class FirebaseDataSource {
  FirebaseDataSource();

  StreamSubscription? _onMessageSubscription;
  StreamSubscription? _onMessageOpenedAppSubscription;

  Future<String?> getToken() async {
    try {
      if (Platform.isIOS) {
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken == null) {
          logPrint('Error: APNS token is not available.');
          return null;
        }
      }
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      if (e.toString().contains('TOO_MANY_REGISTRATIONS')) {
        logPrint(
            'Error: TOO_MANY_REGISTRATIONS - Too many registrations for this device.');
        return null;
      }
      rethrow;
    }
  }

  void onFCMTokenRefresh(ValueChanged<String> callback) {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      logPrint('onTokenRefresh: $token');
      callback(token);
    });
  }

  Future<void> init() async {
    await initializeDefault();
  }

  /// Firebase 初始設定
  Future<void> initializeDefault() async {
    FirebaseApp app;
    if (Platform.isAndroid) {
      app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).whenComplete(() => logPrint('Firebase.initializeApp() completed'));
    } else {
      app = await Firebase.initializeApp()
          .whenComplete(() => logPrint('Firebase.initializeApp() completed'));
    }

    if (kDebugMode) {
      print('Initialized default app $app');
    }
  }

  //前景收到通知時呼叫
  void onMessageListen(ValueChanged<FCMRemoteMessage> callback) {
    _onMessageSubscription?.cancel();

    _onMessageSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      logPrint('FirebaseMessaging.onMessage : ${message.toMap()}');
      callback.call(FCMRemoteMessage(message));
    });
  }

  void cleanOnMessageListen() {
    _onMessageSubscription?.cancel();
    _onMessageSubscription = null;
  }

  //從背景中點擊通知進入App時呼叫
  void onMessageOpenedAppListen(ValueChanged<FCMRemoteMessage> callback) {
    _onMessageOpenedAppSubscription?.cancel();

    _onMessageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      logPrint('FirebaseMessaging.onMessageOpenedApp: ${message.toMap()}');
      callback.call(FCMRemoteMessage(message));
    });
  }

  void cleanOnMessageOpenedAppListen() {
    _onMessageOpenedAppSubscription?.cancel();
    _onMessageOpenedAppSubscription = null;
  }

  // App 被完全關掉後，進入App時可以呼叫這隻function確認是否從通知進入
  Future<FCMRemoteMessage?> getInitialMessage() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    logPrint('FirebaseMessaging.instance.getInitialMessage: ${message?.data}');
    if (message != null) {
      return FCMRemoteMessage(message);
    }
    return null;
  }

  // 之後會用到實作 FCM foreground，從背景中點擊通知，App 被完全關掉後，時點選通知開啟App（Terminated）
  void onBackgroundMessage(ValueChanged<FCMRemoteMessage> callback) {
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      // If you're going to use other Firebase services in the background, such as Firestore,
      // make sure you call `initializeApp` before using other Firebase services.
      await init();
      callback.call(FCMRemoteMessage(message));
    });
  }

  Future<void> requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // 獲取 FCM token
    String? token = await messaging.getToken();
    if (kDebugMode) {
      print("FCM Token: $token");
    }
  }

  // Crashlytics -----------------
  void recordFlutterFatalError(FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  }

  void platformDispatcherOnError(Object exception, StackTrace stackTrace) {
    FirebaseCrashlytics.instance
        .recordError(exception, stackTrace, fatal: true);
  }

  Future<void> recordError(dynamic exception, StackTrace? stack,
      {dynamic reason,
      Iterable<Object> information = const [],
      bool? printDetails,
      bool fatal = false}) async {
    FirebaseCrashlytics.instance.recordError(
      exception,
      stack,
      reason: reason,
      information: information,
      printDetails: printDetails,
      fatal: fatal,
    );
  }

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await FirebaseAnalytics.instance.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  Future<void> setDefaultEventParameters({
    Map<String, Object?>? parameters,
  }) async {
    // Not supported on web
    await FirebaseAnalytics.instance.setDefaultEventParameters(parameters);
  }
}
