import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../config/AdHelper.dart';
import '../../config/global_config.dart';
import '../../config/rx_config.dart';
import '../../data/mode/data_all.dart';
import '../../data/repo/fxDataBaseManager.dart';
import '../../routes/app_routes.dart';
import '../../util/ad_manager_util.dart';

class AccountController extends GetxController {
  late TextEditingController textEditingController;

  var isLoading = true.obs;

  var username = "".obs;
  var dataList = <DataAll>[].obs;

  late RxConfig userData;

  // 儲存資料
  late List<String> historyList;

  // 廣告宣告
  BannerAd? bannerAd;
  var isADShowing = false.obs;

  // 全版廣告
  InterstitialAd? interstitialAd;
  bool isInterstitialAdReady = false;

  @override
  void onInit() async {
    super.onInit();
    adMobBanner();
    loadInterstitialAd();

    if (sharedPreferences.getString(AppConstants.userName) != null) {
      username.value = sharedPreferences.getString(AppConstants.userName)!;
    }
    textEditingController = TextEditingController();

    userData = Get.find();

    if (sharedPreferences.getStringList(AppConstants.homeHistory) != null) {
      // 儲存資料
      String temp = '';
      historyList =
          (sharedPreferences.getStringList(AppConstants.homeHistory) ??
              <String>[]);
      if (historyList.isNotEmpty) {
        searchData(historyList);
        return;
      }
    }
    isLoading(false);
  }

  /// 設定廣告
  void adMobBanner() {
    AdManagerUtil.initializeAd(AdHelper.accountAdUnitId);
    bannerAd = AdManagerUtil.bannerAd;
    isADShowing = AdManagerUtil.isADShowing;
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

  /// 抓取資料判斷
  void searchData(List<String> whereArgs) async {
    // DB相關
    var dataData = await FxDataBaseManager.dataAllDao();

    List<DataAll> poetryData = [];
    for (String title in whereArgs) {
      var data = await dataData.findDataAllByTitle(title);
      poetryData.addAll(data);
    }

    dataList.assignAll(List.generate(poetryData.length, (index) {
      return poetryData[index];
    }));
    isLoading(false);
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
    Get.toNamed(AppRoutes.travelDetails, arguments: item);
  }

  /// 取得版本
  String getAppVersion() {
    return packageInfo.version;
  }

  String getAppBuildNumber() {
    return packageInfo.buildNumber;
  }

  /// 關閉
  @override
  void dispose() {
    bannerAd?.dispose();
    super.dispose();
  }
}
