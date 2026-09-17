import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:travel/ui/want/want_controller.dart';
import 'package:travel/widgets/money_text_widget_no_padding.dart';
import 'package:travel/widgets/views/video_cover_view.dart';

import '../data/mode/data_all.dart';
import '../util/ui_util.dart';
import 'comment_error.dart';

class GridViewAllHistory extends StatelessWidget {
  final WantController controller = Get.find<WantController>();

  GridViewAllHistory({super.key});

  /// 名稱欄半透明背景（重用同一個實例，避免每個 item 重建）
  static const BoxDecoration _nameBackdrop = BoxDecoration(
    color: Color(0x809E9E9E), // grey 500 @ 50%
  );

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
                      // 資料不足一屏時仍可下拉刷新
                      physics: const AlwaysScrollableScrollPhysics(),
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
                                      decoration: _nameBackdrop,
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
              : const Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.all(50.0),
                        child: CommentError(),
                      ),
                    ),
                  ],
                ),
    );
  }
}
