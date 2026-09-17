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

class WantController extends GetxController {
  /// 讀取
  var isLoading = true.obs;

  /// 廣告宣告
  BannerAd? bannerAd;
  var isADShowing = false.obs;

  // 全版廣告
  InterstitialAd? interstitialAd;
  bool isInterstitialAdReady = false;

  /// DB設定（可空：首次查詢前尚未初始化）
  DataAllDao? allDb;

  /// 儲存資料
  late List<String> historyAllList;

  /// 前端顯示資料
  var dataAllList = <DataAll>[].obs;

  /// initData 防重入鎖
  bool _isLoadingData = false;

  /// 載入世代計數：只接受最新一次請求的結果，避免舊結果蓋掉新請求
  int _loadGeneration = 0;

  @override
  void onInit() async {
    super.onInit();
    adMobBanner();
    loadInterstitialAd();
    initData(); // 首次載入；之後由切換 tab 時 reload

    isLoading(false);
  }

  /// 關閉
  @override
  void dispose() {
    AdManagerUtil.releaseAd(
      AdHelper.wantAdUnitId,
      placementId: 'want-banner',
    );
    super.dispose();
  }

  /// 初始化資料
  Future<void> initData() async {
    if (_isLoadingData) return; // 防重入：上一次查詢還在跑時不要重疊
    _isLoadingData = true;
    final generation = ++_loadGeneration;
    try {
      // 抓取景點想要的資料
      final wantGoList = sharedPreferences.getStringList(AppConstants.wantGo);
      if (wantGoList == null) return;

      final result = <DataAll>[];
      // 依序查詢，避免 forEach + async 的 fire-and-forget 競爭條件
      for (final item in wantGoList.reversed) {
        final searchDataAllResult = await searchDataAll(item);
        if (searchDataAllResult != null) {
          result.add(searchDataAllResult);
        }
      }
      // 只有最新一次的請求才能更新 UI（防舊結果回來蓋掉新資料）
      if (generation != _loadGeneration || isClosed) return;
      // 一次換上新資料，避免 UI 看到清空後尚未補回的中間狀態
      dataAllList.assignAll(result);
    } finally {
      _isLoadingData = false;
    }
  }

  /// 設定廣告
  void adMobBanner() {
    const placementId = 'want-banner';
    AdManagerUtil.initializeAd(
      AdHelper.wantAdUnitId,
      placementId: placementId,
    );
    bannerAd = AdManagerUtil.bannerAd(
      AdHelper.wantAdUnitId,
      placementId: placementId,
    );
    isADShowing = AdManagerUtil.isADShowing(
      AdHelper.wantAdUnitId,
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
    // dao 快取：還沒取過才去拿（initData 迴圈內會多次呼叫）
    var db = allDb;
    if (db == null) {
      db = await FxDataBaseManager.dataAllDao();
      allDb = db;
    }
    return await db.findDataAllByName(whereArgs);
  }

  /// 刪除資料
  void deleteData() async {
    isLoading(true);
    sharedPreferences.setStringList(AppConstants.wantGo, <String>[]);
    dataAllList.assignAll(<DataAll>[]);
    isLoading(false);
  }

  Future<void> onTapDataAll(DataAll item) async {
    if (kDebugMode) {
      print(item.name);
    }
    // showInterstitialAd(); 關閉全屏廣告
    await Get.toNamed(AppRoutes.travelDetails, arguments: {
      'item': item,
      'page': 'want',
    });
    // 從詳情頁返回：無論是否有刪除/加入，都重新讀一次保持清單同步
    if (!isClosed) reload();
  }

  void reload() {
    initData();
  }
}
