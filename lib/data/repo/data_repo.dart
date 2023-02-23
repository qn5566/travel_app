import 'package:flutter/foundation.dart';

import '../../data/api_helper.dart';
import '../../data/database/categoryDb.dart';
import '../../data/mode/data_all.dart';

class DataController {
  /// DB設定
  CategoryDb categoryDb = CategoryDb();

  /// 抓取資料判斷
  Future<List<DataAll>> fetchData() async {
    await categoryDb.open();
    var poetryData = await categoryDb.queryAll();
    categoryDb.close();
    return List.generate(poetryData.length, (index) {
      return DataAll.fromJson(poetryData[index]);
    });
  }

  /// 抓取遠端資料
  Future<List<DataAll>> fetchRemoteData() async {
    await categoryDb.open();
    await ApiHelper().fetchAllDataToDb().then((value) async {
      for (var data in value) {
        await categoryDb.autoCheckInsertOrUpdate(data);
      }
      categoryDb.close();
    }).catchError((e) {
      if (kDebugMode) {
        print('Error:$e');
      }
    });
    return fetchData();
  }

  /// 抓取資料判斷
  Future<List<DataAll>> searchData(List<Object?>? whereArgs) async {
    await categoryDb.open();
    var poetryData = await categoryDb.query('Region = ?', whereArgs);
    categoryDb.close();
    return List.generate(poetryData.length, (index) {
      return DataAll.fromJson(poetryData[index]);
    });
  }
}
