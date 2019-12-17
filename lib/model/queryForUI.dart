import 'dart:async' show Future;
import 'dart:async';
import 'dart:math';
import '../Constants/const.dart';
import '../Databases/Database.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../model/ProcessJsonToUpdateDB.dart';
import '../Utilities/DBsync.dart';
import '../model/Database_Models.dart';



final dbHelper = DatabaseHelper.instance;


Future<List<Map<String, dynamic>>> queryForUI(String table, String colName,  String operator, String id) async {


  if (id == '' && colName == '' && operator == '' ){
    final allList = await dbHelper.queryAllRows(table);
    print('Got all rows in : ' + table + '...:...' + allList.length.toString());
    print('First one is : ' + allList.first.toString());
    return allList;

  }

 else {
    final queryList = await dbHelper.queryRow(table,  id,  colName,  operator);
    print(table +colName + operator + id + '..count..:' +queryList.length.toString());
    print('First one is : ' + queryList.first.toString());

    return queryList;
  }


}

//final dbHelper = DatabaseHelper.instance;
Future<List<Map<String, dynamic>>> db(String dbTable, String column, String id, String operator) async{
  List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(dbTable, id, DatabaseHelper.name, "=");
  print('fhfhfhf');
  return listOfItems;
}
//
//Future<int> insert(String table, Map<String, dynamic> row) async {
//  Database db = await instance.database;
//  return await db.insert(table, row);
//}
//
//
//Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
//  Database db = await instance.database;
//  return await db.query(table);
//}
//
//Future<List<Map<String, dynamic>>> queryRow(String table, String id, String colName, String operator) async {
//  Database db = await instance.database;
//  var res = await  db.query(table, where: "$colName $operator ?", whereArgs: [id]);
//  return res;
//}
//
//
//Future<List<Map<String, dynamic>>> querySyncRow(String table, String id, String colName, String operator) async {
//  Database db = await instance.database;
//  var res = await  db.query(table, where: "$colName $operator ?", whereArgs: [id], orderBy: DatabaseHelper.updated_at);
//  return res;
//}
//
//
//
//
//Future<int> update(String table, Map<String, dynamic> row, String colName, int id) async {
//  Database db = await instance.database;
//  String Col_Name = colName;
//  return await db.update(table, row, where: '$Col_Name = ?', whereArgs: [id]);
//}
//
//// Deletes the row specified by the id. The number of affected rows is
//// returned. This should be 1 as long as the row exists.
//Future<int> delete(String table, int id) async {
//  Database db = await instance.database;
//  return await db.delete(table, where: '$id = ?', whereArgs: [id]);
//}