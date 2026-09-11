import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// 视频类型
enum VideoType {
  idle,

  /// 免费
  discount,

  /// 折扣
  free,

  /// 限免视频(金币视频短时间免费)
  vip,

  /// VIP 才能观看
  pay

  /// 付费才能观看
}

/// 用户的性别
enum UserSex { unknown, man, girl }

late SharedPreferences prefs;

/// 版本資料包
late PackageInfo info;

class UserUtil {
  /// Initializing the library.
  static Future<void> init([BuildContext? context]) async {
    prefs = await SharedPreferences.getInstance();
    info = await PackageInfo.fromPlatform();
  }
}

SharedPreferences get sharedPreferences {
  return prefs;
}

PackageInfo get packageInfo {
  return info;
}

/// 靜態常量參數設定
class AppConstants {
  // 基本設定
  static const String userName = 'username';

  static const String homeUpdateShareKey = 'update';
  /// Version of the local attraction snapshot. Increment this whenever the
  /// remote schema/source changes and existing rows must be downloaded again.
  static const String homeDataVersionKey = 'home_data_version';
  static const int homeDataVersion = 3;
  static const String homeHistory = 'history';
  static const String wantGo = 'wantGo';
  static const String alreadyGo = 'alreadyGo';
}

/// MARK -  一些固定的图片资源路径
// 小矩形图片占位
String kPlaceholderSmallImage = 'images/placeholder/placeholder_small.jpg';
// 小矩形图片占位
String kPlaceholderEmptyImage = 'images/placeholder/error_banner.jpg';
// 開機圖片
String splashImage = 'images/pics/hi_taiwan.webp';
// 第一次抓取資料
String firstLoading = 'images/icon/loading_data.gif';

/// 自訂化文字
const String emptyData = '尚未資料';

const String baseMainUrl = 'https://himydream.me/app/main.php';

String getRandomErrorImagePath() {
  final List<String> paths = List.generate(
    6,
    (index) =>
        'images/placeholder/error_${(index + 1).toString().padLeft(2, '0')}.webp',
  );
  final random = Random();
  return paths[random.nextInt(paths.length)];
}
