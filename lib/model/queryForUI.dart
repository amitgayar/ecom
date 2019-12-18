import 'dart:async' show Future;
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';

import '../Constants/const.dart';
import '../Databases/Database.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../model/ProcessJsonToUpdateDB.dart';
import '../Utilities/DBsync.dart';
import '../model/Database_Models.dart';
import 'app_state_model.dart';
import 'package:scoped_model/scoped_model.dart';

final dbHelper = DatabaseHelper.instance;



NewAppStateModel cartModel = new NewAppStateModel();

Future<List<Map<String, dynamic>>> queryForUI(String table, String colName,  String operator, String id) async {

  String raw = "SELECT * FROM $table WHERE UPPER($colName) $operator UPPER('%$id%')";

  if (id == '' && colName == '' && operator == '' ){
    final _dbProducts = await dbHelper.queryAllRows(table);
    print('Total rows in table - ' + table + '...:...' + _dbProducts.length.toString());
//    print('First entry is : ' + _dbProducts.first.toString());
//    print(_dbProducts);
    return _dbProducts;

  }

  else if (table == '') {
    final queryList = await dbHelper.queryRow(table,  id,  colName,  operator);
    print(table + ' ' +colName + ' ' + operator + ' ' + id + ' ' + '..count.. : s' +queryList.length.toString());
//    print('First one is : ' + queryList.first.toString());
//    print(queryList);
    return queryList;

  }
  else {
  final queryList = await dbHelper.raw_query(raw);
  print(table + ' ' +colName + ' ' + operator + ' ' + id + ' ' + '..count.. : s' +queryList.length.toString());
//    print('First one is : ' + queryList.first.toString());
//  print(queryList);
  return queryList;
  }



}

Future<dynamic> q(String text) async{
  if (text == 'firstSearch'){
    var allProducts = await queryForUI('products', 'name', 'Like', text);
//          print(allProducts);
    return allProducts;
  }

}

dynamic addProductToCart(NewAppStateModel cartModel, Map<String, dynamic> product){
//  cartModel.loadProducts([product]); ...................                  ...............     .................................
  cartModel.addProductToCart(product['id']);
}
dynamic getProducts(NewAppStateModel cartModel){
  return cartModel.getProducts();
}


dynamic removeItemFromCart(NewAppStateModel cartModel, Map<String, dynamic> product){
  cartModel.removeItemFromCart(product['id']);
}