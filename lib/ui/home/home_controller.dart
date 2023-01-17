import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/api_helper.dart';
import '../../data/database/categoryDb.dart';
import '../../data/mode/data_all.dart';
import '../../routes/app_routes.dart';

enum SortState { id, title, region, siteLevel }

class HomeController extends GetxController {
  final String title = '旅遊地圖';

  var isLoading = true.obs;
  var dataList = <DataAll>[].obs;

  CategoryDb categoryDb = CategoryDb();

  @override
  void onInit() async {
    super.onInit();
    fetchDB();
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
