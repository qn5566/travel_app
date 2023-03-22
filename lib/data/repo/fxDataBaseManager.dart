import '../appDatabase.dart';

const dbName = "travelDb.db";

class FxDataBaseManager {
  static database() async {
    final database = await $FloorAppDatabase.databaseBuilder(dbName).build();
    return database;
  }

  static dataAllDao() async {
    final db = await database();
    return db.dataAllDao;
  }
}
