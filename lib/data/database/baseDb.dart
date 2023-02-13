import 'package:sqflite/sqflite.dart';
import 'package:travel/data/database/sqliteHelper.dart';

/// DB 基本mode
class BaseDb {
  BaseDb(this.table);

  late String table;
  final SqliteHelper _sql = SqliteHelper();
  late Database db;

  Future open() async {
    db = await _sql.db;
  }

  Future close() async {
    _sql.close();
  }

  checkTableIsEmpty() async {
    int? count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
    return count;
  }

  insert(Map<String, dynamic> m) async {
    return await db.insert(table, m);
  }

  queryAll({int? limit}) async {
    return await db.query(table, limit: limit);
  }

  update(Map<String, dynamic> m) async {
    return await db.update(table, m, where: 'Id = ?', whereArgs: [m['Id']]);
  }

  autoCheckInsertOrUpdate(Map<String, dynamic> m) async {
    var map = await query('Id = ?', [m['Id']]);
    if (map.length > 0) {
      await update(m);
    } else {
      await insert(m);
    }
  }

  delete({String? where, List<Object?>? whereArgs}) async {
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  query(String where, List<Object?>? whereArgs) async {
    return await db.query(table, where: where, whereArgs: whereArgs);
  }

  queryWhere(String where) async {
    return await db.query(table, where: where);
  }

  isExist(String where, List<Object?>? whereArgs) async {
    return await query(where, whereArgs) != null;
  }
}
