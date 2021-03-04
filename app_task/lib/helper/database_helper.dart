import 'package:app_task/model/employe.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  final String tablePegawai = 'noteTable';
  final String columId = 'id';
  final String columnFirstName = 'firstName';
  final String columnLastName = 'lastName';
  final String columnMobileNo = 'mobileNo';
  final String columnEmailId = 'emailId';
  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'employe.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tablePegawai($columId INTEGER PRIMARY KEY, $columnFirstName TEXT, $columnLastName TEXT,$columnMobileNo TEXT, $columnEmailId TEXT)');
  }

  //Save Pegawai
  Future<int> savePegawai(Employe employe) async {
    var dbClient = await db;
    var result = await dbClient.insert(tablePegawai, employe.toMap());
    return result;
  }

  //Get All Pegawai
  Future<List> getAllPegawai() async {
    var dbClient = await db;
    var result = await dbClient.query(tablePegawai, columns: [
      columId,
      columnFirstName,
      columnLastName,
      columnMobileNo,
      columnEmailId
    ]);
    return result.toList();
  }

  //Update Pegawai
  Future<int> updatePegawai(Employe employe) async {
    var dbClient = await db;
    return await dbClient.update(tablePegawai, employe.toMap(),
        where: "$columId = ?", whereArgs: [employe.id]);
  }

  //Delete Pegawai
  Future<int> deletePegawai(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tablePegawai, where: "$columId = ?", whereArgs: [id]);
  }
}
