import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../util/ui_util.dart';
import '../../widgets/comment_view.dart';
import '../../widgets/info_view.dart';
import '../../widgets/money_text_widget.dart';
import '../../widgets/views/video_cover_view.dart';
import 'detail_controller.dart';

class DetailPage extends GetView<DetailController> {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return Scaffold(
          body: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  //标题栏
                  padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: ASize.w(10),
                            top: ASize.w(10),
                            bottom: ASize.w(10),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(Get.arguments.title),
                    ],
                  ),
                ),
                AspectRatio(
                  aspectRatio: 1.2,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: VideoCoverView(
                          // radius: 10,
                          cover: Get.arguments.picture1 ?? '',
                          money: Get.arguments.region,
                        ),
                      ),
                      MoneytextWidget(Get.arguments.region ?? "尚未資料"),
                    ],
                  ),
                ),
                TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.black,
                  labelColor: Colors.red,
                  unselectedLabelColor: Colors.grey,
                  indicatorWeight: 2.5,
                  tabs: controller.subTitle,
                  controller: controller.tabInfoController,
                ),
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: TabBarView(
                      controller: controller.tabInfoController,
                      children: [
                        InfoView(),
                        CommentView(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
