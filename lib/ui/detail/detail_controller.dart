import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/api_helper.dart';
import '../../data/mode/comment_model.dart';
import '../../util/ToastUtil.dart';
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

  void checkSendData(String data, {required ValueChanged<dynamic> callback}) {
    if (data.isEmpty) {
      ToastUtil.info("請填入資訊");
    } else {
      int timestamp = DateTime
          .now()
          .millisecondsSinceEpoch;
      DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      String datetime =
          "${tsdate.year}/${tsdate.month}/${tsdate.day} ${tsdate.hour}:${tsdate
          .minute}";
      if (kDebugMode) {
        print(datetime);
      }

      Map<String, dynamic> body = {
        'TitleId': Get.arguments.id,
        'Username': 'Ted',
        'Comment': data,
        'Like': 5,
        'Device': Platform.isAndroid ? 'Android' : 'iOS',
        'TimeStamp': datetime
      };

      sendCommentApi(body, callback: (value) {
        callback(value);
      });
    }
  }

  /// 傳送Comment data
  void sendCommentApi(Map<String, dynamic> body,
      {required ValueChanged<dynamic> callback}) async {
    isLoading(true);
    await ApiHelper().sendCommentData(body).then((value) {
      isLoading(false);
      callback('ok');
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
}
