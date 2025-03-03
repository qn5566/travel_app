import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

import '../../config/global_config.dart';
import '../../config/style_info.dart';
import '../../data/mode/data_all.dart';
import '../../data/mode/history_model.dart';
import '../../routes/app_routes.dart';
import '../../util/ui_util.dart';
import '../../widgets/gird_view_home.dart';
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
    // backgroundColor: const Color(0xFF0E3311).withOpacity(0.5),
  );

  static TextStyle leftText = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontFamily: "PingFangSC",
    fontStyle: FontStyle.normal,
    fontSize: ASize.ft(8),
    // backgroundColor: const Color(0xFF0E3311).withOpacity(0.5),
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
        // key: controller.scaffoldKey,
        body: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'images/home/home_bg.webp',
                  fit: BoxFit.cover,
                ),
              ),
              // 毛玻璃效果 - 半透明
              Container(
                color: StyleInfo.assistColor.withOpacity(0.5),
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
                            color: Colors.black.withOpacity(0.1),
                            child: Marquee(
                              text: controller.dataListCommentModel
                                  .map((comment) =>
                                      "${comment.titleName!}-${comment.comment ?? ''}@${comment.username ?? ''}")
                                  .join('   '),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
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
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // 設置圓角
                      ),
                    ),
                    onPressed: () {
                      showRankingDialog(context);
                    },
                    child: const Text('熱門景點',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: InkWell(
                    onTap: () async {
                      // await controller.fetchApi();
                      controller.rotateIcon();
                      controller.randomData();
                    },
                    child: Container(
                      width: ASize.w(16),
                      height: ASize.h(16),
                      decoration: BoxDecoration(
                        color: StyleInfo.settingButtonColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Obx(() {
                        if (controller.animation != null) {
                          return RotationTransition(
                            turns: controller.animation!,
                            child: const Icon(
                              Icons.refresh,
                              color: StyleInfo.settingTextColor,
                            ),
                          );
                        } else {
                          return const Icon(
                            Icons.refresh,
                            color: StyleInfo.settingTextColor,
                          );
                        }
                      }),
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
            // 關閉內邊距
            tabs: controller.userData.travelTitle
                .map((e) => Container(
                      constraints: const BoxConstraints(minWidth: 0), // 避免內建間距
                      child: Tab(text: e),
                    ))
                .toList(),
            controller: controller.tabTitleController,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 2,
            labelColor: Colors.white,
            unselectedLabelStyle: TextStyle(
              fontSize: ASize.ft(6),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              color: Colors.black,
            ),
            labelStyle: TextStyle(
              fontSize: ASize.ft(8),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller.tabTitleController,
            physics: const NeverScrollableScrollPhysics(), // 禁用滑動
            children: controller.userData.travelTitle.map((e) {
              return GridViewHome(site: e); // 使用 GridViewHome
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
                                  : Colors.black,
                              fontWeight: FontWeight.w700,
                              fontFamily: "PingFang-SC",
                              fontStyle: FontStyle.normal,
                              fontSize: ASize.ft(7))),
                    ),
                  ),
                ),
                onTap: () {
                  controller.messageController.text = "";
                  controller.keywords.value = "";
                  // 搜索
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
                          color: Colors.black),
                      decoration:
                          const BoxDecoration(color: Colors.transparent),
                      onChanged: (value) {
                        controller.keywords.value = value;
                        if (kDebugMode) {
                          print('keywords:${controller.keywords.value}');
                        }
                      },
                      onSubmitted: (value) {
                        // 在這裡執行搜尋的操作
                        if (controller.keywords.value.isNotEmpty) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          // 搜索
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
                                  : StyleInfo.gray_7C7C8D,
                              fontWeight: FontWeight.w700,
                              fontFamily: "PingFang-SC",
                              fontStyle: FontStyle.normal,
                              fontSize: ASize.ft(7))),
                    ),
                  ),
                ),
                onTap: () {
                  if (controller.keywords.value.isNotEmpty) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    // 搜索
                    controller.searchDataRegion(controller.keywords.value);
                  }
                },
              ))
        ],
      ),
    );
  }

  /// 顯示排行榜
  void showRankingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('點擊次數最高的景點', textAlign: TextAlign.center),
          content: SizedBox(
            height: ASize.h(150), // Adjust the height as needed
            width: double.maxFinite,
            child: Obx(() {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.dataListHistory.length,
                itemBuilder: (context, index) {
                  HistoryModel history = controller.dataListHistory[index];
                  return ListTile(
                    title: Text(
                      '${history.title}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '點擊次數: ${history.value}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    leading: CircleAvatar(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      /// 直接跳轉搜尋頁面
                      DataAll data = DataAll(
                        name: history.title,
                      );
                      Get.toNamed(AppRoutes.webViewPage, arguments: data);
                    },
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }
}
