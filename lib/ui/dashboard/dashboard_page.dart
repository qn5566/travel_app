import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel/ui/map/map_page.dart';
import 'package:travel/ui/want/want_page.dart';

import '../account/account_page.dart';
import '../history/history_page.dart';
import '../home/home_page.dart';
import '../../widgets/tech_tab_bar.dart';
import 'dashboard_controller.dart';

/*
APP TableView Page router
 */
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static bool _isExitDialogShowing = false;

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
        return PopScope<void>(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop || _isExitDialogShowing) return;
            _showExitConfirmationDialog(context);
          },
          child: Scaffold(
            body: Stack(
              children: [
                IndexedStack(
                  index: controller.tabIndex,
                  children: pages,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TechTabBar(
                    currentIndex: controller.tabIndex,
                    onTap: controller.changeTabIndex,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      assignId: true,
    );
  }

  /// 確認關閉的彈窗
  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    if (_isExitDialogShowing || !context.mounted) return;
    _isExitDialogShowing = true;
    try {
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('確定要離開嗎？'),
            actions: <Widget>[
              TextButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(false);
                },
              ),
              TextButton(
                child: const Text('確定'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(true);
                },
              ),
            ],
          );
        },
      );
      if (shouldExit == true) {
        await SystemNavigator.pop();
      }
    } finally {
      _isExitDialogShowing = false;
    }
  }
}
