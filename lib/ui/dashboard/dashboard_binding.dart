import 'package:get/get.dart';
import 'package:travel/ui/account/account_controller.dart';
import 'package:travel/ui/map/map_controller.dart';

import '../../data/repo/data_repo.dart';
import '../history/history_controller.dart';
import '../home/home_controller.dart';
import '../want/want_controller.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DashboardController>()) {
      Get.lazyPut<DashboardController>(() => DashboardController());
    }
    if (!Get.isRegistered<MapController>()) {
      Get.lazyPut<MapController>(() => MapController());
    }
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(() => HomeController());
    }
    if (!Get.isRegistered<AccountController>()) {
      Get.lazyPut<AccountController>(() => AccountController());
    }
    if (!Get.isRegistered<DataController>()) {
      Get.lazyPut<DataController>(() => DataController());
    }
    if (!Get.isRegistered<HistoryController>()) {
      Get.lazyPut<HistoryController>(() => HistoryController());
    }
    if (!Get.isRegistered<WantController>()) {
      Get.lazyPut<WantController>(() => WantController());
    }
  }
}
