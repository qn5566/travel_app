import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel/ui/map/map_page.dart';

import '../account/account_page.dart';
import '../home/home_page.dart';
import 'dashboard_controller.dart';

/*
APP TableView Page router
 */
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  /// 頁面設定
  static List<Widget> pages = [
    const MapPage(),
    const HomePage(),
    const AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            return false; // 阻止返回
          },
          child: Scaffold(
            body: pages[controller.tabIndex],
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: Colors.white,
              selectedItemColor: const Color(0xFFffd9d9),
              onTap: controller.changeTabIndex,
              currentIndex: controller.tabIndex,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              backgroundColor: const Color(0xFF439D98),
              elevation: 0,
              items: [
                _bottomNavigationBarItem(
                  icon: CupertinoIcons.arrow_branch,
                  label: '附近',
                ),
                _bottomNavigationBarItem(
                  icon: CupertinoIcons.home,
                  label: '景點',
                ),
                _bottomNavigationBarItem(
                  icon: CupertinoIcons.person,
                  label: '設定',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _bottomNavigationBarItem({required IconData icon, required String label}) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
