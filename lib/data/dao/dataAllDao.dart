import 'package:floor/floor.dart';

import '../mode/data_all.dart';

@dao
abstract class DataAllDao {
  static const tableName = "DataAll";

  @Query('SELECT COUNT(*) FROM $tableName')
  Future<int?> checkTableIsEmpty();

  @Query('SELECT * FROM $tableName')
  Future<List<DataAll>> getAllDataAll();

  @Query('DELETE FROM $tableName')
  Future<void> clearAllData();

  @insert
  Future<void> insertDataAll(DataAll dataAll);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUpdateDataAll(DataAll dataAll);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUpdateDataAllBatch(List<DataAll> dataAll);

  @delete
  Future<void> deleteDataAll(DataAll dataAll);

  @Query('SELECT * FROM $tableName WHERE Region = :region')
  Future<List<DataAll>> findDataAllByRegion(String region);

  @Query('SELECT * FROM $tableName WHERE Name = :name LIMIT 1')
  Future<DataAll?> findDataAllByName(String name);
}
