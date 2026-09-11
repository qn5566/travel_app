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
  Future<List<DataAll>> fetchRemoteData({
    void Function(double progress)? onProgress,
  }) {
    return _syncFuture ??= _fetchRemoteData(onProgress: onProgress).whenComplete(() {
      _syncFuture = null;
    });
  }

  Future<List<DataAll>> _fetchRemoteData({
    void Function(double progress)? onProgress,
  }) async {
    dataData = await FxDataBaseManager.dataAllDao();
    try {
      final value = await ApiHelper().fetchAllData(onProgress: onProgress);
      onProgress?.call(0.9);
      final infoData = value.xMLHead?.infos?.info ?? <DataAll>[];
      if (infoData.isNotEmpty) {
        // The ZIP is a complete snapshot; remove records from an older schema
        // before inserting it so stale coordinates cannot remain in the map.
        await dataData.clearAllData();
        await dataData.insertUpdateDataAllBatch(infoData);
        onProgress?.call(0.98);
        // Mark the snapshot as current only after the complete batch has been
        // written successfully. A failed/partial download must be retried on
        // the next launch.
        await sharedPreferences.setString(
          AppConstants.homeUpdateShareKey,
          value.xMLHead?.updatetime ?? DateTime.now().toString(),
        );
        await sharedPreferences.setInt(
          AppConstants.homeDataVersionKey,
          _requiredDataVersion(),
        );
      } else {
        throw const FormatException('景點資料為空，未更新本機資料');
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

  int _requiredDataVersion() {
    final remoteVersion =
        sharedPreferences.getInt(AppConstants.remoteHomeDataVersionKey) ?? 0;
    return remoteVersion > AppConstants.homeDataVersion
        ? remoteVersion
        : AppConstants.homeDataVersion;
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
