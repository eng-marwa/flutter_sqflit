import 'package:beni2_sqflit/db/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  //1-single instance
  DbHelper._();

  static final DbHelper helper = DbHelper._();

  //2-get db path
  Future<String> _getDbPath() async {
    String path = await getDatabasesPath();
    // String myDbPath = path + "/mydb.db";
    return join(path, dbName);
  }

  //3-create or Open db
  Future<Database> getDbInstance() async {
    String path = await _getDbPath();
    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: (db, version) => _createTable(db),
      singleInstance: true,
      onUpgrade: (db, oldVersion, newVersion) => _upgradeTable(db),
    );
  }

  //4- create table
  _createTable(Database db) {
    try {
      db.execute(createTableAfterDropSql);
    } on DatabaseException catch (e) {
      print(e.toString());
    }
  }

  _upgradeTable(Database db) {
    try {
      db.execute(dropTableSql);
      _createTable(db);
    } on DatabaseException catch (e) {
      print(e.toString());
    }
  }
}
