import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel/data/mode/data_all.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/global_config.dart';
import '../../data/api_helper.dart';
import '../../data/mode/comment_model.dart';
import '../../util/ToastUtil.dart';
import '../../widgets/title_view.dart';
import '../account/account_controller.dart';

class DetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var counter = 0.obs;
  var isLoading = true.obs;
  var dataList = <CommentModel>[].obs;

  late TabController tabInfoController;
  late TextEditingController messageController;
  bool isShowTitle = false;
  GlobalKey<TitleViewState> titleStateKey = GlobalKey();
  final item = Get.arguments as DataAll;

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
    Get.delete<AccountController>();
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
    String username = '';
    if (sharedPreferences.getString("username") != null) {
      username = sharedPreferences.getString("username") ?? '';
    }else{
      ToastUtil.info("請先設定暱稱");
      return;
    }

    if (data.isEmpty) {
      ToastUtil.info("請填入資訊");
    } else {
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      String datetime =
          "${tsdate.year}/${tsdate.month}/${tsdate.day} ${tsdate.hour}:${tsdate.minute}";
      if (kDebugMode) {
        print(datetime);
      }

      Map<String, dynamic> body = {
        'fun': 'updateComment',
        'TitleId': Get.arguments.id,
        'Username': username,
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
      callback('ok');
    });
  }

  //拨打电话
  void call(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw '不能撥打 $url';
    }
  }

  @override
  void onClose() {
    tabInfoController.dispose();
    Get.lazyPut<AccountController>(() => AccountController());
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
