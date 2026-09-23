import 'package:get/get.dart';

import 'config/rx_config.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<RxConfig>(RxConfig(), permanent: true);
  }
}
