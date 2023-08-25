import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/global_config.dart';
import '../../config/style_info.dart';
import '../../util/ui_util.dart';
import '../../widgets/list_view_home.dart';
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
        key: controller.scaffoldKey,
        body: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'images/home/home_bg.png',
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
        Padding(padding: EdgeInsets.only(top: ASize.w(0))),
        SizedBox(
          height: ASize.w(18),
          child: TabBar(
            tabs: controller.userData.travelTitle
                .map((e) => Tab(text: e))
                .toList(),
            controller: controller.tabTitleController,
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 2,
            labelColor: Colors.white,
            unselectedLabelStyle: TextStyle(
              fontSize: ASize.ft(6),
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
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
              return ListViewHome(site: e);
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
}
