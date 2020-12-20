import 'dart:async';
import 'model.dart';
import 'package:sqflite/sqflite.dart';

abstract class DB {

  static Database _db;

  static int get _version => 1;

  static Future<void> init() async {

    if (_db != null) { return; }

    try {
      String _path = await getDatabasesPath() + 'teamExample';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    }
    catch(ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async =>
      await db.execute('CREATE TABLE team (id INTEGER PRIMARY KEY NOT NULL, name STRING, points INTEGER, next INTEGER)');

  static Future<List<Map<String, dynamic>>> query(String table) async => _db.query(table);

  static Future<int> insert(String table, Model model) async =>
      await _db.insert(table, model.toMap());

  static Future<int> update(String table, Model model) async =>
      await _db.update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, Model model) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);

  static Future<List<Map<String, dynamic>>> queryOne(String table, int id) async => _db.query(table, where: "id = ?", whereArgs: [id]);

  static Future<List<Map<String, dynamic>>> queryById(String table) async => _db.rawQuery("select * from team");

  static Future<List<Map<String, dynamic>>> queryTakeFirst(String table) async => _db.rawQuery("select * from team limit 1");

  static Future<List<Map<String, dynamic>>> queryTakeCurrent(String table) async => _db.rawQuery("select * from team where next=1");

  static Future<List<Map<String, dynamic>>> queryTakeNext(String table, int currentId) async => _db.rawQuery("select * from team where id > " + currentId.toString() + " limit 1");

  static Future<List<Map<String, dynamic>>> queryTakePossibleWinners(String table) async => _db.rawQuery("select * from team where points > 15");

  static Future<List<Map<String, dynamic>>> queryTakeWinner(String table) async => _db.rawQuery("select * from team ORDER BY points desc limit 1");

  static Future<List<Map<String, dynamic>>> queryIsNextRound(String table) async => _db.rawQuery("select * from team where next=1");


  static getTeam(int id) async {
    var res = await _db.query("Team", where: "id = ?", whereArgs: [id]);
    print('res');
    print(res);
    return res;
    //return res.isNotEmpty ? Model.fromMap(res.first) : null;
  }

  static void deleteAll() async =>
      await _db.delete('team');
}