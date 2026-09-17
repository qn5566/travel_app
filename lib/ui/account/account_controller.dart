import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../config/AdHelper.dart';
import '../../config/global_config.dart';
import '../../config/rx_config.dart';
import '../../data/api_helper.dart';
import '../../data/mode/comment_model.dart';
import '../../data/mode/data_all.dart';
import '../../routes/app_routes.dart';
import '../../util/ToastUtil.dart';
import '../../util/ad_manager_util.dart';

class AccountController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TextEditingController textEditingController;

  var isLoading = true.obs;

  var username = "".obs;
  var draftUsername = "".obs;
  var dataList = <DataAll>[].obs;
  var dataListComment = <CommentModel>[].obs;

  late RxConfig userData;

  // 儲存資料
  late List<String> historyList;

  // 廣告宣告
  BannerAd? bannerAd;
  var isADShowing = false.obs;

  // 全版廣告
  InterstitialAd? interstitialAd;
  bool isInterstitialAdReady = false;

  late TextEditingController messageController;
  late AnimationController animationController;

  @override
  void onInit() async {
    super.onInit();
    adMobBanner();
    loadInterstitialAd();
    fetchApi();

    if (sharedPreferences.getString(AppConstants.userName) != null) {
      username.value = sharedPreferences.getString(AppConstants.userName)!;
    }
    textEditingController = TextEditingController();
    messageController = TextEditingController();

    userData = Get.find();

    isLoading(false);

    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  /// 獲取Comment data - message board
  Future<void> fetchApi() async {
    isLoading(true);
    await ApiHelper().fetchCommentDataMessageBoard().then((value) {
      final sorted = value
        ..sort((a, b) =>
            (b.timeStamp ?? '').compareTo(a.timeStamp ?? ''));
      dataListComment.assignAll(sorted);
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
        'fun': 'updateMessageBoard',
        'Username': username,
        'Comment': data,
        'Like': 5,
        'Device': Platform.isAndroid ? 'Android' : 'iOS',
        'TimeStamp': datetime
      };

      sendCommentMessageBoardApi(body, callback: (value) {
        callback(value);
      });
    }
  }

  /// 傳送Comment data - MessageBoard
  void sendCommentMessageBoardApi(Map<String, dynamic> body,
      {required ValueChanged<dynamic> callback}) async {
    isLoading(true);
    await ApiHelper().sendCommentDataMessageBoard(body).then((value) {
      isLoading(false);
      callback('ok');
    }).catchError((e) {
      if (kDebugMode) {
        print('Error:$e');
      }
      callback('error');
    });
  }

  /// 設定廣告
  void adMobBanner() {
    const placementId = 'account-banner';
    AdManagerUtil.initializeAd(
      AdHelper.accountAdUnitId,
      placementId: placementId,
    );
    bannerAd = AdManagerUtil.bannerAd(
      AdHelper.accountAdUnitId,
      placementId: placementId,
    );
    isADShowing = AdManagerUtil.isADShowing(
      AdHelper.accountAdUnitId,
      placementId: placementId,
    );
  }

  /// 全屏廣告
  void loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            interstitialAd = ad;
            isInterstitialAdReady = true;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  // 顯示插頁式廣告
  void showInterstitialAd() {
    if (interstitialAd != null && isInterstitialAdReady) {
      interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          interstitialAd = null;
          isInterstitialAdReady = false;
          loadInterstitialAd(); // 在下次需要顯示時再次載入廣告
        },
      );
      interstitialAd?.show();
    } else {
      if (kDebugMode) {
        print('Interstitial ad was not ready.');
      }
    }
  }

  /// 更新暱稱
  void updateUsername(String userName) {
    sharedPreferences.setString(AppConstants.userName, userName);
    showInterstitialAd();
  }

  /// 替換暱稱
  void changeUsername() {
    sharedPreferences.setString(AppConstants.userName, '');
  }

  /// 刪除資料
  void deleteData() async {
    isLoading(true);
    sharedPreferences.setStringList(AppConstants.homeHistory, <String>[]);
    dataList.assignAll(<DataAll>[]);
    isLoading(false);
  }

  void onTap(DataAll item) {
    if (kDebugMode) {
      print(item.name);
    }
    // 跳頁
    Get.toNamed(AppRoutes.travelDetails, arguments: {
      'item': item,
      'page': 'account',
    });
  }

  /// 取得版本
  String getAppVersion() {
    return packageInfo.version;
  }

  String getAppBuildNumber() {
    return packageInfo.buildNumber;
  }

  void startAnimation() {
    animationController.repeat();
  }

  void stopAnimation() {
    animationController.stop();
  }

  /// 關閉
  @override
  void dispose() {
    textEditingController.dispose();
    messageController.dispose();
    AdManagerUtil.releaseAd(
      AdHelper.accountAdUnitId,
      placementId: 'account-banner',
    );
    animationController.dispose();
    super.dispose();
  }
}
