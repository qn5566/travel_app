import 'package:sqflite/sqflite.dart';

class SqliteHelper {
  static String sqlFileName = "myDb.sql";
  static int version = 1;

  static const tableTravel = "travel";

  static const createTravel = '''
        CREATE TABLE IF NOT EXISTS $tableTravel (
        Id TEXT PRIMARY KEY, 
        Title TEXT, 
        Zone TEXT,  
        Toldescribe TEXT, 
        Description TEXT, 
        Tel TEXT, 
        Address TEXT, 
        Zipcode TEXT, 
        Region TEXT, 
        Town TEXT, 
        Travellinginfo TEXT,  
        Opentime TEXT, 
        Picture1 TEXT, 
        Picdescribe1 TEXT, 
        Picture2 TEXT, 
        Picdescribe2 TEXT, 
        Picture3 TEXT,
        Picdescribe3 TEXT, 
        Map TEXT,  
        Gov TEXT, 
        Px TEXT, 
        Py TEXT, 
        Orgclass TEXT, 
        Class1 TEXT, 
        Class2 TEXT, 
        Class3 TEXT, 
        Site_level TEXT,  
        Website TEXT, 
        Parkinginfo TEXT, 
        Parkinginfo_Px TEXT, 
        Parkinginfo_Py TEXT, 
        Ticketinfo TEXT, 
        Remarks TEXT,
        Keyword TEXT, 
        Changetime TEXT
        );
        ''';

  final String dropPoetry = "DROP TABLE IF EXISTS $tableTravel";

  late Database _db;

  Future<Database> get db async {
    _db = await _initDb();
    return _db;
  }

  _initDb() async {
    String path = "${await getDatabasesPath()}/${SqliteHelper.sqlFileName}";
    Database db = await openDatabase(path,
        version: version, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  Future close() async {
    if (_db.isOpen) {
      return _db.close();
    }
  }

  void _onCreate(Database db, int newVersion) async {
    var batch = db.batch();
    batch.execute(createTravel);
    await batch.commit();
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // myLog("Database _onUpgrade oldVersion:$oldVersion");
    // myLog("Database _onUpgrade newVersion:$newVersion");
    // var batch = db.batch();
    // if(oldVersion == 1){
    //   batch.execute(dropPoetry);
    //   batch.execute(createPoetry);
    // }
    //
    // await batch.commit();
  }
}
