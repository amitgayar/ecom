
import 'package:mpos/model/Database_Models.dart';
import 'package:scoped_model/scoped_model.dart';
import '../Databases/Database.dart';
import '../model/Database_Models.dart';
import 'package:async/async.dart';

import 'dart:ffi';
//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'queryForUI.dart';
import 'package:scoped_model/scoped_model.dart';
import '../Databases/Database.dart';
import '../model/Database_Models.dart';
import '../services/addDataToTable.dart';



final dbHelper = DatabaseHelper.instance;

class NewAppStateModel extends Model {


  List<Map> _EditableproductsListForCart = [];
  int indexOfProductInCart;double discountProvided;

  double subTotalValue;
  double cartTotalValue;
  double cgstValue;
  double sgstValue;
  double cessValue;
  bool includeTaxesValue;

  List<Map> get editableListOfProductsInCart => _EditableproductsListForCart;

  double get subTotal => subTotalValue;
  double get cartTotal => cartTotalValue;
  double get cgst => cgstValue;
  double get sgst => sgstValue;
  double get cess => cessValue;
  double get Discount => discountProvided;
  bool get includeTaxes => includeTaxesValue;
  String get currentBarcode => barcode;
  String get currentBarcodedProductName => barcodeedProductName;
  bool get currentDisplayCustomProductPage => displayCustomProductPage;
  String barcode;
  String barcodeedProductName;
  String tempBarcode = "";
  bool displayCustomProductPage = false, tempIsCustomerSelectedInCart = false, tempAllowCartSubnissiom = false;
  bool get isCustomerSelectedInCart => tempIsCustomerSelectedInCart;
  bool get allowCartSubnissiom => tempAllowCartSubnissiom;




  // Adds a Editable product to the cart.
  void addEditableProductToCart(Map product) {
    print("enter into addEditableProductToCart\n\n received argumet: $product");
    //print("\n\nentered state of _EditableproductsListForCart: $_EditableproductsListForCart");

    Map _EditableproductsInCart = {};

    bool itemPresentInctNumber;

    product.forEach((key, value) {
      _EditableproductsInCart[key.toString()] = value.toString();
    });

    print("\n\n product id type = ${product['id'].runtimeType}");

    if (product['id'].runtimeType == int) {
      if (product.containsKey("to_be_saved")) {
        print("Custom Product");
        _EditableproductsInCart['custom_product_id'] = product['id'];
        _EditableproductsInCart['product_id'] = null;
        _EditableproductsInCart['id'] = "c_${product['id'].toString()}";
      }
      else {
        _EditableproductsInCart['product_id'] = product['id'];
        _EditableproductsInCart['custom_product_id'] = null;
        _EditableproductsInCart['id'] = "p_${product['id'].toString()}";
      }
    }


    _EditableproductsInCart['barcode'] = tempBarcode;
    print("\n\n ${_EditableproductsInCart['id']}");


    if (_EditableproductsListForCart.length == 0) {
      _EditableproductsInCart["quantity"] = 1;
      _EditableproductsListForCart.add(_EditableproductsInCart);
      print("\n\nProduct added to _EditableproductsListForCart");
    }
    else {
      var indexOfItemToAdd = _EditableproductsListForCart.indexWhere((p) => p['id'] == product['id']);

      if (indexOfItemToAdd != -1) {

        print("\n\nitemPresentInCart :::: productNumber : ${(_EditableproductsListForCart[indexOfItemToAdd]['quantity'])}");
        _EditableproductsListForCart[indexOfItemToAdd]['quantity'] = (_EditableproductsListForCart[indexOfItemToAdd]['quantity'] + 1);

      }

      else {
        print("\n\nProduct not in cart _EditableproductsListForCart");
        _EditableproductsInCart["quantity"] = 1;
        _EditableproductsListForCart.add(_EditableproductsInCart);
      }
    }



    notifyListeners();


    //_EditableproductsListForCart.add(_EditableproductsInCart);
    //print("\n\n_EditableproductsListForCart: ${_EditableproductsListForCart} \n\n\n");

  }//add Editable product to cart ended



  // Removes an item from the cart.
  void removeEditableItemFromCart(Map product, String actionToPerform) {


    var indexOfItemToRemove = _EditableproductsListForCart.indexWhere((p) => p['id'] == product['id']);

    print("enter into removeItemFromCart(cartModel, product)\n\n received argumet: $product\n\n indexOfItemToRemove = $indexOfItemToRemove\n\n");

    if (actionToPerform == "clear_cart") {
      print("Request received to clear Cart\n\n");
      _EditableproductsListForCart.clear();
      discountProvided = 0.0;
      subTotalValue = 0.0;
      cartTotalValue = 0.0;
      cgstValue = 0.0;
      sgstValue = 0.0;
      cessValue = 0.0;
      includeTaxesValue = false;
      barcode = "";
      barcodeedProductName = "";
      tempBarcode = "";


    }
    else if (actionToPerform == "remove_row") {
      print("Request received to remove_row\n\n");
      _EditableproductsListForCart.remove(_EditableproductsListForCart[indexOfItemToRemove]);
    }
    else if (actionToPerform == "reduce_quantity") {
      print("Request received to reduce_quantity\n\n");
      if (indexOfItemToRemove != -1) {
        if (_EditableproductsListForCart[indexOfItemToRemove]['quantity'] == 1) {
          print("Request quantity is 1\n\n");
          _EditableproductsListForCart.remove(_EditableproductsListForCart[indexOfItemToRemove]);
          print("\n\n $_EditableproductsListForCart");
        }
        else {
          print("Current Quantity = _EditableproductsListForCart[indexOfItemToRemove]['quantity']");
          _EditableproductsListForCart[indexOfItemToRemove]['quantity'] = _EditableproductsListForCart[indexOfItemToRemove]['quantity'] - 1;
          //print("\n\n $_EditableproductsListForCart");
          print("Updated Quantity = _EditableproductsListForCart[indexOfItemToRemove]['quantity']");
        }

      }
    }



//    if (_productsInCart.containsKey(productId)) {
//      if (_productsInCart[productId] == 1) {
//        _productsInCart.remove(productId);
//      } else {
//        _productsInCart[productId]--;
//      }
//    }
    notifyListeners();
  }



  void changeProductValue(String newValue, Map product, String callingInputField){

    print("enter into changeSP :::: received arguments :::: Changed Price = $newValue :::: for product = $product \n\n");
    //print(product['id']);
//      _EditableproductsListForCart.forEach((p) {
//        //if (p['id'] == product['id']) {
//          print(p['id'].runtimeType);
//        //}
//      }
//      );

    indexOfProductInCart = _EditableproductsListForCart.indexWhere((p) => p['id'] == product['id']);

    print("\n\ngetting list item for update ::: $indexOfProductInCart");

    //print("\n\n Value of SP at index before update  ::: ${_EditableproductsListForCart[indexOfProductInCart]['sp']}");

    if (callingInputField == 'mrp') {
      _EditableproductsListForCart[indexOfProductInCart]['mrp'] = double.parse(newValue);
    }
    else if (callingInputField == 'sp') {
      _EditableproductsListForCart[indexOfProductInCart]['sp'] = double.parse(newValue);
    }
    else if (callingInputField == 'quantity') {
      _EditableproductsListForCart[indexOfProductInCart]['quantity'] = int.parse(newValue);
    }


    //print("\n\n Value of SP at index after update  ::: ${_EditableproductsListForCart[indexOfProductInCart]['sp']}");
//    _availableProducts.firstWhere((p) => p['id'] == id)["sp"] = _availableProducts.firstWhere((p) => p['id'] == id)["sp"] + changedPrice;
//    print("abc = ${_availableProducts.firstWhere((p) => p['id'] == id)["sp"]}");
//    print(changedPrice);
//
    print(_EditableproductsListForCart[indexOfProductInCart]);

//
    //print('\n\nQuantity of Index ::: ${editableListOfProductsInCart[editableListOfProductsInCart.indexWhere((p) => int.parse(p['id']) == int.parse(product['id']))]['sp'].runtimeType}');
//    print('changed selling price');
    notifyListeners();
  }




  void calculateCartTotalValue (String discount) {

    print("Entered into calculateCartTotalValue");
    //print("CGST = $cgstValue :::: SGST = $sgstValue :::: CESS = $cessValue :::: Discount = $discountProvided \n\n");
    print(editableListOfProductsInCart);

    cartTotalValue = 0.0;
    cgstValue = 0.0;
    sgstValue = 0.0;
    cessValue = 0.0;
    double taxes = 0.0;

    print("\n\nDiscount = $discount\n\n");
    discountProvided = double.parse((discount == "null") ? "0.0" : discount.toString());



    subTotalValue = 0.0;
    _EditableproductsListForCart.forEach((item) {
      subTotalValue = subTotalValue + (double.parse(item['sp'].toString())*item['quantity']);
    });

    print("Subtotal= $subTotalValue");

    if (includeTaxesValue == true) {

      _EditableproductsListForCart.forEach((item) {


//        print(double.parse(item['cgst'].toString())*item['quantity']*double.parse(item['sp'].toString())/100);
//        print((double.parse(item['sgst'].toString())*item['quantity']*double.parse(item['sp'].toString())/100));
//        print((double.parse(item['cess'].toString())*item['quantity']*double.parse(item['sp'].toString())/100));
        cgstValue = cgstValue + (double.parse((item['cgst'] == null)? "0.0" : item['cgst'].toString())*item['quantity']*double.parse(item['sp'].toString())/100);
        sgstValue = sgstValue + (double.parse((item['sgst'] == null)? "0.0" : item['sgst'].toString())*item['quantity']*double.parse(item['sp'].toString())/100);
        cessValue = cessValue + (double.parse((item['cess'] == null)? "0.0" : item['cess'].toString())*item['quantity']*double.parse(item['sp'].toString())/100);
      });
      print("Current Taxes value = $taxes \n\n");
      taxes = cgstValue + sgstValue + cessValue;
      print("new Taxes value = $taxes \n\n Old subtotal value = $subTotalValue");
      //print("CGST = $cgstValue :::: SGST = $sgstValue :::: CESS = $cessValue :::: Discount = $discountProvided");
      subTotalValue = subTotalValue + taxes;

      print("new Taxes value = $taxes \n\n New subtotal value = $subTotalValue");
    }




    cartTotalValue = subTotalValue - discountProvided;

    print("CGST = $cgstValue :::: SGST = $sgstValue :::: CESS = $cessValue :::: Discount = $discountProvided :::: Total amount to be pad = $cartTotalValue");
    notifyListeners();

  }






  processBarcode(RawKeyEvent key) {
    //print("Event runtimeType is ${key.runtimeType}");
    if(key.runtimeType.toString() == 'RawKeyDownEvent'){
      if (key.data.logicalKey.keyLabel != null) {
        tempBarcode = tempBarcode + key.data.keyLabel;
        barcode = tempBarcode;
        print("\n\n${barcode}");


      }
      else {

        tempBarcode = "";
        print("\n\nvalue of barcode = $barcode :::: keylable =${key.data.keyLabel}");
        if (barcode != "" && key.data.keyLabel != null) {
          print("barcode detected");
          getProductFromBarcode(barcode);
        }
        else {
          barcode="";
        }

      }

    }


    notifyListeners();
  }

  void getProductFromBarcode (String barcode) async {
    print("enter into getProductFromBarcode\n\n");
    String queryRequest = "SELECT * FROM ${DatabaseHelper.barcode} WHERE ${DatabaseHelper.barcode} = '$barcode' LIMIT 1";
    List<Map<String, dynamic>> barcodedProductList = await dbHelper.raw_query(queryRequest);

    if (barcodedProductList.length > 0) {

      var id = barcodedProductList[0]['id'];

      String queryRequestFromProductTable = "SELECT * FROM ${DatabaseHelper.productsTable} WHERE ${DatabaseHelper.id} = '$id' LIMIT 1";
      List<Map<String, dynamic>> productListFromProductTable = await dbHelper.raw_query(queryRequestFromProductTable);

      String queryReuestFromCustomProductTable = "SELECT * FROM ${DatabaseHelper.customProductsTable} WHERE ${DatabaseHelper.id} = '$id' LIMIT 1";
      List<Map<String, dynamic>> productListFromCustomProductTable = await dbHelper.raw_query(queryReuestFromCustomProductTable);

      if (productListFromProductTable.length > 0) {
        print("\n\nStore product detected :::: Discount = $Discount");

        addEditableProductToCart(productListFromProductTable[0]);
        calculateCartTotalValue(Discount.toString());
        displayCustomProductPage = false;

      }
      else if(productListFromCustomProductTable.length > 0) {
        addEditableProductToCart(productListFromCustomProductTable[0]);
        calculateCartTotalValue(Discount.toString());
        displayCustomProductPage = false;
        print("custom product detected");
      }
      else {
        barcodeedProductName = barcodedProductList[0]['name'];
        displayCustomProductPage = true;
      }

    }
    else {
      barcodeedProductName = "";
      displayCustomProductPage = true;
    }

    notifyListeners();
    //print(barcode);
  }



  void paymentModeSelected (String paymentMode) {
    tempPaymentMethod = paymentMode;

    if (paymentMode == "credit") {
      if (tempIsCustomerSelectedInCart != true) {
        tempAllowCartSubnissiom = false;
      }
      else {
        tempAllowCartSubnissiom = true;
      }
    }
    else {
      tempAllowCartSubnissiom = true;
      tempTotalAmountPaid = cartTotalValue;
      tempCredit = 0.0;
    }

    notifyListeners();
  }

  String tempPaymentMethod;
  double tempTotalAmountPaid, tempCredit;
  String customerID = "";
  String get paymentMethod => tempPaymentMethod;
  double get AmountPaid => tempTotalAmountPaid;
  double get credit => tempCredit;

  void analyzeCredit (String totalAmountPaid) {
    tempTotalAmountPaid = double.parse(totalAmountPaid);
    tempCredit = cartTotalValue - tempTotalAmountPaid;
  }

  /*
  Create invoice Number - formula pending
  Check whether to print receipt - pending on thermal printer
  Create entry in Orders table - done
  Create Entry in order items table - done
  Create Entry in Credits items table - done
  Update inventory in products table - done
  Clear Cart
   */
  void generateInvoice (bool printReceipt) async{

    String invoiceNumber = "invoice_${DateTime.now().toString()}";
    bool is_receipt_printed = printReceipt;
    List<Map<String, dynamic>> storeProductsInCart;

    //Adding Order to table
    Map<String, dynamic> rowOrder = {
      DatabaseHelper.customer_id : customerID,
      DatabaseHelper.cart_discount_total : discountProvided,
      DatabaseHelper.cgst : cgstValue,
      DatabaseHelper.sgst : sgstValue,
      DatabaseHelper.cess : cessValue,
      DatabaseHelper.mrp_total : cartTotalValue,
      DatabaseHelper.is_receipt_printed : is_receipt_printed,
      DatabaseHelper.payment_method : tempPaymentMethod,
      DatabaseHelper.paid_amount_total : tempTotalAmountPaid,
      DatabaseHelper.status : "Completed",
      DatabaseHelper.invoice : invoiceNumber,
      DatabaseHelper.updated_at : new DateTime.now().toString()

    };

    var return_id = await dbHelper.insert(DatabaseHelper.ordersTable, rowOrder);
    print('${DatabaseHelper.ordersTable} inserted row id on order submission: $return_id');


    // Adding order items to table
    _EditableproductsListForCart.forEach((p) {
      p[DatabaseHelper.order_id] = invoiceNumber;
      p[DatabaseHelper.inventory] = p[DatabaseHelper.inventory] - p['quantity'];
      if (!p.containsKey(DatabaseHelper.to_be_saved)) {
        storeProductsInCart.add(p);
      }
    }
                                         );


    List<orderItems> ordersListParsedFromCartItems = _EditableproductsListForCart.map((i) => orderItems.fromJson(i)).toList();
    insert_Order_Products(ordersListParsedFromCartItems);

    //Adding Credit to table
    Map<String, dynamic> rowCredit = {
      DatabaseHelper.customer_id : customerID,
      DatabaseHelper.amount : tempCredit,
      DatabaseHelper.order_id : invoiceNumber,
      DatabaseHelper.updated_at : new DateTime.now().toString()
    };

    return_id = await dbHelper.insert(DatabaseHelper.customerCreditTable, rowCredit);
    print('${DatabaseHelper.customerCreditTable} inserted row id on order submission: $return_id');

    // Adding order items to table
    _EditableproductsListForCart.forEach((p) {
      p[DatabaseHelper.order_id] = invoiceNumber;
    }
                                         );

    // Updating Inventory
    _EditableproductsListForCart.forEach((p) {
      p[DatabaseHelper.inventory] = p[DatabaseHelper.inventory] - p['quantity'];
      if (!p.containsKey(DatabaseHelper.to_be_saved)) {
        p['id'] = p['product_id'];
        storeProductsInCart.add(p);
      }
    }
                                         );
    List<products> productsListParsedFromCart = storeProductsInCart.map((i) => products.fromJson(i)).toList();
    insert_products(productsListParsedFromCart);

    //Clearing Cart
    _EditableproductsListForCart.clear();
    discountProvided = 0.0;
    subTotalValue = 0.0;
    cartTotalValue = 0.0;
    cgstValue = 0.0;
    sgstValue = 0.0;
    cessValue = 0.0;
    includeTaxesValue = false;
    barcode = "";
    barcodeedProductName = "";
    tempBarcode = "";
    calculateCartTotalValue(Discount.toString());


  }


//  .............. ............................ ............................ ............................ ............................ ..............

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
  Map getProductById(String id) {
    //print("Returning product for actions = ${_EditableproductsListForCart.firstWhere((p) => p['id'] == id)} \n\n\n");
    return _EditableproductsListForCart.firstWhere((p) => p['id'] == id);
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




