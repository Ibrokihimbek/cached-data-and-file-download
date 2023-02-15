import 'package:cached_vc_download/data/models/users_model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static String tableName = "users";
  static LocalDatabase getInstance = LocalDatabase._init();
  Database? _database;

  LocalDatabase._init();

  Future<Database> getDb() async {
    if (_database == null) {
      _database = await _initDB("users.db");
      return _database!;
    }
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, fileName);

    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
        String textType = "TEXT";
        String intType = "INTEGER";
        String boolType = "INTEGER";

        await db.execute('''
        CREATE TABLE $tableName (
            ${UserFields.id} $idType,
            ${UserFields.name} $textType,
            ${UserFields.username} $textType,
            ${UserFields.state} $textType,
            ${UserFields.avatarUrl} $textType
            )
            ''');
      },
    );
    return database;
  }

  static Future<UserModel> insertUser(
      {required UserModel userModel}) async {
    var database = await getInstance.getDb();
    int id = await database.insert(tableName, userModel.toJson());
    debugPrint("ADD BOLDI HAMMASI YAXSHI");
    return userModel.copyWith(id: id);
  }



  static Future<List<UserModel>> getCachedUsers() async {
    var database = await getInstance.getDb();
    var listOfTodos = await database.query(
      tableName,
      columns: [
        UserFields.id,
        UserFields.name,
        UserFields.state,
        UserFields.username,
        UserFields.avatarUrl,
      ],
    );

    var list = listOfTodos.map((e) => UserModel.fromJson(e)).toList();

    return list;
  }

  static Future<List<UserModel>> getTaskByTitle({String title = ''}) async {
    var database = await getInstance.getDb();

    if (title.isNotEmpty) {
      var listOfTodos = await database.query(
        tableName,
        where: 'title LIKE ?',
        whereArgs: ['%$title%'],
      );
      var list = listOfTodos.map((e) => UserModel.fromJson(e)).toList();
      return list;
    } else {
      var listOfTodos = await database.query(
        tableName,
        columns: [
          UserFields.id,
          UserFields.name,
          UserFields.state,
          UserFields.username,
          UserFields.avatarUrl,
        ],
      );

      var list = listOfTodos.map((e) => UserModel.fromJson(e)).toList();
      return list;
    }
  }

  static Future<int> deleteContactById({required int id}) async {
    var database = await getInstance.getDb();
    return await database.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> deleteAll() async {
    var database = await getInstance.getDb();
    return await database.delete(tableName);
  }
}