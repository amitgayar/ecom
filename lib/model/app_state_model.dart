

import 'dart:ffi';

import 'package:scoped_model/scoped_model.dart';
import '../Databases/Database.dart';
import '../model/Database_Models.dart';
import 'package:async/async.dart';
import 'product.dart';
import 'products_repository.dart';

_print(var text, {String msg = 'custom print'}) {
  print('.............................................' + msg);
  print(text.toString());
}



final dbHelper = DatabaseHelper.instance;


//Future <List<Map<String, dynamic>>>



class AppStateModel extends Model {
  List<Map<String, dynamic>> _dbProducts ;

  double _gst = 0.0;
  bool _toggle = true;
  double get gst => _gst ;

  List<Map<String, dynamic>>  get dbProducts => _dbProducts ;





  double _salesTaxRate = 0.02;
  double _shippingCostPerItem = 1.0;
  // All the available products.
  List<Product> _availableProducts;

  // The currently selected category of products.
  Category _selectedCategory = Category.all;

  // The IDs and quantities of products currently in the cart.
  Map<int, int> _productsInCart = {};

  Map<int, int> get productsInCart => Map.from(_productsInCart);

  // Total number of items in the cart.
  int get totalCartQuantity => _productsInCart.values.fold(0, (v, e) => v + e);

  Category get selectedCategory => _selectedCategory;


  // Totaled prices of the items in the cart.
  double get subtotalCost => _productsInCart.keys
      .map((id) => _availableProducts[id].price * _productsInCart[id])
      .fold(0.0, (sum, e) => sum + e);

  // Total shipping cost for the items in the cart.
  double get shippingCost =>
      _shippingCostPerItem *
      _productsInCart.values.fold(0.0, (sum, e) => sum + e);

  // Sales tax for the items in the cart

    double get salesTax => _salesTaxRate;
  double get tax => subtotalCost * gst;
//  double get tax => subtotalCost * salesTax;

  // Total cost to order everything in the cart.
  int get totalCost {
    double data = subtotalCost + shippingCost + tax;
    return data.round();
  }


  // Returns a copy of the list of available products, filtered by category.
  List<Product> getProducts() {
    if (_availableProducts == null) return List<Product>();

    if (_selectedCategory == Category.all) {
      return List.from(_availableProducts);
    } else {
      return _availableProducts
          .where((p) => p.category == _selectedCategory)
          .toList();
    }
  }

  // Adds a product to the cart.
  void addProductToCart(int productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId]++;
    }

    notifyListeners();
  }

  // Removes an item from the cart.
  void removeItemFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId]--;
      }
    }

    notifyListeners();
  }

  // Returns the Product instance matching the provided id.
  Product getProductById(int id) {
    return _availableProducts.firstWhere((p) => p.id == id);
  }

  // Removes everything from the cart.
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }

  // Loads the list of available products from the repo.
  void loadProducts() {
    _availableProducts = ProductsRepository.loadProducts(Category.all);
    notifyListeners();
  }

  void setCategory(Category newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }

  bool get toggle => _toggle;
   void setToggle() {
    _toggle = !_toggle;
    _print(_toggle, msg:'toggle changed!');
    notifyListeners();
   }

   void setGST(bool value){
    if (value) {
      _gst = 0.05;
      notifyListeners();
      print('gst 1');

    }
    else{
      _gst = 0.00;
      notifyListeners();
      print('gst 0');
    }
  }

  Future<List<Map<String, dynamic>>> queryForUI(String table, String colName,  String operator, String id) async {


    if (id == '' && colName == '' && operator == '' ){
      final _dbProducts = await dbHelper.queryAllRows(table);
      print('Total rows in table - ' + table + '...:...' + _dbProducts.length.toString());
      print('First entry is : ' + _dbProducts.first.toString());
//      print('before notify');
      notifyListeners();
//    print('after notify');
      return _dbProducts;
//    return allList;

    }

    else {
      final queryList = await dbHelper.queryRow(table,  id,  colName,  operator);
      print(table +colName + operator + id + '..count..:' +queryList.length.toString());
      print('First one is : ' + queryList.first.toString());
      notifyListeners();
      return _dbProducts;
//    return queryList;

    }


  }

//  Future parseProductsFromResponse(int categoryId, int pageIndex) async {
//    _isLoading = true;
//
//    notifyListeners();
//
//    currentProductCount = 0;
//
//    var dataFromResponse = await _getProductsByCategory(categoryId, pageIndex);
//
//    dataFromResponse.forEach(
//      //logic for parsing the fetched remote data
//      );
//
//    _isLoading = false;
//
//    notifyListeners();
//  }

}

class NewAppStateModel extends Model {
  List<Map<String, dynamic>> _dbProducts ;

  double _gst = 0.0;
  bool _toggle = true;
  double get gst => _gst ;

  List<Map<String, dynamic>>  get dbProducts => _dbProducts ;





  double _salesTaxRate = 0.02;
  double _shippingCostPerItem = 1.0;
  // All the available products.
  List<Map<String, dynamic>> _availableProducts;
  List<Map<String, dynamic>> get availableProducts => _availableProducts;

  // The currently selected category of products.
  int _selectedCategory = 1;

  // The IDs and quantities of products currently in the cart.
  Map<int, int> _productsInCart = {};

  Map<int, int> get productsInCart => Map.from(_productsInCart);

  // Total number of items in the cart.
  int get totalCartQuantity => _productsInCart.values.fold(0, (v, e) => v + e);

  int get selectedCategory => _selectedCategory;


  // Totaled prices of the items in the cart.
  double get subtotalCost => _productsInCart.keys
      .map((id) => availableProducts[id]['sp'] * _productsInCart[id])
      .fold(0.0, (sum, e) => sum + e);

  // Total shipping cost for the items in the cart.
  double get shippingCost =>
      _shippingCostPerItem *
          _productsInCart.values.fold(0.0, (sum, e) => sum + e);

  // Sales tax for the items in the cart

  double get salesTax => _salesTaxRate;
  double get tax => subtotalCost * gst;
//  double get tax => subtotalCost * salesTax;

  // Total cost to order everything in the cart.
  double get totalCost => subtotalCost + shippingCost + tax ;
//    (subtotalCost + shippingCost + tax).toStringAsFixed(2);


  // Returns a copy of the list of available products, filtered by category.
  List<Map<String, dynamic>> getProducts() {
    if (_availableProducts == null) return List<Map<String, dynamic>>();

    if (_selectedCategory == 1) {
      return List.from(_availableProducts);
    } else {
      return _availableProducts
          .where((p) => p['category_id'] == _selectedCategory)
          .toList();
    }
  }


  void changeSP(double changedPrice, int id){
    _availableProducts[id]['sp'] = changedPrice;
    print('changed selling price');
    notifyListeners();
  }
  // Adds a product to the cart.
  void addProductToCart(int productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId]++;
    }

    notifyListeners();
  }

  // Removes an item from the cart.
  void removeItemFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId]--;
      }
    }

    notifyListeners();
  }

  void addItemToCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      _productsInCart[productId]++;
    }
    notifyListeners();
  }

  // Returns the Product instance matching the provided id.
  Map<String, dynamic> getProductById(int id) {
    return _availableProducts.firstWhere((p) => p['id'] == id);
  }

  // Removes everything from the cart.
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }

  // Loads the list of available products from the repo.
  void loadProducts(List<Map<String, dynamic>> allProducts) {
    _availableProducts = allProducts;

    print('products loaded for the new model!!!!' + _availableProducts.length.toString());
    print(_availableProducts);
    notifyListeners();
  }

  void setCategory(int newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }

  bool get toggle => _toggle;
  void setToggle() {
    _toggle = !_toggle;
    _print(_toggle, msg:'toggle changed!');
    notifyListeners();
  }

  void setGST(bool value){
    if (value) {
      _gst = 0.05;
      notifyListeners();
      print('gst 1');

    }
    else{
      _gst = 0.00;
      notifyListeners();
      print('gst 0');
    }
  }

  Future<List<Map<String, dynamic>>> queryForUI(String table, String colName,  String operator, String id) async {


    if (id == '' && colName == '' && operator == '' ){
      final _dbProducts = await dbHelper.queryAllRows(table);
      print('Total rows in table - ' + table + '...:...' + _dbProducts.length.toString());
      print('First entry is : ' + _dbProducts.first.toString());
//      print('before notify');
      notifyListeners();
//    print('after notify');
      return _dbProducts;
//    return allList;

    }

    else {
      final queryList = await dbHelper.queryRow(table,  id,  colName,  operator);
      print(table +colName + operator + id + '..count..:' +queryList.length.toString());
      print('First one is : ' + queryList.first.toString());
      notifyListeners();
      return _dbProducts;
//    return queryList;

    }


  }


}