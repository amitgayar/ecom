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
//var dbItemsForDisplay = await queryForUI();




//class DBAppStateModel extends Model {
//  List<Map<String, dynamic>> _dbProducts ;
//
//  double _gst = 0.0;
//  bool _toggle = true;
//  double get gst => _gst ;
//
//  List<Map<String, dynamic>>  get dbProducts => _dbProducts ;
//
//
//
//
//
//  double _salesTaxRate = 0.02;
//  double _shippingCostPerItem = 1.0;
//  // All the available products.
//  List<Map<String, dynamic>> _availableProducts = [];
//  List<Map<String, dynamic>> get availableProducts => List<Map>.from(_availableProducts);
//
//  // The currently selected category of products.
//  int _selectedCategory = 1;
//
//  // The IDs and quantities of products currently in the cart.
//  Map<int, int> _productsInCart = {};
//
//  Map<int, int> get productsInCart => Map.from(_productsInCart);
//
//  // Total number of items in the cart.
//  int get totalCartQuantity => _productsInCart.values.fold(0, (v, e) => v + e);
//
//  int get selectedCategory => _selectedCategory;
//
//
//  // Totaled prices of the items in the cart.
//  double get subtotalCost => _productsInCart.keys
//      .map((id) => _availableProducts[id]['sp'] * _productsInCart[id])
//      .fold(0.0, (sum, e) => sum + e);
//
//  // Total shipping cost for the items in the cart.
//  double get shippingCost =>
//      _shippingCostPerItem *
//          _productsInCart.values.fold(0.0, (sum, e) => sum + e);
//
//  // Sales tax for the items in the cart
//
//  double get salesTax => _salesTaxRate;
//  double get tax => subtotalCost * gst;
////  double get tax => subtotalCost * salesTax;
//
//  // Total cost to order everything in the cart.
//  double get totalCost => subtotalCost + shippingCost + tax ;
////    (subtotalCost + shippingCost + tax).toStringAsFixed(2);
//
//
//  // Returns a copy of the list of available products, filtered by category.
//  List<Map<String, dynamic>> getProducts() {
//    if (_availableProducts == null) return List<Map<String, dynamic>>();
//
//    if (_selectedCategory == 1) {
//      return List.from(_availableProducts);
//    } else {
//      return _availableProducts
//          .where((p) => p['category_id'] == _selectedCategory)
//          .toList();
//    }
//  }
//
//
//  void changeSP(double changedPrice, int id){
//    var c = _availableProducts.firstWhere((p) => p['id'] == id);
//    //print(_availableProducts0]["name"]);
//    _availableProducts.firstWhere((p) => p['id'] == id)["sp"] = _availableProducts.firstWhere((p) => p['id'] == id)["sp"] + changedPrice;
//    print("abc = ${_availableProducts.firstWhere((p) => p['id'] == id)["sp"]}");
//    print(changedPrice);
//
//    print('changed selling price');
//    notifyListeners();
//  }
//  // Adds a product to the cart.
//  void addProductToCart(int productId) {
//    if (!_productsInCart.containsKey(productId)) {
//      _productsInCart[productId] = 1;
//    } else {
//      _productsInCart[productId]++;
//    }
//
//    notifyListeners();
//  }
//
//  // Removes an item from the cart.
//  void removeItemFromCart(int productId) {
//    if (_productsInCart.containsKey(productId)) {
//      if (_productsInCart[productId] == 1) {
//        _productsInCart.remove(productId);
//      } else {
//        _productsInCart[productId]--;
//      }
//    }
//
//    notifyListeners();
//  }
//
//
//
//  // Returns the Product instance matching the provided id.
//  Map<String, dynamic> getProductById(int id) {
//    return _availableProducts.firstWhere((p) => p['id'] == id);
//  }
//
//  // Removes everything from the cart.
//  void clearCart() {
//    _productsInCart.clear();
//    notifyListeners();
//  }
//
//  // Loads the list of available products from the repo.
//  void loadProducts(List<Map<String, dynamic>> allProducts) {
//    _availableProducts = List<Map<String, dynamic>>.from(allProducts);
//
//    print('products loaded for the new model!!!!' + _availableProducts.length.toString());
//    print(_availableProducts);
//    notifyListeners();
//  }
//
//  void setCategory(int newCategory) {
//    _selectedCategory = newCategory;
//    notifyListeners();
//  }
//
//
//
//}