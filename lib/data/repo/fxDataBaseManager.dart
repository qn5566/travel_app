import '../appDatabase.dart';
import '../dao/dataAllDao.dart';
import 'package:floor/floor.dart';

const dbName = "travelDb.db";

class FxDataBaseManager {
  static Future<AppDatabase>? _databaseFuture;

  static Future<AppDatabase> database() {
    return _databaseFuture ??=
        $FloorAppDatabase.databaseBuilder(dbName).addMigrations([
      Migration(1, 2, (database) async {
        await database.execute('ALTER TABLE DataAll ADD COLUMN rawJson TEXT');
      }),
      Migration(2, 3, (database) async {
        // Version 3 switches the source to the v2 ZIP snapshot. Existing
        // rows must not be reused because they were created from the old API
        // (and may contain the old coordinate layout).
        await database.execute('DELETE FROM DataAll');
      }),
    ]).build();
  }

  static Future<DataAllDao> dataAllDao() async {
    final db = await database();
    return db.dataAllDao;
  }
}
