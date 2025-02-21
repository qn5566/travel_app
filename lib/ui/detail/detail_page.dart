import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../util/ui_util.dart';
import '../../widgets/comment_view.dart';
import '../../widgets/info_view.dart';
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
                backgroundColor: Colors.transparent,
                expandedHeight: ScreenUtil().setHeight(ASize.h(200)),
                floating: false,
                pinned: true,
                snap: false,
                title: Container(
                  color: Colors.black38,
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
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: ASize.w(130)),
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
                          child: const Icon(Icons.search, color: Colors.white)
                          // const Text("更多"),
                          )
                    ],
                  ),
                ),
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
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(20.0),
                  child: Container(
                    color: Colors.black38,
                    child: TabBar(
                      isScrollable: true,
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      tabAlignment: TabAlignment.start,
                      indicatorWeight: 1.0,
                      tabs: controller.subTitle,
                      controller: controller.tabInfoController,
                      padding: EdgeInsets.zero,
                    ),
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
