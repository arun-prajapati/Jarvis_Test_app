import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'models/userModel.dart';
class mainDB{
  var database;

  createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'my.db');

    var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
    return database;
  }


  void populateDb(Database database, int version) async {
    await database.execute("CREATE TABLE users ("
        "id INTEGER PRIMARY KEY,"
        "first_name TEXT,"
        "last_name TEXT,"
        "email TEXT,"
        "image TEXT"
        ")");
  }

  Future<int> createUser(Data data) async {
    var result = await database.insert("users", data);
    return result;
  }

  Future<List> getUsers() async {
    var result = await database.rawQuery('SELECT * FROM users');
    return result.toList();
  }

}