
import 'package:mpos/model/Database_Models.dart';
import 'package:scoped_model/scoped_model.dart';
import '../Databases/Database.dart';
//import '../model/Database_Models.dart';
//import 'package:async/async.dart';


//final dbHelper = DatabaseHelper.instance;

class NewAppStateModel extends Model {



  double _gst = 0.0;
  bool _toggle = true;
  double get gst => _gst ;

  double _salesTaxRate = 0.02;
  double _shippingCostPerItem = 1.0;


      List<Map<String, dynamic>> _dbProducts ;
  List<Map<String, dynamic>> _dbCustomProducts ;
  List<Map<String, dynamic>> _dbCategories ;
  List<Map<String, dynamic>> get dbProducts => List<Map>.from(_dbProducts);
  List<Map<String, dynamic>> get dbCustomProducts => List<Map>.from(_dbCustomProducts);
  List<Map<String, dynamic>> get dbCategories => List<Map>.from(_dbCategories);
  List<Map<String, dynamic>> _availableProducts = [];
  List<Map<String, dynamic>> get availableProducts => List<Map>.from(_availableProducts);

  // The currently selected category of products.
  String _selectedCategory = '';
 List<int> _subCategory = [];
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
    _availableProducts.clear();
    print('CART CLEARED');
    notifyListeners();
  }
//
//  // Loads the list of available products from the repo.
//  void loadProducts(List<Map<String, dynamic>> allProducts) {
//    _availableProducts = List<Map<String, dynamic>>.from(allProducts);
//
//    print('products loaded for the new model..... ' + _availableProducts.length.toString());
////    print(_availableProducts);
//    notifyListeners();
//  }

  void addItemToCart(Map<String, dynamic> product) {
    if (product.containsKey('to_be_saved')){
      print('custom product added true');
      final Map<String, dynamic> item = Map.from(product);
      item['customID'] = product['id'];
      print(item['customID']);
      _availableProducts.add(item);
      print('product added to cart with details and total item ..... ' + _availableProducts.length.toString());
    }
    else{

      final Map<String, dynamic> item = Map.from(product);
      item['productID'] = product['id'];
      print(item['productID']);
      _availableProducts.add(item);
      print('product added to cart with details and total item ..... ' + _availableProducts.length.toString());
    }

  }


  bool get toggle => _toggle;
  void setToggle() {
    _toggle = !_toggle;
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

  void setData(List<Map<String, dynamic>> products, List<Map<String, dynamic>> categories, List<Map<String, dynamic>> customProducts){
    _dbProducts = products;

//    products != null? _availableProducts = _availableProducts + products : [] ;
    _dbCategories = categories;
    _dbCustomProducts = customProducts;
    notifyListeners();
  }

  List<Map<String, dynamic>> getProducts(){
    return _dbProducts;
  }

  List<Map<String, dynamic>> getCategories(){
    return _dbCategories;
  }

  List<Map<String, dynamic>> getCustomProducts(){
    return _dbCustomProducts;
  }


  List<Map<String, dynamic>> _stack = [null];
  List<Map<String, dynamic>> get stack => _stack;
//  Map<String, Map<String, dynamic>> _stackMap = {'Stack2': {}, 'Stack3': {}};
//  Map<String, Map<String, dynamic>> get stackMap => _stackMap;

  void setStack( Map<String, dynamic> category){
    if (category == null ){
    _stack.removeLast();
    }
    else{
      _stack.add(category);
    }
   print('Current Category Level is :  '+_stack.length.toString());
    notifyListeners();

  }

  void emptyStack(){
    _stack = [null];
    _selectedCategory = '';
    notifyListeners();
  }


  void setCategory(String newCategory) {
    _selectedCategory = newCategory;
    print('category changed');
    notifyListeners();
  }

  bool _bottom = false;
  bool get bottom => _bottom;
  void cartState(){
    _bottom = !_bottom;
    notifyListeners();
  }

}




