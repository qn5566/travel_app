import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/info_view.dart';
import '../../widgets/money_text_widget.dart';
import '../../widgets/views/video_cover_view.dart';
import 'detail_controller.dart';

class DetailPage extends GetView<DetailController> {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(headerSliverBuilder:
            (BuildContext context, bool innerBoxIsScrolled) {
      return [
        SliverToBoxAdapter(
          child: AspectRatio(
            aspectRatio: 1.7777777,
            child: Stack(
              children: [
                Positioned.fill(
                  child: VideoCoverView(
                    radius: 10,
                    cover: Get.arguments.picture1 ?? '',
                    money: Get.arguments.region,
                  ),
                ),
                MoneytextWidget(Get.arguments.region ?? "尚未資料"),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: TabBar(
            isScrollable: true,
            indicatorColor: Colors.black,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
            indicatorWeight: 2.5,
            tabs: controller.subTitle,
            controller: controller.tabInfoController,
          ),
        ),
      ];
    }, body: Builder(builder: (BuildContext context) {
      return
        Container(
          color: Colors.black,
          child: TabBarView(
          controller: controller.tabInfoController,
          children: [
            InfoView(),
            InfoView(),
          ],
      ),
        );
    })));
  }
}
