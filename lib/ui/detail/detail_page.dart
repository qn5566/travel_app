import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/mode/data_all.dart';
import '../../util/ui_util.dart';
import '../../widgets/comment_view.dart';
import '../../widgets/info_view.dart';
import '../../widgets/tech_detail_widgets.dart';
import '../../widgets/views/image_slider_view.dart';
import 'detail_controller.dart';

class DetailPage extends GetView<DetailController> {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;
    final DataAll item = arguments['item'];
    final String page = arguments['page'];

    final imageUrls = item.imageUrls;
    final region = item.region ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF060B18),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: const Color(0xFF060B18),
              expandedHeight: ScreenUtil().setHeight(ASize.h(240)),
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
                      child: ImageSliderView(
                        urls: imageUrls,
                        money: region,
                      ),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(76),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xE60C1327),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0x3355E6FF)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF55E6FF).withValues(alpha: 0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                      const BoxShadow(
                        color: Color(0x55000000),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (region.isNotEmpty) ...[
                        _RegionChip(region: region),
                        const SizedBox(width: 12),
                        Container(
                          width: 1,
                          height: 20,
                          color: const Color(0x3355E6FF),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: TabBar(
                          controller: controller.tabInfoController,
                          tabs: controller.subTitle,
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF19687B), Color(0xFF7C5CFF)],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFF55E6FF)
                                  .withValues(alpha: 0.5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF55E6FF)
                                    .withValues(alpha: 0.28),
                                blurRadius: 14,
                              ),
                            ],
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: const Color(0xFF8FA3B8),
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            fontFamily: "PingFangSC",
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            fontFamily: "PingFangSC",
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GradientPillButton(
                        text: page == 'want' ? '刪除想去名單' : '加入想去名單',
                        isDelete: page == 'want',
                        showText: false,
                        onTap: () {
                          if (page == 'want') {
                            controller.deleteWantGo(context);
                          } else {
                            controller.saveWantGo(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: Container(
                color: Colors.transparent,
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
  }
}

/// 顯示地區名稱的小標籤，會與下方資訊 bar 一起 pinned 滑動。
class _RegionChip extends StatelessWidget {
  const _RegionChip({required this.region});

  final String region;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.location_on_rounded,
          color: Color(0xFF55E6FF),
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          region,
          style: const TextStyle(
            color: Color(0xFFEAF3FF),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: "PingFangSC",
          ),
        ),
      ],
    );
  }
}
