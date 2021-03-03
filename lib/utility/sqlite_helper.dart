import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ungexercies/models/sqlite_model.dart';
import 'package:ungexercies/utility/helper.dart';

class SQLiteHelper {
  final String namedatabase = 'lekproductdb';
  final String namedatabase2 = 'lekdb2';
  final String nametable = 'ordertable';
  final String nametable2 = 'ordertable2';
  final String idcolumn = 'id';
  final String idcode = 'code';
  final String uid = 'uid';
  final String namecolum = 'name';
  final String barcodecolumn = 'barcodes';
  final String pricecolumn = 'prices';
  final String unitcolumn = 'units';
  final String amountcolumn = 'amounts';
  final String subtotalcolumn = 'subtotals';
  final String pictcolumn = 'picturl';
  final int databaseversion = 1;

  SQLiteHelper() {
    initDatabase();
    initDatabase2();
  }

  Future<Null> initDatabase() async {
    await openDatabase(join(await getDatabasesPath(), namedatabase),
        onCreate: (db, version) => db.execute(
            'CREATE TABLE $nametable ($idcolumn INTEGER PRIMARY KEY, $idcode TEXT, $namecolum TEXT, $barcodecolumn TEXT, $pricecolumn TEXT, $unitcolumn TEXT, $amountcolumn INTEGER, $subtotalcolumn TEXT,$pictcolumn TEXT, $uid TEXT)'),
        version: databaseversion);
  }

  Future<Null> initDatabase2() async {
    await openDatabase(join(await getDatabasesPath(), namedatabase),
        onCreate: (db, version) => db.execute(
            'CREATE TABLE $nametable2 (id INTEGER PRIMARY KEY, $idcode TEXT, $namecolum TEXT, $barcodecolumn TEXT, $pricecolumn TEXT, $unitcolumn TEXT, $amountcolumn INTEGER, $subtotalcolumn TEXT)'),
        version: databaseversion);
  }

  Future<Database> connectedDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), namedatabase),
    );
  }


  Future<Database> connectedDatabase2() async {
    return await openDatabase(
      join(await getDatabasesPath(), namedatabase2),
    );
  }

  Future<Null> insertValueToSQLite(Map<String, dynamic> map) async {
    Database database = await connectedDatabase();
    try {
      database.insert(nametable, map,
          conflictAlgorithm: ConflictAlgorithm.replace);
      print('#########Insert SQLite Success');
    } catch (e) {
      print('###########e insert SQLite ===>>> ${e.toString()}');
    }
  }

  Future<Null> insertValueToSQLite2(Map<String, dynamic> map) async {
    Database database = await connectedDatabase2();
    try {
      database.insert(nametable, map,
          conflictAlgorithm: ConflictAlgorithm.replace);
      print('#########Insert SQLite Success');
    } catch (e) {
      print('###########e insert SQLite ===>>> ${e.toString()}');
    }
  }

  Future<List<SQLiteModel>> readSQLite() async {
    Helper helper = new Helper();
    
     String _uid = await helper.getStorage('uid');
    try {
      print('#####>>> readSQLite work');
      Database database = await connectedDatabase();
      List<SQLiteModel> sqliteModels = List();
      List<Map<String, dynamic>> maps = await database.query(nametable,  where: '$amountcolumn >0 ');
      for (var item in maps) {
        SQLiteModel model = SQLiteModel.fromMap(item);
        sqliteModels.add(model);
      }
      return sqliteModels;
    } catch (e) {
      print('########==>>> e readSQLite ===>>>${e.toString()}');
      return null;
    }
  }

   Future<List<SQLiteModel>> readSQLite2() async {
    try {
      print('#####>>> readSQLite work');
      Database database = await connectedDatabase2();
      List<SQLiteModel> sqliteModels = List();
      List<Map<String, dynamic>> maps = await database.query(nametable2);
      for (var item in maps) {
        SQLiteModel model = SQLiteModel.fromMap(item);
        sqliteModels.add(model);
      }
      return sqliteModels;
    } catch (e) {
      print('########==>>> e readSQLite ===>>>${e.toString()}');
      return null;
    }
  }

  Future<Null> deleteAllData() async {
    Database database = await connectedDatabase();
    try {
      await database.delete(nametable);
    } catch (e) {}
  }

  Future<Null> deleteAllData2() async {
    Database database = await connectedDatabase2();
    try {
      await database.delete(nametable2);
    } catch (e) {}
  }

  Future<Null> deleteDataById(int id) async {
    Database database = await connectedDatabase();
    try {
      await database.delete(nametable, where: '$idcolumn = $id');
    } catch (e) {}
  }

  Future<Null> deleteDataById2(int id) async {
    Database database = await connectedDatabase2();
    try {
      await database.delete(nametable2, where: '$idcolumn = $id');
    } catch (e) {}
  }
}
