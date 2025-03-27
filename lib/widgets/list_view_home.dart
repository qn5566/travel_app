import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:travel/widgets/views/video_cover_view.dart';

import '../config/global_config.dart';
import '../data/mode/data_all.dart';
import '../ui/home/home_controller.dart';
import '../util/ui_util.dart';
import 'comment_error.dart';
import 'money_text_widget.dart';

class ListViewHome extends StatelessWidget {
  ListViewHome({Key? key, required this.site}) : super(key: key);
  final String site;
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    controller.searchData(site);
    return Obx(
      () => controller.firstLoading.value
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/car.json'),
                const Text(
                  '第一次下載會比較久請稍等..',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            )
          : controller.isLoading.value
              ? Lottie.asset('assets/loading.json')
              : (controller.dataList.isNotEmpty)
                  ? MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView.builder(
                        itemCount: controller.dataList.length,
                        itemBuilder: (context, index) {
                          DataAll item = controller.dataList[index];
                          return GestureDetector(
                            onTap: () {
                              controller.onTap(item);
                            },
                            child: Container(
                              color: Colors.white,
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
                                        top: ASize.w(1), left: ASize.w(3)),
                                    child: Text(
                                      item.name!,
                                      style: TextStyle(
                                        color: Colors.black,
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
                                          color: Colors.grey,
                                        ),
                                        Expanded(
                                          child: Text(
                                            item.address ?? emptyData,
                                            style: TextStyle(
                                              color: Colors.grey,
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
