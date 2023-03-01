import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/global_config.dart';
import '../../data/database/categoryDb.dart';
import '../../data/mode/data_all.dart';
import '../../data/repo/data_repo.dart';
import '../../routes/app_routes.dart';

enum SortState { id, title, region, siteLevel }

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final String title = '旅遊地圖';

  var firstLoading = false.obs;
  var isLoading = true.obs;
  var dataList = <DataAll>[].obs;
  var username = "".obs;

  /// DB設定
  CategoryDb categoryDb = CategoryDb();
  final DataController dataController = Get.find();

  late TabController tabTitleController;
  late TextEditingController textEditingController;
  List<String> getTabTitle = [
    "臺北市",
    "基隆市",
    "臺中市",
    "高雄市",
    "澎湖縣",
    "臺南市",
    "金門縣",
    "屏東縣",
    "新竹市",
    "新竹縣",
    "桃園市",
    "苗栗縣",
    "臺東縣",
    "彰化縣",
    "南投縣",
    "花蓮縣",
    "新北市",
    "連江縣",
    "宜蘭縣",
    "嘉義市",
    "嘉義縣",
    "雲林縣",
  ];

  /// 子分類
  final List<Tab> subTitle = const <Tab>[
    Tab(text: '資訊'),
    Tab(text: '評論'),
  ];

  @override
  void onInit() async {
    super.onInit();
    if (sharedPreferences.getString("username") != null) {
      username.value = sharedPreferences.getString("username")!;
    }

    tabTitleController = TabController(length: getTabTitle.length, vsync: this);
    tabTitleController.addListener(() {
      // 監聽滑動
      // print(tabTitleController.index);
    });
    textEditingController = TextEditingController();

    await categoryDb.open();
    if (await categoryDb.checkTableIsEmpty() > 0) {
      fetchDB();
    } else {
      firstLoading(true);
      fetchApi();
    }
    categoryDb.close();
  }

  void updateUsername(String userName) {
    username.value = sharedPreferences.getString("username")!;
    sharedPreferences.setString('username', userName);
  }

  /// 抓取資料判斷
  void fetchDB() async {
    isLoading(true);
    dataList.assignAll(await dataController.fetchData());
    searchData([getTabTitle[0]]);
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

  /// 抓取資料判斷
  void searchData(List<Object?>? whereArgs) async {
    dataList.assignAll(await dataController.searchData(whereArgs));
  }

  /// 取得版本
  String getAppVersion() {
    return packageInfo.version;
  }

  /// 進詳細
  void onTap(DataAll item) {
    if (kDebugMode) {
      print(item.title);
    }
    // 儲存資料 - 判斷這個item title有沒有資料
    List<String> historyList =
        (sharedPreferences.getStringList('history') ?? <String>[]);
    var match = historyList.firstWhere(
        (element) => element.contains(item.title),
        orElse: () => '');
    if (match == '') {
      // 確定沒有儲存
      historyList.add(item.title);
      sharedPreferences.setStringList('history', historyList);
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
