import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/api_helper.dart';
import '../../data/mode/comment_model.dart';
import '../../util/ui_util.dart';
import '../../widgets/title_view.dart';

class DetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var counter = 0.obs;
  var isLoading = true.obs;
  var dataList = <CommentModel>[].obs;

  late TabController tabInfoController;
  late TextEditingController messageController;
  bool isShowTitle = false;
  GlobalKey<TitleViewState> titleStateKey = GlobalKey();

  /// 子分類
  final List<Tab> subTitle = const <Tab>[
    Tab(text: '資訊'),
    Tab(text: '評論'),
  ];

  @override
  void onInit() {
    super.onInit();
    fetchApi();
    tabInfoController = TabController(length: subTitle.length, vsync: this);
    messageController = TextEditingController();
  }

  /// 獲取Comment data
  void fetchApi() async {
    isLoading(true);
    await ApiHelper().fetchCommentData(Get.arguments.id).then((value) {
      dataList.assignAll(value);
      isLoading(false);
      update();
    }).catchError((e) {
      if (kDebugMode) {
        print('Error:$e');
      }
    });
  }

  @override
  void onClose() {
    tabInfoController.dispose();
    super.onClose();
  }

  void increaseCounter() {
    counter.value += 1;
  }

  void onTap(CommentModel item) {
    if (kDebugMode) {
      print(item.like);
      // Get.toNamed(AppRoutes.travelDetails, arguments: item);
    }
  }

  /// 傳送Commend訊息
  void send(){
    sendCommend();
  }

  void sendCommend() async {
    isLoading(true);
    await ApiHelper().fetchCommentData(Get.arguments.id).then((value) {
      dataList.assignAll(value);
      isLoading(false);
      update();
    }).catchError((e) {
      if (kDebugMode) {
        print('Error:$e');
      }
    });
  }
}
