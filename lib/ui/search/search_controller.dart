import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SearchController extends GetxController {
  late TextEditingController messageController;

  @override
  void onInit() {
    super.onInit();
    messageController = TextEditingController();
  }
}
