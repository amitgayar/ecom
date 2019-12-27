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
import 'manageCustomers.dart';
import 'package:scoped_model/scoped_model.dart';

final dbHelper = DatabaseHelper.instance;



//NewAppStateModel cartModel = new NewAppStateModel();

Future<List<Map<String, dynamic>>> queryForUI(String table, String colName,  String operator, String id, {String colName2:'', String category_id:''}) async {
  String raw;
  if (colName == 'name' && category_id == ''){
    raw = "SELECT * FROM $table WHERE $colName $operator LOWER('%$id%') ORDER BY LOWER('name') ASC";
  }
  else if (category_id != ''){

    raw = "SELECT * FROM $table WHERE LOWER('%$colName%') $operator LOWER('%$id%') AND $colName2 = $category_id ORDER BY LOWER('name') ASC";
  }
  else {
    raw = "SELECT * FROM $table WHERE $colName $operator $id ORDER BY LOWER('name') ASC";
  }

  if (id == '' && colName == '' && operator == '' ){

    if (table == 'productCategories'){

      String rawQueryForParentCategories = "SELECT * FROM ${DatabaseHelper.productCategoriesTable} WHERE ${DatabaseHelper.parent_id} = 'null' ORDER BY LOWER('name') ASC" ;
      final queryList = await dbHelper.raw_query(rawQueryForParentCategories);
      return queryList;
    }
    else{
      raw = "SELECT * FROM $table ORDER BY LOWER('name') ASC";

      final _dbProducts = await dbHelper.raw_query(raw);
      print('Total rows in table - ' + table + '...:...' + _dbProducts.length.toString());
//    print('First entry is : ' + _dbProducts.first.toString());
//    print(_dbProducts);
      return _dbProducts;
    }


  }

//  else if (table == '') {
//    final queryList = await dbHelper.queryRow(table,  id,  colName,  operator);
//    print(table + ' ' +colName + ' ' + operator + ' ' + id + ' ' + '..count.. : ' +queryList.length.toString());
////    print('First one is : ' + queryList.first.toString());
////    print(queryList);
//    return queryList;

//  }
  else {
    print(raw);
    final queryList = await dbHelper.raw_query(raw);
    print(table + ' ' +colName + ' ' + operator + ' ' + id.toString() + ' ' + '..count.. : ' +queryList.length.toString());
//    print('First one is : ' + queryList.first.toString());
//  print(queryList);
    return queryList;
  }



}






Future<void> queryForAll(NewAppStateModel cartModel, String type, String category_id, String text ) async{
  if (type == 'initStack'){
//    var allProducts = await queryForUI('products', '', '', '');
    var allCategories = await queryForUI('productCategories','', '', '');

    print( allCategories[1]['parent_id']);
    var allCustomProducts = await queryForUI('customProducts', '', '', '');

    cartModel.setData(null,  allCategories, allCustomProducts);


  }
  else if (type == 'secondStack'){
    var allProducts = await queryForUI('products', 'category_id', '=', category_id);
    var allCategories = await queryForUI('productCategories', 'parent_id', '=', category_id);
    var allCustomProducts = await queryForUI('customProducts', 'category_id', '=', category_id);

    cartModel.setData(allProducts, allCategories, allCustomProducts);


  }

  else if (type == 'initSearch'){
    var allProducts = await queryForUI('products', 'name', 'LIKE', text);
    var allCategories = await queryForUI('productCategories', 'name', 'LIKE', text);
    var allCustomProducts = await queryForUI('customProducts', 'name', 'LIKE', text);


    cartModel.setData(allProducts, allCategories, allCustomProducts);

  }



}

void searchCatalogue(NewAppStateModel cartModel, String text) async{
  if(text.length>2){
    await queryForAll(cartModel, 'initSearch', '', text);
  }
  else if(text.length<2) {
    Map<String, dynamic> category = cartModel.stack.last;
    if (category == null){
      await queryForAll(cartModel, 'initStack', '', '');
    }
    else{
      await queryForAll(cartModel, 'secondStack', category['id'].toString(), '');
    }

  }

}

void onTapCategoryEntry(NewAppStateModel cartModel, Map<String, dynamic> category) async {
  cartModel.setStack(category);
  await queryForAll(cartModel, 'secondStack', category['id'].toString(), '');
  cartModel.setCategory(category['name']);
}

void goToParentCategory(NewAppStateModel cartModel) async{
  cartModel.setStack(null);
  Map<String, dynamic> category = cartModel.stack.last;
  if (category == null){
    await queryForAll(cartModel, 'initStack', '', '');
    cartModel.setCategory('');
  }
  else{
    await queryForAll(cartModel, 'secondStack', category['id'].toString(), '');
    cartModel.setCategory(category['name']);
  }
}



dynamic getProducts(NewAppStateModel cartModel){
  return cartModel.getProducts();
}



List<Map<String, dynamic>> mapQuery(List<Map<String, dynamic>> query) {
  List<Map<String, dynamic>> mapList = [];
  for (var row in query) {
    Map<String, dynamic> map = row.map((key, value) => MapEntry(key, value));
    mapList.add(map);
  }
  return mapList;
}

//void  _getCustomersG(manageCustomersModel model) async{
//  var customerList = await model.queryCustomerInDatabase('all', '');
//  model.setCustomerListData(customerList);
//
//}
//
//List<Map<String, dynamic>> getCustomersG(manageCustomersModel model){
//  _getCustomersG(model);
//  List<Map<String, dynamic>> customerList;
//  customerList = model.customersInDatabaseToDisplay;
//  print('gayar in qUI\n\n' + customerList.toString());
//  return customerList;
//}

