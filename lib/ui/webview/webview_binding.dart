import 'package:get/get.dart';
import 'package:travel/ui/webview/webview_controller.dart';

class CustomWebViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomWebViewController>(() => CustomWebViewController());
  }
}
