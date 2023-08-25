import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:travel/config/style_info.dart';
import 'package:travel/ui/history/history_controller.dart';

import '../../util/ui_util.dart';
import '../../widgets/list_view_history_all.dart';

/*
設定頁面
*/
class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3, // number of tabs
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'images/setting/background_setting_2.png',
                    fit: BoxFit.fitHeight,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: ScreenUtil().statusBarHeight + 5.0),
                    Obx(() => (controller.isADShowing.value &&
                            controller.bannerAd != null)
                        ? Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              width: controller.bannerAd!.size.width.toDouble(),
                              height:
                                  controller.bannerAd!.size.height.toDouble(),
                              child: AdWidget(ad: controller.bannerAd!),
                            ),
                          )
                        : SizedBox(
                            height: ASize.h(0),
                          )),
                    SizedBox(
                      height: ASize.h(5),
                    ),
                    Expanded(
                      child: ListViewAllHistory(),
                    ),
                  ],
                ),
              ],
            ),
            floatingActionButton: Obx(() => (controller.dataAllList.isNotEmpty)
                ? FloatingActionButton.extended(
                    onPressed: () {
                      controller.deleteData();
                    },
                    backgroundColor: StyleInfo.deleteButton,
                    label: const Text(
                      '刪除全部資料',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : SizedBox(
                    width: ASize.w(1),
                  ))),
      ),
    );
  }
}
