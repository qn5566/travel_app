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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: EdgeInsets.only(left: ASize.w(5)),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(Get.arguments.title,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: "PingFangSC",
                            fontStyle: FontStyle.normal,
                            fontSize: ASize.ft(10),
                          )),
                      const SizedBox(width: 36.0),
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
                      //align at bottom center using Align()
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            color: Colors.black38,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                controller.item.picdescribe1!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "PingFangSC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: ASize.ft(7),
                                ),
                              ),
                            )),
                      ),
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
