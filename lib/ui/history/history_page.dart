import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel/ui/history/history_controller.dart';

import '../../util/ad_manager_util.dart';
import '../../util/ui_util.dart';
import '../../widgets/list_view_history_all.dart';
import '../../widgets/tech_travel_background.dart';

/*
設定頁面
*/
class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

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
                const Positioned.fill(child: TechTravelBackground()),
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x66040D1D),
                          Color(0xAA101342),
                          Color(0xCC050B1A),
                        ],
                      ),
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
                      child: ListViewAllHistory(),
                    ),
                  ],
                ),
              ],
            ),
            floatingActionButton: Obx(() => (controller.dataAllList.isNotEmpty)
                ? GestureDetector(
                    onTap: () => controller.deleteData(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF8B1A3B),
                            Color(0xFF4A0E2A),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFFFF5C8A).withOpacity(0.55)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF5C8A).withOpacity(0.18),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '刪除全部資料',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: "PingFangSC",
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    width: ASize.w(1),
                  ))),
      ),
    );
  }
}
