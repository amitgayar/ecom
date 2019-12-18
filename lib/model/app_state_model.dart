

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







class NewAppStateModel extends Model {
  List<Map<String, dynamic>> _dbProducts ;

  double _gst = 0.0;
  bool _toggle = true;
  double get gst => _gst ;

  List<Map<String, dynamic>>  get dbProducts => _dbProducts ;





  double _salesTaxRate = 0.02;
  double _shippingCostPerItem = 1.0;
  // All the available products.
  List<Map<String, dynamic>> _availableProducts = [];
  List<Map<String, dynamic>> get availableProducts => List<Map>.from(_availableProducts);

  // The currently selected category of products.
  String _selectedCategory = 'All';

  // The IDs and quantities of products currently in the cart.
  Map<int, int> _productsInCart = {};

  Map<int, int> get productsInCart => Map.from(_productsInCart);

  // Total number of items in the cart.
  int get totalCartQuantity => _productsInCart.values.fold(0, (v, e) => v + e);

  String get selectedCategory => _selectedCategory;


  // Totaled prices of the items in the cart.
  double get subtotalCost => _productsInCart.keys
      .map((id) => _availableProducts.firstWhere((p) => p['id'] == id)['sp'] * _productsInCart[id])
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

    if (_selectedCategory == "All") {
      return List.from(_availableProducts);
    } else {
      return _availableProducts
          .where((p) => p['category_id'] == _selectedCategory)
          .toList();
    }
  }


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
    _availableProducts = List<Map<String, dynamic>>.from(allProducts);



    print('products loaded for the new model..... ' + _availableProducts.length.toString());
//    print(_availableProducts);
    notifyListeners();
  }

  void setCategory(String newCategory) {
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



}




