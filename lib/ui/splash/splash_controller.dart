import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../routes/app_routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(const Duration(milliseconds: 1000));
    // var storage = Get.find<SharedPreferences>();
    try {
      // if (storage.getString(StorageConstants.token) != null) {
      Get.toNamed(AppRoutes.dashboard);
      // } else {
      //   Get.toNamed(Routes.AUTH);
      // }
    } catch (e) {
      // Get.toNamed(Routes.AUTH);
    }
  }
}
