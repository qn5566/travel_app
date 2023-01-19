import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/style_info.dart';
import '../../util/ui_util.dart';
import '../../widgets/list_view_home.dart';
import 'home_controller.dart';

/*
首頁頁面
 */
class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          color: StyleInfo.main_bg,
          child: Stack(
            children: [
              _backgroundImageView(height: 300),
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
            // indicator: ACETabBarIndicator(
            //   type: ACETabBarIndicatorType.runderline_fixed,
            //   height: ASize.w(8),
            //   lineWidth: ASize.w(15),
            //   color: Colors.white,
            // ),
            // indicatorSize: Custom.TabBarIndicatorSize.label,
            indicatorWeight: 2,
            // unselectedLabelColor: StyleInfo.white_07,
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
            // children: [
            //   ListViewHome(site:controller.getTabTitle[0]),
            //   ListViewHome(site:controller.getTabTitle[1]),
            // ],
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
          _searchBar('请输入关键词', height: navigationBarHeight)
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
          _buildNavigationItem('签到', 'images/home/home_sign_in.png', onTap: () {
            // SignInAlertController.showAlert(context);
          }),
          Expanded(
            child: GestureDetector(
              child: Container(
                height: ASize.w(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(ASize.w(26))),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Image.asset(
                        'images/home/home_search.png',
                        width: ASize.w(10),
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
                // JDRoute.openSearch(
                //     type: _currentIndexType(_tabController.index));
              },
            ),
          ),
          _buildNavigationItem('分类', 'images/home/tag_list.png', onTap: () {
            // Navigator.push(
            //     context,
            //     CupertinoPageRoute(
            //         builder: (_) => HomeCategoryPage(
            //             _currentIndexType(_tabController.index))));
          }),
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
              Image.asset(
                icon,
                width: ASize.w(12),
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
  Positioned _backgroundImageView({required double height}) => Positioned(
        top: 0,
        right: 0,
        left: 0,
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'images/home/home_top_bg.png',
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      );
}
