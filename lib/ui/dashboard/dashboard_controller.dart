import 'package:get/get.dart';

import '../history/history_controller.dart';
import '../want/want_controller.dart';

class DashboardController extends GetxController {
  var tabIndex = 0;

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
    // IndexedStack 的分頁不會因切換而重建；這兩頁的資料可能在詳情頁
    // 被增刪（加入/刪除想去名單），回到該分頁時刷新一次。
    if (index == 2 && Get.isRegistered<WantController>()) {
      Get.find<WantController>().reload();
    }
    if (index == 3 && Get.isRegistered<HistoryController>()) {
      Get.find<HistoryController>().reload();
    }
  }
}
