import 'dart:ui';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../data/mode/data_all.dart';

class CustomWebViewController extends GetxController {
  final item = Get.arguments as DataAll;
  late WebViewController webViewController;

  @override
  void onInit() {
    super.onInit();
    initWebView();
  }

  /// WebView 設定
  void initWebView() {
    late final PlatformWebViewControllerCreationParams params;
    params = const PlatformWebViewControllerCreationParams();
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse('https://www.google.com/search?q=${item.title}'));

    webViewController = controller;
  }
}
