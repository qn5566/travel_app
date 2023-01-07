import 'db_helper.dart';
import 'db_search_bean.dart';

/// 数据操作类
class DbTravelDao {
  /// 增
  static insert(String text) {
    // 去重
    queryAll().then((value) {
      bool isAdd = true;
      for (var data in value) {
        if (data.title == text) {
          isAdd = false;
          break;
        }
      }
      if (isAdd) {
        DbHelper.instance.getDb()?.then((value) => value.insert(
              DbHelper.searchTab,
              DbTravelBean(title: text).toJson(),
            ));
      }
    });
  }

  /// 删 全部
  static deleteAll() {
    DbHelper.instance.getDb()?.then((value) => value.delete(
          DbHelper.searchTab,
        ));
  }

  /// 更新数据 通过id更新表内具体行的数据
  static update(DbTravelBean dbSearchHotBean) {
    DbHelper.instance.getDb()?.then((value) =>
        value.update(DbHelper.searchTab, dbSearchHotBean.toJson(), //具体更新的数据
            where: "id = ?" //通过id查找需要更新的数据
            ,
            whereArgs: [dbSearchHotBean.id]));
  }

  /// 通过name查具体的实体类
  static Future<DbTravelBean?> getBean(String name) async {
    var db = await DbHelper.instance.getDb();
    var maps = await db?.query(DbHelper.searchTab,
        columns: ['id', 'name'], // 获取实体类的哪些字段 默认全部
        where: 'name = ?', //通过实体类中的name字段
        whereArgs: [name]); //具体name的值 限定数据
    if (maps != null && maps.length > 0) {
      return DbTravelBean.fromJson(maps.first);
    }
    return null;
  }

  /// 查 全部all
  static Future<List<DbTravelBean>> queryAll() async {
    List<DbTravelBean> list = [];
    await DbHelper.instance
        .getDb()
        ?.then((db) => db.query(DbHelper.searchTab).then((value) {
              for (var data in value) {
                list.add(DbTravelBean.fromJson(data));
              }
            }));
    return list;
  }
}
