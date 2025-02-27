import 'package:flutter/cupertino.dart';

import '../../data/datasources/firebase_data_source.dart';
import '../dao/fcm/fcm_remote_message.dart';

class FirebaseRepo {
  final FirebaseDataSource _firebaseDataSource;

  FirebaseRepo(this._firebaseDataSource);

  Future<void> init() async {
    await _firebaseDataSource.init();
  }

  Future<String?> getFCMToken() async {
    return await _firebaseDataSource.getToken();
  }

  void onFCMTokenRefresh(ValueChanged<String> onFCMTokenRefresh) {
    _firebaseDataSource.onFCMTokenRefresh(onFCMTokenRefresh);
  }

  void onMessageListen(ValueChanged<FCMRemoteMessage> onMessageListen) {
    _firebaseDataSource.onMessageListen(onMessageListen);
  }

  void cleanOnMessageListen() {
    _firebaseDataSource.cleanOnMessageListen();
  }

  void onMessageOpenedAppListen(
      ValueChanged<FCMRemoteMessage> onMessageOpenedAppListen) {
    _firebaseDataSource.onMessageOpenedAppListen(onMessageOpenedAppListen);
  }

  void cleanOnMessageOpenedAppListen() {
    _firebaseDataSource.cleanOnMessageOpenedAppListen();
  }

  Future<FCMRemoteMessage?> getInitialMessage() async {
    return await _firebaseDataSource.getInitialMessage();
  }

  void onBackgroundMessage(ValueChanged<FCMRemoteMessage> callback) {
    _firebaseDataSource.onBackgroundMessage(callback);
  }

  Future<void> requestNotificationPermission() async {
    await _firebaseDataSource.requestNotificationPermission();
  }

  void recordFlutterFatalError(FlutterErrorDetails details) {
    _firebaseDataSource.recordFlutterFatalError(details);
  }

  void platformDispatcherOnError(Object exception, StackTrace stackTrace) {
    _firebaseDataSource.platformDispatcherOnError(exception, stackTrace);
  }

  Future<void> recordError(dynamic exception, StackTrace? stack,
      {dynamic reason,
      Iterable<Object> information = const [],
      bool? printDetails,
      bool fatal = false}) async {
    _firebaseDataSource.recordError(
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
    await _firebaseDataSource.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  // Not supported on web
  Future<void> setDefaultEventParameters({
    Map<String, Object>? parameters,
  }) async {
    await _firebaseDataSource.setDefaultEventParameters(parameters: parameters);
  }
}
