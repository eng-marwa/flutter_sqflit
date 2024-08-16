import 'package:beni2_sqflit/db/constants.dart';
import 'package:beni2_sqflit/db/db_helper.dart';
import 'package:beni2_sqflit/model/note.dart';
import 'package:sqflite/sqflite.dart';

class Curd {
  Curd._();

  static Curd op = Curd._();

  //insert
  Future<int> insert(Note note) async {
    Database db = await DbHelper.helper.getDbInstance();
    return await db.insert(tableName, note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //select
  Future<List<Note>> select() async {
    Database db = await DbHelper.helper.getDbInstance();
    List<Map<String, dynamic>> result =
        await db.query(tableName, distinct: true, orderBy: '$colDate desc');
    return result.map((e) => Note.formMap(e)).toList();
  }

  //update
  Future<int> update(Note note) async {
    Database db = await DbHelper.helper.getDbInstance();
    return await db.update(tableName, note.toMap(),
        where: '$colId=?', whereArgs: [note.id!]);
  }

  //delete
  Future<int> delete(int id) async {
    Database db = await DbHelper.helper.getDbInstance();
    return await db.delete(tableName, where: '$colId=?', whereArgs: [id]);
  }
}
