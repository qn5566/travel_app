import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:travel/ui/history/history_controller.dart';
import 'package:travel/widgets/views/video_cover_view.dart';

import '../config/global_config.dart';
import '../data/mode/data_all.dart';
import '../util/ui_util.dart';
import 'comment_error.dart';
import 'money_text_widget.dart';

class ListViewAllHistory extends StatelessWidget {
  final HistoryController controller = Get.find<HistoryController>();

  ListViewAllHistory({super.key});

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
                    color: const Color(0xFF55E6FF),
                    backgroundColor: const Color(0xFF0C1327),
                    onRefresh: () async {
                      controller.reload();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 120),
                      itemCount: controller.dataAllList.length,
                      itemBuilder: (context, index) {
                        DataAll item = controller.dataAllList[index];
                        return GestureDetector(
                          onTap: () {
                            controller.onTapDataAll(item);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: ASize.w(4),
                                right: ASize.w(4),
                                bottom: ASize.h(4)),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xD9162940),
                                  Color(0xD90C1327),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0x6655E6FF)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x44000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1.7777777,
                                  child: Stack(
                                    children: [
                                      VideoCoverView(
                                        // radius: 10,
                                        cover: item.picture1 ?? '',
                                        money: item.region,
                                      ),
                                      MoneytextWidget(item.region ?? "尚未資料")
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: ASize.w(1), left: ASize.w(1)),
                                  child: Text(
                                    item.name!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "PingFangSC",
                                      fontStyle: FontStyle.normal,
                                      fontSize: ASize.ft(8),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: ASize.w(1),
                                      left: ASize.w(1),
                                      bottom: ASize.w(4)),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.place_outlined,
                                        color: Color(0xFF8CF3FF),
                                        size: 14,
                                      ),
                                      Expanded(
                                        child: Text(
                                          item.address ?? emptyData,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "PingFangSC",
                                            fontStyle: FontStyle.normal,
                                            fontSize: ASize.ft(6),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                        ),
                                      ),
                                    ],
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
                        child: CommentError(textColor: Colors.white),
                      ),
                    ),
                  ],
                ),
    );
  }
}
