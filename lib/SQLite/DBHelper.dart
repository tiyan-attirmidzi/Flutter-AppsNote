import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:simple_note/SQLite/mynote.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:async';

class DBHelper {
  static final DBHelper _instance = new DBHelper.internal();

  DBHelper.internal();

  factory DBHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db!=null)return _db;
    _db = await setDB();
    return _db;
  } 

  setDB()async {
    io.Directory directory  = await getApplicationDocumentsDirectory();
    String path             = join(directory.path, "SimpleNoteDB");
    var dB                  = await openDatabase(path, version: 1, onCreate: _onCreate);
    return dB;
  }

  void _onCreate(Database db, int version)async {
    await db.execute("CREATE TABLE mynote (id INTEGER PRIMARY KEY, title TEXT, note TEXT, createDate TEXT, updateDate TEXT, sortDate TEXT)");

    print("DB Created"); 
  }

  Future<int> saveNote(Mynote mynote) async{
    var dbClient  = await db;
    int res       = await dbClient.insert("mynote", mynote.toMap());
    print("data inserted"); 
    return res; 
  }

  Future<List<Mynote>> getNote() async {
    var dbClient          = await db;
    List<Map> list        = await dbClient.rawQuery("SELECT * FROM mynote ORDER BY sortDate DESC");
    List<Mynote> notedata = new List();
    for (var i = 0; i < list.length; i++) {
      var note = new Mynote(list[i]['title'], list[i]['note'], list[i]['createDate'], list[i]['updateData'], list[i]['sortDate']);
      note.setNoteId(list[i]['id']);
      notedata.add(note);
    }
    return notedata;
  }

}