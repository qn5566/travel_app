import 'package:travel/data/database/sqliteHelper.dart';

import 'baseDb.dart';

/// 實例DB mode
class CategoryDb extends BaseDb {
  CategoryDb() : super(SqliteHelper.tableTravel);
}
