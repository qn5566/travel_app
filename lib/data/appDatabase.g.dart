// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  DataAllDao? _dataAllDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `DataAll` (`id` TEXT, `name` TEXT, `zone` TEXT, `toldescribe` TEXT, `description` TEXT, `tel` TEXT, `address` TEXT, `zipcode` TEXT, `region` TEXT, `town` TEXT, `travellinginfo` TEXT, `opentime` TEXT, `picture1` TEXT, `picdescribe1` TEXT, `picture2` TEXT, `picdescribe2` TEXT, `picture3` TEXT, `picdescribe3` TEXT, `map` TEXT, `gov` TEXT, `px` REAL, `py` REAL, `orgclass` TEXT, `class1` TEXT, `class2` TEXT, `class3` TEXT, `level` TEXT, `website` TEXT, `parkinginfo` TEXT, `parkinginfoPx` REAL, `parkinginfoPy` REAL, `ticketinfo` TEXT, `remarks` TEXT, `keyword` TEXT, `changetime` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  DataAllDao get dataAllDao {
    return _dataAllDaoInstance ??= _$DataAllDao(database, changeListener);
  }
}

class _$DataAllDao extends DataAllDao {
  _$DataAllDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _dataAllInsertionAdapter = InsertionAdapter(
            database,
            'DataAll',
            (DataAll item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'zone': item.zone,
                  'toldescribe': item.toldescribe,
                  'description': item.description,
                  'tel': item.tel,
                  'address': item.address,
                  'zipcode': item.zipcode,
                  'region': item.region,
                  'town': item.town,
                  'travellinginfo': item.travellinginfo,
                  'opentime': item.opentime,
                  'picture1': item.picture1,
                  'picdescribe1': item.picdescribe1,
                  'picture2': item.picture2,
                  'picdescribe2': item.picdescribe2,
                  'picture3': item.picture3,
                  'picdescribe3': item.picdescribe3,
                  'map': item.map,
                  'gov': item.gov,
                  'px': item.px,
                  'py': item.py,
                  'orgclass': item.orgclass,
                  'class1': item.class1,
                  'class2': item.class2,
                  'class3': item.class3,
                  'level': item.level,
                  'website': item.website,
                  'parkinginfo': item.parkinginfo,
                  'parkinginfoPx': item.parkinginfoPx,
                  'parkinginfoPy': item.parkinginfoPy,
                  'ticketinfo': item.ticketinfo,
                  'remarks': item.remarks,
                  'keyword': item.keyword,
                  'changetime': item.changetime
                }),
        _dataAllDeletionAdapter = DeletionAdapter(
            database,
            'DataAll',
            ['id'],
            (DataAll item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'zone': item.zone,
                  'toldescribe': item.toldescribe,
                  'description': item.description,
                  'tel': item.tel,
                  'address': item.address,
                  'zipcode': item.zipcode,
                  'region': item.region,
                  'town': item.town,
                  'travellinginfo': item.travellinginfo,
                  'opentime': item.opentime,
                  'picture1': item.picture1,
                  'picdescribe1': item.picdescribe1,
                  'picture2': item.picture2,
                  'picdescribe2': item.picdescribe2,
                  'picture3': item.picture3,
                  'picdescribe3': item.picdescribe3,
                  'map': item.map,
                  'gov': item.gov,
                  'px': item.px,
                  'py': item.py,
                  'orgclass': item.orgclass,
                  'class1': item.class1,
                  'class2': item.class2,
                  'class3': item.class3,
                  'level': item.level,
                  'website': item.website,
                  'parkinginfo': item.parkinginfo,
                  'parkinginfoPx': item.parkinginfoPx,
                  'parkinginfoPy': item.parkinginfoPy,
                  'ticketinfo': item.ticketinfo,
                  'remarks': item.remarks,
                  'keyword': item.keyword,
                  'changetime': item.changetime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DataAll> _dataAllInsertionAdapter;

  final DeletionAdapter<DataAll> _dataAllDeletionAdapter;

  @override
  Future<int?> checkTableIsEmpty() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM DataAll',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<DataAll>> getAllDataAll() async {
    return _queryAdapter.queryList('SELECT * FROM DataAll',
        mapper: (Map<String, Object?> row) => DataAll(
            id: row['id'] as String?,
            name: row['name'] as String?,
            zone: row['zone'] as String?,
            toldescribe: row['toldescribe'] as String?,
            description: row['description'] as String?,
            tel: row['tel'] as String?,
            address: row['address'] as String?,
            zipcode: row['zipcode'] as String?,
            region: row['region'] as String?,
            town: row['town'] as String?,
            travellinginfo: row['travellinginfo'] as String?,
            opentime: row['opentime'] as String?,
            picture1: row['picture1'] as String?,
            picdescribe1: row['picdescribe1'] as String?,
            picture2: row['picture2'] as String?,
            picdescribe2: row['picdescribe2'] as String?,
            picture3: row['picture3'] as String?,
            picdescribe3: row['picdescribe3'] as String?,
            map: row['map'] as String?,
            gov: row['gov'] as String?,
            px: row['px'] as double?,
            py: row['py'] as double?,
            orgclass: row['orgclass'] as String?,
            class1: row['class1'] as String?,
            class2: row['class2'] as String?,
            class3: row['class3'] as String?,
            level: row['level'] as String?,
            website: row['website'] as String?,
            parkinginfo: row['parkinginfo'] as String?,
            parkinginfoPx: row['parkinginfoPx'] as double?,
            parkinginfoPy: row['parkinginfoPy'] as double?,
            ticketinfo: row['ticketinfo'] as String?,
            remarks: row['remarks'] as String?,
            keyword: row['keyword'] as String?,
            changetime: row['changetime'] as String?));
  }

  @override
  Future<List<DataAll>> findDataAllByRegion(String region) async {
    return _queryAdapter.queryList('SELECT * FROM DataAll WHERE Region = ?1',
        mapper: (Map<String, Object?> row) => DataAll(
            id: row['id'] as String?,
            name: row['name'] as String?,
            zone: row['zone'] as String?,
            toldescribe: row['toldescribe'] as String?,
            description: row['description'] as String?,
            tel: row['tel'] as String?,
            address: row['address'] as String?,
            zipcode: row['zipcode'] as String?,
            region: row['region'] as String?,
            town: row['town'] as String?,
            travellinginfo: row['travellinginfo'] as String?,
            opentime: row['opentime'] as String?,
            picture1: row['picture1'] as String?,
            picdescribe1: row['picdescribe1'] as String?,
            picture2: row['picture2'] as String?,
            picdescribe2: row['picdescribe2'] as String?,
            picture3: row['picture3'] as String?,
            picdescribe3: row['picdescribe3'] as String?,
            map: row['map'] as String?,
            gov: row['gov'] as String?,
            px: row['px'] as double?,
            py: row['py'] as double?,
            orgclass: row['orgclass'] as String?,
            class1: row['class1'] as String?,
            class2: row['class2'] as String?,
            class3: row['class3'] as String?,
            level: row['level'] as String?,
            website: row['website'] as String?,
            parkinginfo: row['parkinginfo'] as String?,
            parkinginfoPx: row['parkinginfoPx'] as double?,
            parkinginfoPy: row['parkinginfoPy'] as double?,
            ticketinfo: row['ticketinfo'] as String?,
            remarks: row['remarks'] as String?,
            keyword: row['keyword'] as String?,
            changetime: row['changetime'] as String?),
        arguments: [region]);
  }

  @override
  Future<DataAll?> findDataAllByName(String name) async {
    return _queryAdapter.query('SELECT * FROM DataAll WHERE Name = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => DataAll(
            id: row['id'] as String?,
            name: row['name'] as String?,
            zone: row['zone'] as String?,
            toldescribe: row['toldescribe'] as String?,
            description: row['description'] as String?,
            tel: row['tel'] as String?,
            address: row['address'] as String?,
            zipcode: row['zipcode'] as String?,
            region: row['region'] as String?,
            town: row['town'] as String?,
            travellinginfo: row['travellinginfo'] as String?,
            opentime: row['opentime'] as String?,
            picture1: row['picture1'] as String?,
            picdescribe1: row['picdescribe1'] as String?,
            picture2: row['picture2'] as String?,
            picdescribe2: row['picdescribe2'] as String?,
            picture3: row['picture3'] as String?,
            picdescribe3: row['picdescribe3'] as String?,
            map: row['map'] as String?,
            gov: row['gov'] as String?,
            px: row['px'] as double?,
            py: row['py'] as double?,
            orgclass: row['orgclass'] as String?,
            class1: row['class1'] as String?,
            class2: row['class2'] as String?,
            class3: row['class3'] as String?,
            level: row['level'] as String?,
            website: row['website'] as String?,
            parkinginfo: row['parkinginfo'] as String?,
            parkinginfoPx: row['parkinginfoPx'] as double?,
            parkinginfoPy: row['parkinginfoPy'] as double?,
            ticketinfo: row['ticketinfo'] as String?,
            remarks: row['remarks'] as String?,
            keyword: row['keyword'] as String?,
            changetime: row['changetime'] as String?),
        arguments: [name]);
  }

  @override
  Future<void> insertDataAll(DataAll dataAll) async {
    await _dataAllInsertionAdapter.insert(dataAll, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertUpdateDataAll(DataAll dataAll) async {
    await _dataAllInsertionAdapter.insert(dataAll, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteDataAll(DataAll dataAll) async {
    await _dataAllDeletionAdapter.delete(dataAll);
  }
}
