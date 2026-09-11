import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/global_config.dart';
import '../../config/rx_config.dart';
import '../../data/api_helper.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  String appUrl = '';
  bool shouldNavigateToDashboard = true;
  final RxConfig userData = Get.find();
  bool _started = false;

  @override
  void onReady() {
    super.onReady();
    if (_started) return;
    _started = true;
    userData.initializeDefaults();
    _navigateToDashboard();
    _loadRemoteConfig();
  }

  Future<void> _loadRemoteConfig() async {
    try {
      final value =
          await ApiHelper().getInfoData().timeout(const Duration(seconds: 5));
      // 資料串接API
      final dataApi = (value['data_api'] as List?)?.cast<String>() ?? [];
      if (dataApi.isNotEmpty) userData.dataAPI.assignAll(dataApi);

      // 帶入個別title的資料
      final titles = (value['title_travel'] as List?)?.cast<String>() ?? [];
      if (titles.isNotEmpty) userData.travelTitle.assignAll(titles);

      // 帶入個別keyWord的資料
      final keywords =
          (value['key_word_travel'] as List?)?.cast<String>() ?? [];
      if (keywords.length >= 2) userData.keyWordTravel.assignAll(keywords);

      // 設定頁面的訊息
      userData.option.value = value['option'] as String? ?? '';

      // 設定頁面的小訣竅
      final infoMenu = (value['info_menu'] as List?)?.cast<String>() ?? [];
      if (infoMenu.isNotEmpty) userData.infoMenu.assignAll(infoMenu);

      final flutterVersion = packageInfo.buildNumber; // 您的Flutter版本号
      final iosVersion = value['ios_version'] as String;
      final androidVersion = value['android_version'] as String;

      if (Platform.isAndroid &&
          compareVersion(flutterVersion, androidVersion) < 0) {
        // 在Android上執行的程式碼
        final info = value['info'] as String;
        appUrl = value['android_url'] as String;
        shouldNavigateToDashboard = false;
        _showVersionDialog(Get.context, info);
        return;
      } else if (Platform.isIOS &&
          compareVersion(flutterVersion, iosVersion) < 0) {
        // 在iOS上執行的程式碼
        final info = value['info'] as String;
        appUrl = value['ios_url'] as String;
        shouldNavigateToDashboard = false;
        _showVersionDialog(Get.context, info);
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting version information: $e');
      }
    }
  }

  Future<void> _navigateToDashboard() async {
    await Future.delayed(const Duration(milliseconds: 250));
    if (shouldNavigateToDashboard &&
        !isClosed &&
        Get.currentRoute == AppRoutes.splashPage) {
      Get.offNamed(AppRoutes.dashboard);
    }
  }

  void _showVersionDialog(BuildContext? context, String info) {
    if (context == null || isClosed) return;
    showDialog(
      context: context,
      builder: (_) {
        return Center(
          child: AlertDialog(
            title: const Text('版本更新提示'),
            content: Text(info),
            actions: [
              TextButton(
                child: const Text(
                  '取消',
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () => Get.offNamed(AppRoutes.dashboard),
              ),
              TextButton(
                  child: const Text('更新', style: TextStyle(color: Colors.red)),
                  onPressed: () async {
                    _launchUrl(appUrl);
                  }),
            ],
          ),
        );
      },
    );
  }

  /// 執行跳轉
  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  int compareVersion(String currentVersion, String newVersion) {
    final current = currentVersion.split('.').map(int.parse).toList();
    final updated = newVersion.split('.').map(int.parse).toList();
    for (var i = 0; i < current.length; i++) {
      if (i >= updated.length) {
        return 1;
      }
      if (current[i] < updated[i]) {
        return -1;
      }
      if (current[i] > updated[i]) {
        return 1;
      }
    }
    if (current.length < updated.length) {
      return -1;
    }
    return 0;
  }
}
