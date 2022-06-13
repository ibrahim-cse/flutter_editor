import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/user_model.dart';

class DbHelper {
  static Database? _db;

  static const String dbName = 'info.db';
  static const String tableUser = 'user';
  static const int version = 1;

  static const String cUserName = 'userName';
  static const String cEmail = 'email';
  static const String cPhone = 'phone';
  static const String cAddress = 'address';
  static const String cPassword = 'password';

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    var db = await openDatabase(path, version: version, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE $tableUser ("
        " $cUserName TEXT, "
        " $cEmail TEXT,"
        " $cPhone TEXT,"
        " $cAddress TEXT,"
        " $cPassword TEXT,"
        "PRIMARY KEY ($cEmail)"
        ")");
  }

  Future<int> saveData(UserModel user) async {
    var dbClient = await db;
    var res = await dbClient.insert(tableUser, user.toMap());
    return res;
  }

  Future<UserModel?> getLoginUser(String email, String password) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $tableUser WHERE "
        "$cEmail = '$email' AND "
        "$cPassword = '$password'");

    if (res.length > 0) {
      return UserModel.fromMap(res.first);
    }
    return null;
  }
}
