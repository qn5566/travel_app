import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel/ui/webview/webview_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../util/ui_util.dart';

class CustomWebViewPage extends GetView<CustomWebViewController> {
  const CustomWebViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomWebViewController controller =
        Get.find<CustomWebViewController>();
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              //标题栏
              padding: EdgeInsets.only(
                  top: ScreenUtil().statusBarHeight, right: ASize.w(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.only(left: ASize.w(5)),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(Get.arguments.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontFamily: "PingFangSC",
                        fontStyle: FontStyle.normal,
                        fontSize: ASize.ft(10),
                      )),
                  const SizedBox(width: 36.0),
                ],
              ),
            ),
            Expanded(
                child: WebViewWidget(controller: controller.webViewController))
          ],
        ),
      ),
    );
  }
}
