import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../config/AdHelper.dart';
import '../../config/global_config.dart';
import '../../data/database/categoryDb.dart';
import '../../data/mode/data_all.dart';
import '../../routes/app_routes.dart';

class AccountController extends GetxController {
  late TextEditingController textEditingController;

  // 資料庫宣告
  CategoryDb categoryDb = CategoryDb();
  var isLoading = true.obs;

  var username = "".obs;
  var dataList = <DataAll>[].obs;

  // 儲存資料
  late List<String> historyList;

  // 廣告宣告
  BannerAd? bannerAd;
  var isADShowing = false.obs;

  @override
  void onInit() async {
    super.onInit();
    adMobBanner();
    if (sharedPreferences.getString("username") != null) {
      username.value = sharedPreferences.getString("username")!;
    }
    textEditingController = TextEditingController();

    if (sharedPreferences.getStringList('history') != null) {
      // 儲存資料
      String temp = 'Title LIKE';
      historyList = (sharedPreferences.getStringList('history') ?? <String>[]);
      if (historyList.isNotEmpty) {
        for (int i = 0; i < historyList.length; i++) {
          if (i == 0) {
            temp = "$temp'%${historyList[i]}%'";
          } else {
            temp = "$temp or Title LIKE '%${historyList[i]}%'";
          }
        }
        searchData(temp);
        return;
      }
    }
    isLoading(false);
  }

  /// 設定廣告
  void adMobBanner() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAd = ad as BannerAd;
          isADShowing(true);
        },
        onAdFailedToLoad: (ad, err) {
          if (kDebugMode) {
            print('Failed to load a banner ad: ${err.message}');
          }
          ad.dispose();
        },
      ),
    ).load();
  }

  /// 更新暱稱
  void updateUsername(String userName) {
    sharedPreferences.setString('username', userName);
  }

  /// 替換暱稱
  void changeUsername() {
    sharedPreferences.setString('username', '');
  }

  /// 抓取資料判斷
  void searchData(String whereArgs) async {
    await categoryDb.open();
    var poetryData = await categoryDb.queryWhere(whereArgs);
    categoryDb.close();
    dataList.assignAll(List.generate(poetryData.length, (index) {
      return DataAll.fromJson(poetryData[index]);
    }));
    isLoading(false);
  }

  /// 刪除資料
  void deleteData() async {
    isLoading(true);
    sharedPreferences.setStringList('history', <String>[]);
    dataList.assignAll(<DataAll>[]);
    isLoading(false);
  }

  void onTap(DataAll item) {
    if (kDebugMode) {
      print(item.title);
    }
    // 跳頁
    Get.toNamed(AppRoutes.travelDetails, arguments: item);
  }

  /// 關閉
  @override
  void dispose() {
    bannerAd?.dispose();
    super.dispose();
  }
}
