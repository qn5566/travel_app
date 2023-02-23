import 'package:get/get.dart';
import 'package:travel/ui/account/account_controller.dart';
import 'package:travel/ui/map/map_controller.dart';

import '../../data/repo/data_repo.dart';
import '../home/home_controller.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<MapController>(() => MapController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<AccountController>(() => AccountController());
    Get.lazyPut<DataController>(() => DataController());
  }
}
