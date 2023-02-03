import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

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

  // 近詳細
  void onTap(DataAll item) {
    if (kDebugMode) {
      print(item.title);
    }
    Get.toNamed(AppRoutes.travelDetails, arguments: item);
  }
}
