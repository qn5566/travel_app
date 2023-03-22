import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'package:travel/ui/dashboard/dashboard_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/global_config.dart';
import '../../config/rx_config.dart';
import '../../data/api_helper.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  String appUrl = '';
  final RxConfig userData = Get.find();

  void checkVersion(BuildContext context) async {
    await ApiHelper().getInfoData().then((value) {
      // 資料串接API
      userData.dataAPI.value = (value['data_api'] as List).cast<String>();

      // 帶入個別title的資料
      userData.travelTitle.value =
          (value['title_travel'] as List).cast<String>();

      // 帶入個別keyWord的資料
      userData.keyWordTravel.value =
          (value['key_word_travel'] as List).cast<String>();

      // 設定頁面的訊息
      userData.option.value = value['option'];

      // 設定頁面的小訣竅
      userData.infoMenu.value = (value['info_menu'] as List).cast<String>();

      final flutterVersion = packageInfo.buildNumber; // 您的Flutter版本号
      final iosVersion = value['ios_version'] as String;
      final androidVersion = value['android_version'] as String;

      if (Platform.isAndroid &&
          compareVersion(flutterVersion, androidVersion) < 0) {
        // 在Android上執行的程式碼
        final info = value['info'] as String;
        appUrl = value['android_url'] as String;
        _showVersionDialog(context, info);
        return;
      } else if (Platform.isIOS &&
          compareVersion(flutterVersion, iosVersion) < 0) {
        // 在iOS上執行的程式碼
        final info = value['info'] as String;
        appUrl = value['ios_url'] as String;
        _showVersionDialog(context, info);
        return;
      }
    }).catchError((e) {
      if (kDebugMode) {
        print('Error getting version information: $e');
      }
      return;
    });

    await Future.delayed(const Duration(milliseconds: 1000));
    Get.toNamed(AppRoutes.dashboard);
  }

  void _showVersionDialog(BuildContext context, String info) {
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
                onPressed: () => Get.toNamed(AppRoutes.dashboard),
              ),
              TextButton(
                  child: const Text('更新', style: TextStyle(color: Colors.red)),
                  onPressed: () async {
                    final Uri url = Uri.parse(appUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $appUrl';
                    }
                  }),
            ],
          ),
        );
      },
    );
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
