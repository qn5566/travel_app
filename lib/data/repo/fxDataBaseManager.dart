import '../appDatabase.dart';
import '../dao/dataAllDao.dart';

const dbName = "travelDb.db";

class FxDataBaseManager {
  static Future<AppDatabase>? _databaseFuture;

  static Future<AppDatabase> database() {
    return _databaseFuture ??=
        $FloorAppDatabase.databaseBuilder(dbName).build();
  }

  static Future<DataAllDao> dataAllDao() async {
    final db = await database();
    return db.dataAllDao;
  }
}
