import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:travel/data/dao/dataAllDao.dart';

import '../../config/AdHelper.dart';
import '../../config/global_config.dart';
import '../../data/mode/data_all.dart';
import '../../data/repo/fxDataBaseManager.dart';
import '../../routes/app_routes.dart';
import '../../util/ad_manager_util.dart';

class HistoryController extends GetxController {
  /// 讀取
  var isLoading = true.obs;

  /// 廣告宣告
  BannerAd? bannerAd;
  var isADShowing = false.obs;

  // 全版廣告
  InterstitialAd? interstitialAd;
  bool isInterstitialAdReady = false;

  /// DB設定
  late DataAllDao allDb;

  /// 儲存資料
  late List<String> historyAllList;

  /// 前端顯示資料
  var dataAllList = <DataAll>[].obs;

  @override
  void onInit() async {
    super.onInit();
    adMobBanner();
    loadInterstitialAd();

    isLoading(false);
  }

  /// 關閉
  @override
  void dispose() {
    AdManagerUtil.releaseAd(
      AdHelper.historyAdUnitId,
      placementId: 'history-banner',
    );
    super.dispose();
  }

  /// 初始化資料
  void initData() {
    // 抓取景點歷史資料
    if (sharedPreferences.getStringList(AppConstants.homeHistory) != null) {
      dataAllList.clear();

      // 儲存資料
      sharedPreferences
          .getStringList(AppConstants.homeHistory)
          ?.reversed
          .forEach((item) async {
        var searchDataAllResult = await searchDataAll(item);
        if (searchDataAllResult != null) {
          dataAllList.add(searchDataAllResult);
        }
      });
    }
  }

  /// 設定廣告
  void adMobBanner() {
    const placementId = 'history-banner';
    AdManagerUtil.initializeAd(
      AdHelper.historyAdUnitId,
      placementId: placementId,
    );
    bannerAd = AdManagerUtil.bannerAd(
      AdHelper.historyAdUnitId,
      placementId: placementId,
    );
    isADShowing = AdManagerUtil.isADShowing(
      AdHelper.historyAdUnitId,
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

  /// 抓取資料庫判斷
  Future<DataAll?> searchDataAll(String whereArgs) async {
    allDb = await FxDataBaseManager.dataAllDao();
    return await allDb.findDataAllByName(whereArgs);
  }

  /// 刪除資料
  void deleteData() async {
    isLoading(true);
    sharedPreferences.setStringList(AppConstants.homeHistory, <String>[]);
    dataAllList.assignAll(<DataAll>[]);
    isLoading(false);
  }

  void onTapDataAll(DataAll item) {
    if (kDebugMode) {
      print(item.name);
    }
    // showInterstitialAd(); 關閉全屏廣告
    Get.toNamed(AppRoutes.travelDetails, arguments: {
      'item': item,
      'page': 'history',
    });
  }

  /// 重新載入
  void reload() {
    initData();
  }
}
