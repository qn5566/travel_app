import 'package:flutter/foundation.dart';

class RecommendAppModel {
  String? title;
  String? subtitle;
  String? image;
  double imageHeight = 50;
  String? url;
  String? androidUrl;
  String? iosUrl;

  RecommendAppModel({
    this.title,
    this.subtitle,
    this.image,
    this.imageHeight = 50,
    this.url,
    this.androidUrl,
    this.iosUrl,
  });

  RecommendAppModel.fromJson(Map<String, dynamic> json) {
    title = json['title']?.toString();
    subtitle = json['subtitle']?.toString();
    image = json['image']?.toString();
    imageHeight = (json['image_height'] is num)
        ? (json['image_height'] as num).toDouble()
        : 50.0;
    url = json['url']?.toString();
    androidUrl = json['android_url']?.toString();
    iosUrl = json['ios_url']?.toString();
  }

  /// 依平台解析要開啟的網址：優先使用通用 url，否則依平台選 android/ios url。
  String? launchUrlFor({TargetPlatform? platform}) {
    if (url != null && url!.trim().isNotEmpty) return url!.trim();
    final isIos = (platform ?? defaultTargetPlatform) == TargetPlatform.iOS;
    final target = isIos ? iosUrl : androidUrl;
    if (target != null && target.trim().isNotEmpty) return target.trim();
    return (iosUrl ?? androidUrl)?.trim();
  }
}
