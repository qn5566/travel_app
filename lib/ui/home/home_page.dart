import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

import '../../config/global_config.dart';
import '../../config/style_info.dart';
import '../../util/ui_util.dart';
import '../../widgets/gird_view_home.dart';
import '../../widgets/tech_detail_widgets.dart';
import '../../widgets/tech_travel_background.dart';
import '../../widgets/views/RankingListItem.dart';
import 'home_controller.dart';

/*
首頁頁面
 */
class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  static TextStyle leftTextHello = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontFamily: "PingFangSC",
    fontStyle: FontStyle.normal,
    fontSize: ASize.ft(12),
  );

  static TextStyle leftText = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontFamily: "PingFangSC",
    fontStyle: FontStyle.normal,
    fontSize: ASize.ft(8),
  );

  @override
  Widget build(BuildContext context) {
    if (sharedPreferences.getString(AppConstants.userName) != null) {
      controller.username.value =
          sharedPreferences.getString(AppConstants.userName)!;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Stack(
            children: [
              const Positioned.fill(child: TechTravelBackground()),
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x66040D1D),
                        Color(0xAA101342),
                        Color(0xCC050B1A),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      _navigationBar(context),
                      Obx(() {
                        if (controller.dataListCommentModel.isNotEmpty) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.03,
                            color: Colors.black.withValues(alpha: 0.35),
                            child: Marquee(
                              text: controller.dataListCommentModel
                                  .map((comment) =>
                                      " ${comment.titleName!}-${comment.comment ?? ''}@${comment.username ?? ''} ")
                                  .join('   '),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              scrollAxis: Axis.horizontal,
                              blankSpace: 20.0,
                              velocity: 20.0,
                              pauseAfterRound: const Duration(seconds: 1),
                              startPadding: 10.0,
                              accelerationDuration: const Duration(seconds: 2),
                              accelerationCurve: Curves.linear,
                              decelerationDuration:
                                  const Duration(milliseconds: 1),
                              decelerationCurve: Curves.easeOut,
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                      Expanded(
                        child: _contentView(),
                      )
                    ],
                  ),
                ),
              ),
              const Positioned(
                right: 0,
                bottom: 20,
                height: 50,
                width: 10,
                child: SizedBox.shrink(),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 90, right: 16, top: 16),
                  child: GradientPillButton(
                    text: '熱門景點',
                    onTap: () => showRankingDialog(context),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 90, left: 16, top: 16),
                  child: InkWell(
                    onTap: () async {
                      controller.rotateIcon();
                      controller.randomData();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          width: ASize.w(16),
                          height: ASize.h(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xD9162940),
                                Color(0xD90C1327),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: const Color(0x6655E6FF)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x44000000),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Obx(() {
                            const iconColor = Color(0xFF8CF3FF);
                            if (controller.animationInit.value) {
                              return RotationTransition(
                                turns: controller.animation!,
                                child: Icon(
                                  Icons.refresh,
                                  color: iconColor,
                                ),
                              );
                            } else {
                              return Icon(
                                Icons.refresh,
                                color: iconColor,
                              );
                            }
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 中間內容
  Widget _contentView() {
    return Column(
      children: [
        SizedBox(
          height: ASize.w(18),
          child: TabBar(
            padding: EdgeInsets.zero,
            tabs: controller.userData.travelTitle
                .map((e) => Container(
                      constraints: const BoxConstraints(minWidth: 0),
                      child: Tab(text: e),
                    ))
                .toList(),
            controller: controller.tabTitleController,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicatorColor: const Color(0xFF55E6FF),
            indicatorWeight: 2.5,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            unselectedLabelStyle: TextStyle(
              fontSize: ASize.ft(6),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              color: Colors.white54,
            ),
            labelStyle: TextStyle(
              fontSize: ASize.ft(8),
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller.tabTitleController,
            physics: const NeverScrollableScrollPhysics(),
            children: controller.userData.travelTitle.map((e) {
              return GridViewHome(site: e);
            }).toList(),
          ),
        )
      ],
    );
  }

  /// 导航条
  Widget _navigationBar(BuildContext context) {
    double topMargin = ScreenUtil().statusBarHeight;
    double navigationBarHeight = 50.0;
    return Container(
      height: topMargin + navigationBarHeight,
      color: Colors.transparent,
      child: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          _buildSearchBar(context, '請輸入關鍵字', height: navigationBarHeight)
        ],
      ),
    );
  }

  /// 搜索欄
  Widget _buildSearchBar(BuildContext context, String placeholderText,
      {required double height}) {
    return Container(
      height: height,
      color: Colors.transparent,
      child: Row(
        children: [
          Obx(() => GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: ASize.w(5),
                    left: ASize.w(5),
                  ),
                  child: SizedBox(
                    height: ASize.h(16),
                    child: Center(
                      child: Text("清除",
                          style: TextStyle(
                              color: (controller.keywords.value.isNotEmpty)
                                  ? Colors.redAccent
                                  : Colors.white54,
                              fontWeight: FontWeight.w700,
                              fontFamily: "PingFang-SC",
                              fontStyle: FontStyle.normal,
                              fontSize: ASize.ft(7),
                              shadows: const [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 2,
                                ),
                              ])),
                    ),
                  ),
                ),
                onTap: () {
                  controller.messageController.text = "";
                  controller.keywords.value = "";
                  controller.searchDataRegion(controller.keywords.value);
                },
              )),
          Expanded(
            child: Container(
              height: ASize.w(16),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 5,
                    ),
                    child: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: CupertinoTextField(
                      controller: controller.messageController,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      maxLength: 10,
                      placeholder: placeholderText,
                      placeholderStyle: TextStyle(
                          fontSize: ASize.ft(6),
                          fontWeight: FontWeight.normal,
                          color: Colors.black54),
                      decoration:
                          const BoxDecoration(color: Colors.transparent),
                      onChanged: (value) {
                        controller.keywords.value = value;
                        if (kDebugMode) {
                          print('keywords:${controller.keywords.value}');
                        }
                      },
                      onSubmitted: (value) {
                        if (controller.keywords.value.isNotEmpty) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          controller
                              .searchDataRegion(controller.keywords.value);
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: ASize.w(2),
                      ),
                      child: Container(
                        height: ASize.h(12),
                        padding: EdgeInsets.symmetric(horizontal: ASize.w(5)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ASize.w(5)),
                          color: StyleInfo.searchTextHomeHitOne,
                        ),
                        child: Center(
                          child: Text(controller.userData.keyWordTravel[0],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "PingFang-SC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: ASize.ft(7))),
                        ),
                      ),
                    ),
                    onTap: () {
                      String text = controller.userData.keyWordTravel[0];
                      controller.messageController.text = text;
                      controller.keywords.value = text;
                      controller.searchDataRegion(text);
                    },
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: ASize.w(2),
                      ),
                      child: Container(
                        height: ASize.h(12),
                        padding: EdgeInsets.symmetric(horizontal: ASize.w(5)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ASize.w(5)),
                          color: StyleInfo.searchTextHomeHitTwo,
                        ),
                        child: Center(
                          child: Text(controller.userData.keyWordTravel[1],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "PingFang-SC",
                                  fontStyle: FontStyle.normal,
                                  fontSize: ASize.ft(7))),
                        ),
                      ),
                    ),
                    onTap: () {
                      String text = controller.userData.keyWordTravel[1];
                      controller.messageController.text = text;
                      controller.keywords.value = text;
                      controller.searchDataRegion(text);
                    },
                  ),
                ],
              ),
            ),
          ),
          Obx(() => GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: ASize.w(5),
                    left: ASize.w(5),
                  ),
                  child: SizedBox(
                    height: ASize.h(16),
                    child: Center(
                      child: Text("搜索",
                          style: TextStyle(
                              color: (controller.keywords.value.isNotEmpty)
                                  ? Colors.white
                                  : Colors.white54,
                              fontWeight: FontWeight.w700,
                              fontFamily: "PingFang-SC",
                              fontStyle: FontStyle.normal,
                              fontSize: ASize.ft(7),
                              shadows: const [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 2,
                                ),
                              ])),
                    ),
                  ),
                ),
                onTap: () {
                  if (controller.keywords.value.isNotEmpty) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    controller.searchDataRegion(controller.keywords.value);
                  }
                },
              ))
        ],
      ),
    );
  }

  /// 顯示排行榜對話框
  void showRankingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events_rounded, color: Color(0xFFFFD700), size: 24),
              SizedBox(width: 8),
              Text(
                '熱門景點排行',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // 使用 Container 讓高度能根據內容自適應，並設定最大高度防止溢出
          content: Container(
            width: double.maxFinite,
            constraints: BoxConstraints(
              maxHeight: ASize.h(400),
            ),
            child: Obx(() {
              if (controller.dataListHistory.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    '暫無排行資料',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                itemCount: controller.dataListHistory.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final history = controller.dataListHistory[index];
                  return RankingListItem(
                    history: history,
                    rankIndex: index,
                  );
                },
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '關閉',
                style: TextStyle(
                  color: Colors.white, // 👉 修改這裡：改為純白色以適應深色背景
                  fontWeight: FontWeight.bold, // 加上粗體讓按鈕更清晰
                  fontSize: 16, // 稍微把字體放大一點點
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
