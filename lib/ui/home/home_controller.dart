import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/api_helper.dart';
import '../../data/database/categoryDb.dart';
import '../../data/mode/data_all.dart';
import '../../routes/app_routes.dart';

enum SortState { id, title, region, siteLevel }

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final String title = '旅遊地圖';

  var isLoading = true.obs;
  var dataList = <DataAll>[].obs;

  CategoryDb categoryDb = CategoryDb();

  late TabController tabTitleController;

  List<String> getTabTitle = [
    "台北市",
    "基隆市",
    "新北市",
    "連江縣",
    "宜蘭縣",
    "新竹市",
    "新竹縣",
    "桃園市",
    "苗栗縣",
    "台中市",
    "彰化縣",
    "南投縣",
    "嘉義市",
    "嘉義縣",
    "雲林縣",
    "台南市",
    "高雄市",
    "澎湖縣",
    "金門縣",
    "屏東縣",
    "台東縣",
    "花蓮縣"
  ];

  /// 子分類
  final List<Tab> subTitle = const <Tab>[
    Tab(text: '資訊'),
    Tab(text: '評論'),
  ];

  @override
  void onInit() async {
    super.onInit();
    tabTitleController = TabController(length: getTabTitle.length, vsync: this);
    tabTitleController.addListener(() {
      // 監聽滑動
      // print(tabTitleController.index);
    });

    await categoryDb.open();
    if (await categoryDb.checkTableIsEmpty() > 0) {
      categoryDb.close();
      fetchDB();
    } else {
      categoryDb.close();
      fetchApi();
    }
  }

  /// 抓取資料判斷
  void fetchDB() async {
    isLoading(true);
    await categoryDb.open();
    var poetryData = await categoryDb.queryAll();
    categoryDb.close();
    dataList.assignAll(List.generate(poetryData.length, (index) {
      return DataAll.fromJson(poetryData[index]);
    }));

    searchData([getTabTitle[0]]);
    isLoading(false);
  }

  /// 抓取遠端資料
  void fetchApi() async {
    isLoading(true);
    await categoryDb.open();
    await ApiHelper().fetchAllDataToDb().then((value) async {
      for (var data in value) {
        await categoryDb.autoCheckInsertOrUpdate(data);
      }
      categoryDb.close();
      isLoading(false);
      fetchDB();
    }).catchError((e) {
      isLoading(false);
      if (kDebugMode) {
        print('Error:$e');
      }
    });
  }

  /// 抓取資料判斷
  void searchData(List<Object?>? whereArgs) async {
    await categoryDb.open();

    var poetryData = await categoryDb.query('Region = ?', whereArgs);
    categoryDb.close();
    dataList.assignAll(List.generate(poetryData.length, (index) {
      return DataAll.fromJson(poetryData[index]);
    }));
    // isLoading(false);
  }

  // sort method
  void sort(SortState sortState) async {
    switch (sortState) {
      case SortState.title:
        dataList.sort((a, b) => a.title!.compareTo(b.title!));
        break;
      case SortState.id:
        dataList.sort((a, b) => a.id!.compareTo(b.id!));
        break;
      case SortState.region:
        dataList.sort((a, b) => a.region!.compareTo(b.region!));
        break;
      case SortState.siteLevel:
        dataList.sort((a, b) => a.siteLevel!.compareTo(b.siteLevel!));
        break;
    }
    update();
  }

  void onTap(DataAll item) {
    if (kDebugMode) {
      print(item.title);
      Get.toNamed(AppRoutes.travelDetails, arguments: item);
    }
  }
}
