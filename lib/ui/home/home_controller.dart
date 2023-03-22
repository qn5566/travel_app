import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../config/AdHelper.dart';
import '../../config/global_config.dart';
import '../../config/rx_config.dart';
import '../../data/dao/dataAllDao.dart';
import '../../data/mode/data_all.dart';
import '../../data/repo/data_repo.dart';
import '../../data/repo/fxDataBaseManager.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final String title = '旅遊地圖';

  var firstLoading = false.obs;
  var isLoading = true.obs;
  var dataList = <DataAll>[].obs;
  var username = "".obs;

  final DataController dataController = Get.find();

  late TabController tabTitleController;
  late TextEditingController textEditingController;
  late TextEditingController messageController;

  // 搜尋關鍵字
  var keywords = ''.obs;

  // 備份原始資料
  List<DataAll> backupDataList = [];

  late RxConfig userData;

  // 廣告宣告
  BannerAd? bannerAd;
  var isADShowing = false.obs;

  @override
  void onInit() async {
    super.onInit();
    if (sharedPreferences.getString(AppConstants.userName) != null) {
      username.value = sharedPreferences.getString(AppConstants.userName)!;
    }

    userData = Get.find();
    tabTitleController =
        TabController(length: userData.travelTitle.length, vsync: this);
    tabTitleController.addListener(() {
      // 監聽滑動
      if (kDebugMode) {
        print(tabTitleController.index);
      }

      backupDataList.clear();
    });
    textEditingController = TextEditingController();
    // 輸入匡宣告
    messageController = TextEditingController();

    /// DB相關
    DataAllDao dataData = await FxDataBaseManager.dataAllDao();

    if ((await dataData.checkTableIsEmpty())! > 0) {
      fetchDB();
    } else {
      firstLoading(true);
      fetchApi();
    }

    adMobBanner();
  }

  void updateUsername(String userName) {
    username.value = sharedPreferences.getString(AppConstants.userName)!;
    sharedPreferences.setString(AppConstants.userName, userName);
  }

  /// 抓取資料判斷
  void fetchDB() async {
    isLoading(true);
    searchData(userData.travelTitle[0]);
    firstLoading(false);
    isLoading(false);
  }

  /// 抓取遠端資料
  void fetchApi() async {
    isLoading(true);
    await dataController.fetchRemoteData().then((data) {
      dataList.assignAll(data);
      fetchDB();
    });
  }

  /// 抓取資料判斷 - 同地區
  void searchDataRegion(String keyword) async {
    // 如果還沒備份原始資料，就先備份一份
    if (backupDataList.isEmpty) {
      backupDataList.addAll(dataList);
    }
    // 根據 whereArgs 過濾資料
    if (keyword.isNotEmpty) {
      dataList.assignAll(backupDataList
          .where((restaurant) =>
      restaurant.name!.contains(keyword) ||
          (restaurant.description != null &&
              restaurant.description!.contains(keyword)))
          .toList());
    } else {
      dataList.assignAll(backupDataList);
    }
  }

  /// 抓取資料判斷
  void searchData(String whereArgs) async {
    dataList.assignAll(await dataController.searchData(whereArgs));
  }

  /// 取得版本
  String getAppVersion() {
    return packageInfo.version;
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

  /// 進詳細
  void onTap(DataAll item) {
    if (kDebugMode) {
      print(item.name);
    }
    // 儲存資料 - 判斷這個item title有沒有資料
    List<String> historyList =
    (sharedPreferences.getStringList(AppConstants.homeHistory) ?? <String>[]);
    var match = historyList.firstWhere(
            (element) => element.contains(item.name!),
        orElse: () => '');
    if (match == '') {
      // 確定沒有儲存
      historyList.add(item.name!);
      sharedPreferences.setStringList(AppConstants.homeHistory, historyList);
    }
    // 跳頁
    Get.toNamed(AppRoutes.travelDetails, arguments: item);
  }

  void toSearch() {
    Get.toNamed(AppRoutes.searchPage);
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
