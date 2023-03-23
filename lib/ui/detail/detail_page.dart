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
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                // backgroundColor: Colors.green,
                expandedHeight: ScreenUtil().setHeight(ASize.h(140)),
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: AspectRatio(
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
                        Column(
                          children: [
                            Padding(
                              //标题栏
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().statusBarHeight,
                                  right: ASize.w(5)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.back();
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: ASize.w(5)),
                                      child: const Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.black38,
                                    constraints:
                                        BoxConstraints(maxWidth: ASize.w(130)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(controller.item.name!,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "PingFangSC",
                                            fontStyle: FontStyle.normal,
                                            fontSize: ASize.ft(10),
                                          )),
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        controller.goToWebView();
                                      },
                                      child: const Icon(Icons.more_vert)
                                      // const Text("更多"),
                                      )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(20.0),
                  child: Container(
                    color: Colors.black38,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TabBar(
                            isScrollable: true,
                            indicatorColor: Colors.white,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.grey,
                            indicatorWeight: 1.0,
                            tabs: controller.subTitle,
                            controller: controller.tabInfoController,
                          ),
                        ]),
                  ),
                ),
              ),
              SliverFillRemaining(
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
        );
      }),
    );
  }
}
