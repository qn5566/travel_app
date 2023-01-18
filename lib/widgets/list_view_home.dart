import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel/widgets/views/video_cover_view.dart';

import '../config/global_config.dart';
import '../data/mode/data_all.dart';
import '../ui/home/home_controller.dart';
import '../util/ui_util.dart';
import 'money_text_widget.dart';

class ListViewHome extends StatelessWidget {
  ListViewHome({Key? key, required this.site}) : super(key: key);
  final String site;
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    controller.searchData([site]);
    return Obx(() => controller.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: controller.dataList.length,
            itemBuilder: (context, index) {
              DataAll item = controller.dataList[index];
              return GestureDetector(
                onTap: () {
                  controller.onTap(item);
                },
                child: Container(
                  // color: Colors.transparent,
                  color: Colors.black38,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 1.7777777,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: VideoCoverView(
                                // radius: 10,
                                cover: item.picture1 ?? '',
                                money: item.region,
                              ),
                            ),
                            MoneytextWidget(item.region ?? "尚未資料")
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: ASize.w(1), left: ASize.w(1)),
                        child: Text(
                          item.title,
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
                        child: Text(
                          item.address ?? emptyData,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: ASize.ft(6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ));
  }
}
