import 'package:flutter/cupertino.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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

/// 内容类型
enum JDContentType {
  unknown, // 未知
  video, // 视频
  smallVideo, // 短视频
  cartoon, // 漫画
  fiction, // 小说
  image // 图片/美图
}

class UserSexUtil {
  static UserSex toValue(String sexStr) {
    if (sexStr == '1') {
      return UserSex.man;
    } else if (sexStr == '2') {
      return UserSex.girl;
    }

    return UserSex.unknown;
  }

  static String sexIcon(UserSex sex) {
    if (UserSex.man == sex) {
      return 'images/user/tag_man.png';
    } else if (UserSex.girl == sex) {
      return 'images/user/tag_woman.png';
    }

    return '';
  }
}

///1约炮2红灯3裸聊
const String actual_combat_type_yue = '1';
const String actual_combat_type_red = '2';
const String actual_combat_type_luo = '3';

//数据库key前缀
const String history_cartoon_prex = 'cartoon';
const String history_fiction_prex = 'fiction';

// MARK -  一些固定的图片资源路径

// 方形图片占位
String kPlaceholderSquareImage = 'images/placeholder/placeholder_rect.png';
// 小矩形图片占位
String kPlaceholderSmallImage = 'images/placeholder/placeholder_small.png';
// 圆形占位图
String kPlaceholderCircleImage = 'images/placeholder/placeholder_circle.png';
// 大矩形图片占位
const String kPlaceholderBigImage = 'images/placeholder/placeholder_big.png';
// 小矩形图片占位
String kPlaceholderEmptyImage = 'images/placeholder/error_banner.jpeg';

/// 自訂化文字
const String emptyData = '尚未資料';
