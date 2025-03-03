import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:travel/ui/want/want_controller.dart';
import 'package:travel/widgets/money_text_widget_no_padding.dart';
import 'package:travel/widgets/views/video_cover_view.dart';

import '../data/mode/data_all.dart';
import '../util/ui_util.dart';

class GridViewAllHistory extends StatelessWidget {
  final WantController controller = Get.find<WantController>();

  GridViewAllHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? Lottie.asset('assets/loading.json')
          : (controller.dataAllList.isNotEmpty)
              ? MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      controller.reload();
                    },
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 3 列
                        childAspectRatio: 0.75, // 調整子項目比例
                      ),
                      itemCount: controller.dataAllList.length,
                      itemBuilder: (context, index) {
                        DataAll item = controller.dataAllList[index];
                        return GestureDetector(
                          onTap: () {
                            controller.onTapDataAll(item);
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Stack(
                                    children: [
                                      VideoCoverView(
                                        // radius: 10,
                                        cover: item.picture1 ?? '',
                                        money: item.region,
                                      ),
                                      MoneyTextWidgetNoPadding(
                                          item.region ?? "尚未資料")
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0, vertical: 2.0),
                                    child: Container(
                                      color: Colors.grey.withOpacity(0.5),
                                      child: Text(
                                        item.name!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: "PingFangSC",
                                          fontStyle: FontStyle.normal,
                                          fontSize: ASize.ft(6),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/icon/no_data_white.png',
                              fit: BoxFit.none,
                            ),
                            const Text('無資料'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
