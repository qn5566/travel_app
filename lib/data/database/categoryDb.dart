import 'package:travel/data/database/sqliteHelper.dart';

import 'baseDb.dart';

class CategoryDb extends BaseDb {
  CategoryDb() : super(SqliteHelper.tableTravel);
}
