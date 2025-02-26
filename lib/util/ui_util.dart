import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 自动尺寸，基于 flutter_screenutil
/// AutoSize 的缩写[ASize]
class ASize {
  /// 设置宽度
  /// [width] 宽度会自动适配，width 就是UI效果图上面标注的尺寸
  static double w(num width) => ScreenUtil().setWidth(width * 2.0);

  /// 设置高度
  /// [height] 高度会自动适配，height 就是UI效果图上面标注的尺寸
  static double h(num height) => ScreenUtil().setHeight(height * 2.0);

  /// 设置字体大小
  /// [fontSize] 字体大小会自动适配，fontSize 就是UI效果图上面标注的大小
  static double ft(num fontSize) => ScreenUtil().setSp(fontSize * 2.0);
}

class UiUtil {
  ///获取顶部的边框
  static double getTop(BuildContext context) {
    double top = MediaQuery.of(context).padding.top;
    if (Platform.isIOS) {
      return top;
    }
    return top + 5;
  }

  ///获取颜色值
  static Color hexToColor(String s) {
    try {
      // 如果传入的十六进制颜色值不符合要求，返回默认值
      if (s == null ||
          s.length != 7 ||
          int.tryParse(s.substring(1, 7), radix: 16) == null) {
        s = '#999999';
      }
      return new Color(int.parse(s.substring(1, 7), radix: 16) + 0xFF000000);
    } catch (exc) {
      return Colors.transparent;
    }
  }

  static String constructTime(int seconds) {
    int day = seconds ~/ 3600 ~/ 24;
    String dayStr = day.toString();
    if (day < 10) {
      dayStr = "0" + dayStr;
    }
    int hour = seconds ~/ 3600;
    String hourStr = hour.toString();
    if (hour < 10) {
      hourStr = "0" + dayStr;
    }
    int minute = seconds % 3600 ~/ 60;
    String minuteStr = minute.toString();
    if (minute < 10) {
      minuteStr = "0" + minuteStr;
    }

    int second = seconds % 60;
    String secondStr = second.toString();
    if (second < 10) {
      secondStr = "0" + secondStr;
    }

    if (day != 0) {
      return '$dayStr天$hourStr小时$minuteStr分$secondStr秒';
    } else if (hour != 0) {
      return '$hourStr小时$minuteStr分$secondStr秒';
    } else if (minute != 0) {
      return '$minuteStr分$secondStr秒';
    } else if (second != 0) {
      return '$secondStr秒';
    } else {
      return '';
    }
  }
}
