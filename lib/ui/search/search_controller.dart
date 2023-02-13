import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../config/global_config.dart';
import '../../data/database/categoryDb.dart';
import '../../data/mode/data_all.dart';
import '../../routes/app_routes.dart';

class SearchController extends GetxController {
  late TextEditingController messageController;

  CategoryDb categoryDb = CategoryDb();
  var isLoading = true.obs;
  var dataList = <DataAll>[].obs;

  // 搜尋關鍵字
  var keywords = ''.obs;

  @override
  void onInit() {
    super.onInit();
    messageController = TextEditingController();
  }

  /// 抓取資料判斷
  void searchData(String whereArgs) async {
    await categoryDb.open();
    //LIKE '%?%'; default 全部
    // String temp = '';
    // if (whereArgs.isEmpty) {
    //   temp = "Title LIKE '%%' ";
    // } else {
    //   temp = "Title LIKE '%${whereArgs.value}%'";
    // }

    var poetryData = await categoryDb.queryWhere("Title LIKE '%$whereArgs%'");
    categoryDb.close();
    dataList.assignAll(List.generate(poetryData.length, (index) {
      return DataAll.fromJson(poetryData[index]);
    }));
    isLoading(false);
  }

  // 進詳細
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
    //跳頁
    Get.toNamed(AppRoutes.travelDetails, arguments: item);
  }
}
