

import 'package:scoped_model/scoped_model.dart';
import '../Databases/Database.dart';
import '../model/Database_Models.dart';

import 'product.dart';
import 'products_repository.dart';

_print(var text, {String msg = 'custom print'}) {
  print('.............................................' + msg);
  print(text.toString());
}


class AppStateModel extends Model {
  double _gst = 0.0;
  bool _toggle = true;
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
  double get gst => _gst ;
    double get salesTax => _salesTaxRate;
  double get tax => subtotalCost * gst;
//  double get tax => subtotalCost * salesTax;

  // Total cost to order everything in the cart.
  double get totalCost => subtotalCost + shippingCost + tax;


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
