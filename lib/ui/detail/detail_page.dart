import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/mode/data_all.dart';
import '../../util/ui_util.dart';
import '../../widgets/comment_view.dart';
import '../../widgets/info_view.dart';
import '../../widgets/tech_detail_widgets.dart';
import '../../widgets/views/video_cover_view.dart';
import 'detail_controller.dart';

class DetailPage extends GetView<DetailController> {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;
    final DataAll item = arguments['item'];
    final String page = arguments['page'];

    final picture1 = item.picture1 ?? '';
    final region = item.region ?? '';

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
                  automaticallyImplyLeading: false,
                  title: Padding(
                    padding: EdgeInsets.symmetric(horizontal: ASize.w(2)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GlassIconButton(
                          icon: Icons.arrow_back_ios,
                          iconSize: 16,
                          onTap: () => Get.back(),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              controller.item!.name!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontFamily: "PingFangSC",
                                fontStyle: FontStyle.normal,
                                fontSize: ASize.ft(9),
                                shadows: const [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GlassIconButton(
                          icon: Icons.search,
                          iconSize: 17,
                          onTap: () => controller.goToWebView(),
                        ),
                      ],
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Positioned.fill(
                          child: VideoCoverView(
                            cover: picture1,
                            money: region,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.25),
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.45),
                                  Colors.black.withValues(alpha: 0.85),
                                ],
                                stops: const [0, 0.35, 0.65, 1],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EFEE),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TabBar(
                              isScrollable: true,
                              indicatorColor: const Color(0xFF49368C),
                              labelColor: const Color(0xFF49368C),
                              unselectedLabelColor: const Color(0xFFB0B0B0),
                              tabAlignment: TabAlignment.start,
                              indicatorWeight: 2.5,
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: ASize.ft(8),
                                fontFamily: "PingFangSC",
                              ),
                              unselectedLabelStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: ASize.ft(8),
                                fontFamily: "PingFangSC",
                              ),
                              tabs: controller.subTitle,
                              controller: controller.tabInfoController,
                              padding: const EdgeInsets.only(left: 8),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: ASize.w(4)),
                            child: GradientPillButton(
                              text: page == 'want' ? '刪除想去名單' : '加入想去名單',
                              isDelete: page == 'want',
                              onTap: () {
                                if (page == 'want') {
                                  controller.deleteWantGo(context);
                                } else {
                                  controller.saveWantGo(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: Container(
                    color: const Color(0xFFF0EFEE),
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
        }));
  }
}
