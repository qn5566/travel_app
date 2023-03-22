import 'package:floor/floor.dart';

import '../mode/data_all.dart';

@dao
abstract class DataAllDao {
  static const tableName = "DataAll";

  @Query('SELECT COUNT(*) FROM $tableName')
  Future<int?> checkTableIsEmpty();

  @Query('SELECT * FROM $tableName')
  Future<List<DataAll>> getAllDataAll();

  @insert
  Future<void> insertDataAll(DataAll dataAll);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUpdateDataAll(DataAll dataAll);

  @delete
  Future<void> deleteDataAll(DataAll dataAll);

  @Query('SELECT * FROM $tableName WHERE Region = :region')
  Future<List<DataAll>> findDataAllByRegion(String region);

  @Query('SELECT * FROM $tableName WHERE Name = :name LIMIT 1')
  Future<DataAll?> findDataAllByName(String name);
}
