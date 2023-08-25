import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../util/ui_util.dart';

class StyleInfo {
  /// MARK - 颜色标准

  // 主色 黑色
  static const Color main_black = Colors.black;

  // 主色 黑色 背景
  static const Color main_bg = Colors.black;

  //主色 黑色 弹窗背景
  static const Color main_dialog_bg = Color(0xff2e2e38);

  // 主色 黄色
  static const Color main_yellow = Color(0xffeca730);

  // 辅色 黑色 0x1D1D28
  static const Color black_1D1D28 = main_bg;

  // 辅色 白色 0xFFFFFF
  static const Color white = Colors.white;

  // 辅色 灰色 0x1D1D28
  static const Color gray_7C7C8D = Color(0xff7c7c8d);

  // 辅色 灰色 0x1D1D28
  static const Color gray_C4C4DB = Color(0xffc4c4db);

  // 白色的 70%
  static Color white_07 = Colors.white.withOpacity(0.7);

  // 白色的 40%
  static Color white_04 = Colors.white.withOpacity(0.4);

  // 白色的 12%
  static Color white_012 = Colors.white.withOpacity(0.12);

  // 白色的 8%
  static Color white_008 = Colors.white.withOpacity(0.08);

  // 金色
  static Color golden = Color.fromRGBO(255, 238, 190, 1.0);

  // 集五福 - 新春版，背景色
  static const Color main_new_year_bg = Color(0xFF340000);

  // 集五福 - 新春版，文字黄色
  static const Color main_new_year_yellow = Color(0xffffeebe);

  /// 主色调
  static const Color mainColor = Color(0xFF73BEBA);

  /// 辅助颜色
  static const Color assistColor = Color(0xFF6587E0);

  /// 詳細頁背景色
  static const Color infoBGColor = Color(0xFFF0EFEE);

  /// 詳細的文字配色
  static const Color infoTextColor = Color(0xFF7C7474);

  /// 設定頁面文字配色
  static const Color settingTextColor = Color(0xFF7D8088);

  /// 設定頁面文字配色
  static const Color settingButtonColor = Color(0xFFC6C7CB);

  /// 設定頁面按鈕中文配色
  static const Color settingCHButtonColor = Color(0xFF6587E0);

  /// 設定頁面按鈕英文配色
  static const Color settingENButtonColor = Color(0xFF99B1ED);

  /// 底色
  static const Color backgroundColor = Color(0xFFF6F5FA);

  /// 分割线颜色
  static const Color separatorColor = Color(0xFFF9F9FB);

  /// 分割线颜色
  static const Color separatorSettingColor = Color(0xFFB1AEAE);

  ///  辅助文字色(列表详情文字)
  static const Color grayC5CAD3 = Color(0xFFC5CAD3);

  /// 刪除按鈕
  static const Color deleteButton = Color(0xFFF4BABA);

  ///  辅助文字色(文字颜色)
  static const Color black727B8C = Color(0xFF727B8C);

  static const Color buttonColor = const Color(0xff26b1eb);

  static const Color backImageColor = const Color.fromRGBO(23, 23, 23, 1);

  static const Color searchTextEventHitOne = Color(0xFFC773BE);

  static const Color searchTextEventHitTwo = Color(0xFFF6B5A6);

  static const Color searchTextHomeHitOne = Color(0xFF82BC8F);

  static const Color searchTextHomeHitTwo = Color(0xFFD1B378);

  static const Color searchTextResHitOne = Color(0xFFFD7A6E);

  static const Color searchTextResHitTwo = Color(0xFF73BEBA);

  static const Color searchTextTagOne = Color(0xFF7FAF77);

  static const Color searchTextTagTwo = Color(0xFF8878B4);

  /// 首页，图片标准圆角
  static final double imageRadius = ASize.w(12);

  static const LinearGradient appBarGradient = LinearGradient(
      begin: Alignment(0.5, 0),
      end: Alignment(0.5, 1),
      colors: [const Color(0xff414156), const Color(0xff24365a)]);

  static const LinearGradient gradientWhite24 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Colors.white24, Colors.white24]);

  static const LinearGradient gradientWhite10 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Colors.white10, Colors.white10]);

  static const LinearGradient gradientWhite12 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Colors.white12, Colors.white12]);

  static const LinearGradient gradientWhite = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Colors.white, Colors.white]);

  static const LinearGradient gradientf8 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [const Color(0xfff2f2f2), const Color(0xfff2f2f2)]);

  static const LinearGradient gradientRed = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [const Color(0xffff0909), const Color(0xffff6301)]);

  static const LinearGradient gradientDeepRed = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [const Color(0xffa0101d), const Color(0xffdd3131)]);

  static const LinearGradient gradientYellow = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [const Color(0xffff8f09), const Color(0xffffbf01)]);

  static const LinearGradient gradientYellow2 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [const Color(0xffff671e), const Color(0xffffb71c)]);

  static const LinearGradient gradientGold = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        const Color(0xffffb768),
        const Color(0xffffde88),
        const Color(0xffffda8b),
      ]);

  static const LinearGradient gradientPurple = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [const Color(0xff5c47ff), const Color(0xffb701ff)]);

  static const LinearGradient gradientGreen = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [const Color(0xff2fb002), const Color(0xff1fcd15)]);

  static TextStyle headerTextStyle = TextStyle(
      color: mainColor,
      fontWeight: FontWeight.w500,
      fontFamily: "PingFang-SC",
      fontStyle: FontStyle.normal,
      fontSize: ScreenUtil().setSp(34));

  static TextStyle rightTextStyle = TextStyle(
      color: const Color(0xffa8abc9),
      fontWeight: FontWeight.w700,
      fontFamily: "PingFang-SC",
      fontStyle: FontStyle.normal,
      fontSize: ScreenUtil().setSp(26));

  static TextStyle tipsStyle = TextStyle(
      color: StyleInfo.gray_C4C4DB,
      fontWeight: FontWeight.w400,
      fontFamily: "PingFangSC",
      fontStyle: FontStyle.normal,
      fontSize: ScreenUtil().setSp(28));

  static TextStyle tabSelectStyle = TextStyle(
      fontWeight: FontWeight.w900,
      fontFamily: "PingFang-SC",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);

  static TextStyle tabStyle =
      TextStyle(fontSize: ScreenUtil().setSp(38), fontWeight: FontWeight.bold);

  static TextStyle tabUnSelectStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontFamily: "PingFang-SC",
      fontStyle: FontStyle.normal,
      fontSize: 17.0);

  static TextStyle pdMenuSelect = TextStyle(
      color: const Color(0xffcbf0ff),
      fontWeight: FontWeight.w700,
      fontFamily: "PingFang-SC",
      fontStyle: FontStyle.normal,
      fontSize: ScreenUtil().setSp(30));

  static TextStyle pdMenuUnSelect = TextStyle(
      color: const Color(0xff7681a7),
      fontWeight: FontWeight.w700,
      fontFamily: "PingFang-SC",
      fontStyle: FontStyle.normal,
      fontSize: ScreenUtil().setSp(30));

  static BoxDecoration blueSelect = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(15.5)),
      boxShadow: [
        BoxShadow(
            color: const Color(0x7f0e71bb),
            offset: Offset(0, 5),
            blurRadius: 8,
            spreadRadius: 0)
      ],
      color: const Color(0xff26b1eb));

  static BoxDecoration blueUnSelect = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(15.5)),
      border: Border.all(color: const Color(0xff444c6a), width: 2));

  static TextStyle hintStyle = TextStyle(
      color: const Color(0xffb7b9c3),
      fontWeight: FontWeight.w400,
      fontFamily: "PingFangSC",
      fontStyle: FontStyle.normal,
      fontSize: ScreenUtil().setSp(28));

  static TextStyle searchStyle = TextStyle(
      color: Color.fromRGBO(92, 94, 110, 1.0),
      fontWeight: FontWeight.w400,
      fontFamily: "PingFangSC",
      fontStyle: FontStyle.normal,
      fontSize: ScreenUtil().setSp(28));

  static Widget divider = Opacity(
    opacity: 0.08,
    child: Container(
        width: 375,
        height: 1,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff000000), width: 0.5))),
  );

  static TextStyle appBarTitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 18.0,
  );
}
