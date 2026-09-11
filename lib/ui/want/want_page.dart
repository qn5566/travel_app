import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel/ui/want/want_controller.dart';

import '../../util/ad_manager_util.dart';
import '../../util/ui_util.dart';
import '../../widgets/grid_view_all_history.dart';

/*
設定頁面
*/
class WantPage extends GetView<WantController> {
  const WantPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.initData();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3, // number of tabs
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.5, // 設置透明度，0.0為完全透明，1.0為完全不透明
                    child: Image.asset(
                      'images/pics/land_1.webp',
                      fit: BoxFit.fitHeight,
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                    ),
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
                              child: AdManagerUtil()
                                  .bannerAdWidget(controller.bannerAd!),
                            ),
                          )
                        : SizedBox(
                            height: ASize.h(0),
                          )),
                    SizedBox(
                      height: ASize.h(5),
                    ),
                    Expanded(
                      child: GridViewAllHistory(),
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
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // 設置圓角弧度
                    ),
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
