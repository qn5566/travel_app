import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/global_config.dart';
import '../../util/ui_util.dart';
import '../../widgets/list_view_home.dart';
import '../dashboard/dashboard_controller.dart';
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
    DashboardController dashboardController = Get.find<DashboardController>();
    if (sharedPreferences.getString("username") != null) {
      controller.username.value = sharedPreferences.getString("username")!;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        key: controller.scaffoldKey,
        drawer: Drawer(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/home/background_left.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Obx(() => (controller.username.value.isEmpty)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Hello!", style: leftTextHello),
                                  SizedBox(height: ASize.h(10)),
                                  Text(
                                    "請先去設定頁面填入暱稱", style: leftText,
                                    maxLines: 2, // 最多顯示兩行
                                    overflow:
                                        TextOverflow.ellipsis, // 超出部分使用省略號替代
                                    softWrap: true, // 超出寬度時自動換行
                                  ),
                                  SizedBox(height: ASize.h(5)),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Hello!", style: leftText),
                                  SizedBox(height: ASize.h(20)),
                                  Text(controller.username.value,
                                      style: leftText),
                                ],
                              )),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Divider(
                          color: Colors.white,
                          thickness: 2,
                        ),
                      ),
                      ListTile(
                        title: Text('景點', style: leftText),
                        onTap: () {
                          dashboardController.changeTabIndex(0);
                          return controller.closeDrawer();
                        },
                      ),
                      ListTile(
                        title: Text('設定', style: leftText),
                        onTap: () {
                          dashboardController.changeTabIndex(1);
                          return controller.closeDrawer();
                        },
                      )
                    ],
                  ),
                ),
                const Text(
                  '資料來源',
                  style: TextStyle(color: Colors.white),
                ),
                const Text('政府資料開放平臺', style: TextStyle(color: Colors.white)),
                Text('版本:${controller.getAppVersion()}',
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(
                  height: 2,
                )
              ],
            ),
          ),
        ),
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
                color: const Color(0xFF0E3311).withOpacity(0.5),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      _navigationBar(),
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
            tabs: controller.getTabTitle.map((e) => Tab(text: e)).toList(),
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
            children: controller.getTabTitle.map((e) {
              return ListViewHome(site: e);
            }).toList(),
          ),
        )
      ],
    );
  }

  /// 导航条
  Widget _navigationBar() {
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
          _searchBar('請輸入關鍵字', height: navigationBarHeight)
        ],
      ),
    );
  }

  /// 搜索栏
  Widget _searchBar(String placeholderText, {required double height}) {
    return Container(
      height: height,
      color: Colors.transparent,
      child: Row(
        children: [
          _buildNavigationItem('選單', 'images/home/home_sign_in.png', onTap: () {
            controller.openDrawer();
          }),
          Expanded(
            child: GestureDetector(
              child: Container(
                height: ASize.w(16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Icon(
                        Icons.search,
                        color: Colors.black38,
                      ),
                    ),
                    Text(
                      placeholderText,
                      style: TextStyle(
                        fontSize: ASize.ft(6),
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.26),
                      ),
                    )
                  ],
                ),
              ),
              onTap: () {
                controller.toSearch();
              },
            ),
          ),
          SizedBox(
            width: ASize.w(20),
          )
        ],
      ),
    );
  }

  /// 构建导航栏左右的按钮
  /// [title] 按钮标题
  /// [icon] 按钮的图片
  /// [onTap] 点击事件的回调
  Widget _buildNavigationItem(String title, String icon,
          {required VoidCallback onTap}) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: SizedBox(
          width: 50,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              SizedBox(
                height: ASize.ft(0),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: ASize.ft(5),
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );

  /// 毛玻璃背景(不需要毛玻璃了)
  /// [height] 图片高度
  /// https://www.jianshu.com/p/381c6609c5f1
  Positioned _backgroundImageView({double height = 0}) => Positioned.fill(
        child: Image.asset(
          'images/home/home_bg.jpg',
          fit: BoxFit.fill,
        ),
      );
}
