import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel/data/mode/data_all.dart';
import 'package:travel/ui/history/history_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/global_config.dart';
import '../../data/api_helper.dart';
import '../../data/mode/comment_model.dart';
import '../../routes/app_routes.dart';
import '../../util/ToastUtil.dart';

class DetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var counter = 0.obs;
  var isLoading = true.obs;
  var dataList = <CommentModel>[].obs;

  late TabController tabInfoController;
  late TextEditingController messageController;
  bool isShowTitle = false;

  // GlobalKey<TitleViewState> titleStateKey = GlobalKey();
  final arguments = Get.arguments as Map<String, dynamic>;
  DataAll? item;

  /// 子分類
  final List<Tab> subTitle = const <Tab>[
    Tab(text: '資訊'),
    Tab(text: '評論'),
  ];

  @override
  void onInit() {
    super.onInit();
    item = arguments['item'];
    fetchApi();
    tabInfoController = TabController(length: subTitle.length, vsync: this);
    messageController = TextEditingController();
    Get.delete<HistoryController>();
  }

  /// 獲取Comment data
  void fetchApi() async {
    isLoading(true);
    // 來去儲存點擊紀錄
    sendHistory(item?.name ?? '');
    await ApiHelper().fetchCommentData(item!.id!).then((value) {
      dataList.assignAll(value);
      isLoading(false);
      update();
    }).catchError((e) {
      if (kDebugMode) {
        print('Error:$e');
      }
      isLoading(false);
    });
  }

  void checkSendData(BuildContext context, String data,
      {required ValueChanged<dynamic> callback}) {
    String username = '';
    if (sharedPreferences.getString(AppConstants.userName) != null &&
        sharedPreferences.getString(AppConstants.userName) != '') {
      username = sharedPreferences.getString(AppConstants.userName) ?? '未命名';
    } else {
      ToastUtil.info(context, "請先設定暱稱");
      return;
    }

    if (data.isEmpty) {
      ToastUtil.info(context, "請填入資訊");
    } else {
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      String datetime =
          "${tsdate.year}/${tsdate.month.toString().padLeft(2, '0')}/"
          "${tsdate.day.toString().padLeft(2, '0')} "
          "${tsdate.hour.toString().padLeft(2, '0')}:"
          "${tsdate.minute.toString().padLeft(2, '0')}";
      if (kDebugMode) {
        print(datetime);
      }

      Map<String, dynamic> body = {
        'fun': 'updateComment',
        'TitleId': item?.id,
        'TitleName': item?.name,
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
    Get.lazyPut<HistoryController>(() => HistoryController());
    super.onClose();
  }

  void increaseCounter() {
    counter.value += 1;
  }

  void onTap(CommentModel item) {
    if (kDebugMode) {
      print(item?.like);
      // Get.toNamed(AppRoutes.travelDetails, arguments: item);
    }
  }

  /// 跳到網頁搜尋
  void goToWebView() {
    // 跳頁
    Get.toNamed(AppRoutes.webViewPage, arguments: item);
  }

  /// 上傳點擊紀錄
  void sendHistory(String title) async {
    isLoading(true);
    Map<String, dynamic> body = {
      'fun': 'history',
      'Title': title,
    };
    await ApiHelper().sendHistory(body).then((value) {}).catchError((e) {
      if (kDebugMode) {
        print('Error:$e');
      }
    });

    isLoading(false);
  }

  /// 儲存想去名單
  void saveWantGo(BuildContext context) async {
    isLoading(true);

    if (sharedPreferences.getString(AppConstants.userName) == null &&
        sharedPreferences.getString(AppConstants.userName) == '') {
      ToastUtil.info(context, "請先設定暱稱");
      return;
    }

    // 儲存資料 - 判斷這個item title有沒有資料
    List<String> wantGoList =
        (sharedPreferences.getStringList(AppConstants.wantGo) ?? <String>[]);
    var match = wantGoList.firstWhere(
        (element) => element.contains(item!.name!),
        orElse: () => '');
    if (match == '') {
      // 確定沒有儲存
      wantGoList.add(item!.name!);
      sharedPreferences.setStringList(AppConstants.wantGo, wantGoList);
    } else {
      ToastUtil.info(context, "已經加入過了");
    }

    sharedPreferences.setStringList(AppConstants.wantGo, wantGoList);
    isLoading(false);
  }

  /// 刪除想去名單
  void deleteWantGo(BuildContext context) async {
    isLoading(true);

    // 儲存資料 - 判斷這個item title有沒有資料
    List<String> wantGoList =
        (sharedPreferences.getStringList(AppConstants.wantGo) ?? <String>[]);
    var match = wantGoList.firstWhere(
        (element) => element.contains(item!.name!),
        orElse: () => '');
    if (match != '') {
      // 確定有儲存
      wantGoList.remove(item?.name!);
      sharedPreferences.setStringList(AppConstants.wantGo, wantGoList);
    } else {
      ToastUtil.info(context, "沒有加入過");
    }

    sharedPreferences.setStringList(AppConstants.wantGo, wantGoList);
    isLoading(false);

    /// 退出
    Get.back();
  }
}
