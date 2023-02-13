import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

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

  @override
  void onInit() async {
    super.onInit();
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

  void onTap(DataAll item) {
    if (kDebugMode) {
      print(item.title);
    }
    // // 儲存資料
    // List<String> historyList =
    //     (sharedPreferences.getStringList('history') ?? <String>[]);
    // historyList.add(item.title);
    // sharedPreferences.setStringList('history', historyList);
    // 跳頁
    Get.toNamed(AppRoutes.travelDetails, arguments: item);
  }
}
