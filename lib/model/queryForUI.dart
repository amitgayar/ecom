import 'dart:async' show Future;
import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
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
    print(table + ' ' +colName + ' ' + operator + ' ' + id + ' ' + '..count.. : ' +queryList.length.toString());
//    print('First one is : ' + queryList.first.toString());
//    print(queryList);
    return queryList;

  }
  else {
  final queryList = await dbHelper.raw_query(raw);
  print(table + ' ' +colName + ' ' + operator + ' ' + id + ' ' + '..count.. : ' +queryList.length.toString());
//    print('First one is : ' + queryList.first.toString());
//  print(queryList);
  return queryList;
  }



}

Future<dynamic> q(String type, String category_id, String text) async{
  if (type == 'initStack'){
    var allProducts = await queryForUI('products', '', '', '');
//    var allCategories = await queryForUI('productCatogories','', '', '');
    var allCustomProducts = await queryForUI('customProducts', '', '', '');
//    var data =  allCategories + allCustomProducts + allProducts ;
    var data =  allCustomProducts + allProducts ;
//          print(initSearch);
    return data;
  }
  else if (type == 'secondStack'){
    var allProducts = await queryForUI('products', 'category_id', '=', category_id);
    var allCategories = await queryForUI('productCatogories', 'parent_id', '=', category_id);
    var allCustomProducts = await queryForUI('customProducts', 'category_id', '=', category_id);
    var data = allCategories + allCustomProducts + allProducts ;
//          print(initSearch);
    return data;
  }
  else if (type == 'thirdStack'){
    var allProducts = await queryForUI('products', 'category_id', '=', category_id);
    var allCategories = await queryForUI('productCatogories', 'parent_id', '=', category_id);
    var allCustomProducts = await queryForUI('customProducts', 'category_id', '=', category_id);
  var data = allCategories + allCustomProducts + allProducts ;
//          print(initSearch);
    return data;
  }
  else if (type == 'initSearch'){
    var allProducts = await queryForUI('products', 'name', 'LIKE', text);
//    var allCategories = await queryForUI('productCatogories', 'name', 'LIKE', text);
    var allCustomProducts = await queryForUI('customProducts', 'name', 'LIKE', text);
//    var data = allCategories + allCustomProducts + allProducts ;
    var data =  allCustomProducts + allProducts ;
//          print(initSearch);
    return data;
  }
  else if (type == 'secondSearch'){
    var allProducts = await queryForUI('products', 'category_id', '=', category_id);
    allProducts = allProducts.where((p) => p['name'] == text);
//    var allCategories = await queryForUI('productCatogories', 'parent_id', '=', category_id);
    var allCustomProducts = await queryForUI('customProducts', 'category_id', '=', category_id);
    allCustomProducts = allCustomProducts.where((p) => p['name'] == text);
//  var data = allCategories + allCustomProducts + allProducts ;
    var data =  allCustomProducts + allProducts ;
//          print(initSearch);
    return data;
  }
  else if (type == 'thirdSearch'){
    var allProducts = await queryForUI('products', 'category_id', '=', category_id);
    var allCategories = await queryForUI('productCatogories', 'parent_id', '=', category_id);
    var allCustomProducts = await queryForUI('customProducts', 'category_id', '=', category_id);
    var data = allCategories + allCustomProducts + allProducts ;
//          print(initSearch);
    return data;
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