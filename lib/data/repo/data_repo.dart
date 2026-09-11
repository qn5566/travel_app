import 'package:flutter/foundation.dart';

import '../../config/global_config.dart';
import '../../data/api_helper.dart';
import '../../data/mode/data_all.dart';
import '../dao/dataAllDao.dart';
import 'fxDataBaseManager.dart';

class DataController {
  /// DB設定
  late DataAllDao dataData;
  Future<List<DataAll>>? _syncFuture;

  /// 抓取資料判斷
  Future<List<DataAll>> fetchData() async {
    dataData = await FxDataBaseManager.dataAllDao();
    var poetryData = await dataData.getAllDataAll();
    return List.generate(poetryData.length, (index) {
      return poetryData[index];
    });
  }

  /// 抓取遠端資料並存入DB
  Future<List<DataAll>> fetchRemoteData() {
    return _syncFuture ??= _fetchRemoteData().whenComplete(() {
      _syncFuture = null;
    });
  }

  Future<List<DataAll>> _fetchRemoteData() async {
    dataData = await FxDataBaseManager.dataAllDao();
    try {
      final value = await ApiHelper().fetchAllData();
      sharedPreferences.setString(AppConstants.homeUpdateShareKey,
          value.xMLHead?.updatetime ?? DateTime.now().toString());
      final infoData = value.xMLHead?.infos?.info ?? <DataAll>[];
      if (infoData.isNotEmpty) {
        await dataData.insertUpdateDataAllBatch(infoData);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error:$e');
      }
      final cachedData = await fetchData();
      if (cachedData.isNotEmpty) return cachedData;
      rethrow;
    }
    return fetchData();
  }

  /// 抓取資料判斷
  Future<List<DataAll>> searchData(String whereArgs) async {
    dataData = await FxDataBaseManager.dataAllDao();
    var poetryData = await dataData.findDataAllByRegion(whereArgs);
    return List.generate(poetryData.length, (index) {
      return poetryData[index];
    });
  }

  /// 抓取歷史排行榜資料
}
