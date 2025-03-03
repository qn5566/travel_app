import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel/ui/map/map_page.dart';
import 'package:travel/ui/want/want_page.dart';

import '../../config/style_info.dart';
import '../account/account_page.dart';
import '../history/history_page.dart';
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
    const WantPage(),
    const HistoryPage(),
    const AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            return await _showExitConfirmationDialog(context) ?? false;
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
              backgroundColor: StyleInfo.mainColor,
              elevation: 0,
              items: [
                _bottomNavigationBarItem(
                  icon: Icons.near_me_rounded,
                  label: '附近',
                ),
                _bottomNavigationBarItem(
                  icon: Icons.landscape,
                  label: '景點',
                ),
                _bottomNavigationBarItem(
                  icon: Icons.favorite,
                  label: '想要去',
                ),
                _bottomNavigationBarItem(
                  icon: Icons.history,
                  label: '歷史',
                ),
                _bottomNavigationBarItem(
                  icon: CupertinoIcons.chat_bubble,
                  label: '留言板',
                ),
              ],
            ),
          ),
        );
      },
      assignId: true,
    );
  }

  _bottomNavigationBarItem({required IconData icon, required String label}) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }

  /// 確認關閉的彈窗
  Future<bool?> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('確定要離開嗎？'),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // 关闭对话框，并返回false
              },
            ),
            TextButton(
              child: const Text('確定'),
              onPressed: () {
                SystemNavigator.pop(); // 关闭应用程序
              },
            ),
          ],
        );
      },
    );
  }
}
