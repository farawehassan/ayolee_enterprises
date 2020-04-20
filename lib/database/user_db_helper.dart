import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:ayolee_stores/model/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;
  final String USER_TABLE = "User";

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "user.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE $USER_TABLE("
            "id TINYINT PRIMARY KEY NOT NULL,"
            "name TEXT NOT NULL,"
            "email TEXT NOT NULL,"
            "type TEXT NOT NULL,"
            "created_at TEXT NOT NULL,"
            "token TEXT NOT NULL)");
    print("Created tables");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  /// Get user
  Future<User> getUser () async {
    var dbConnection = await db;
    List<Map> users = await dbConnection.rawQuery('SELECT * FROM $USER_TABLE');
    User userVal;
    for(int i = 0; i < users.length; i++){
      User user = new User(
        users[0]['id'],
        users[0]['name'],
        users[0]['email'],
        users[0]['type'],
        users[0]['created_at'],
        users[0]['token']
      );
      userVal = user;
    }
    return userVal;
  }

  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query(USER_TABLE);
    return res.length > 0? true: false;
  }

}