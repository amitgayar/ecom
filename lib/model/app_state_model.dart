

import 'dart:ffi';
//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'queryForUI.dart';
import 'package:scoped_model/scoped_model.dart';
import '../Databases/Database.dart';
import '../model/Database_Models.dart';
import 'package:async/async.dart';
import '../services/addDataToTable.dart';


final dbHelper = DatabaseHelper.instance;
class NewAppStateModel extends Model {


//  ......................................GAYAR SECTION ..............................................

//  ............................................. GAYAR SECTION ENDS .......................................


  List<Map> _EditableproductsListForCart = [];
  int indexOfProductInCart;double discountProvided;

  double subTotalValue;
  double cartTotalValue;
  double cgstValue;
  double sgstValue;
  double cessValue;
  bool includeTaxesValue = false;

  List<Map> get editableListOfProductsInCart => _EditableproductsListForCart;

  double get subTotal => subTotalValue;
  double get cartTotal => cartTotalValue;
  double get cgst => cgstValue;
  double get sgst => sgstValue;
  double get cess => cessValue;
  double get Discount => discountProvided;
  bool get includeTaxes => includeTaxesValue;
  String get currentBarcode => barcode;
  String get currentBarcodedProductName => barcodedProductName;
  bool get currentDisplayCustomProductPage => displayCustomProductPage;
  String barcode;
  String barcodedProductName;
  String tempBarcode = "";
  String get finalBarcode => barcode;
  bool displayCustomProductPage = false, tempIsCustomerSelectedInCart = false, tempAllowCartSubnissiom = false;
  bool get isCustomerSelectedInCart => tempIsCustomerSelectedInCart;
  bool get allowCartSubmissiom => tempAllowCartSubnissiom;
  int get totalCartQuantity => tempCartQuantity;
  String tempPaymentMethod;
  double tempTotalAmountPaid, tempCredit;
  String get customerID => tempselectedCustomer['id'].toString();
  String get paymentMethod => tempPaymentMethod;
  double get AmountPaid => tempTotalAmountPaid;
  double get credit => tempCredit;
  List<Map> get customersInDatabaseToDisplay => tempCustomersInDatabaseToDisplay;
  List<Map> tempCustomersInDatabaseToDisplay = [];
  Map tempselectedCustomer = {};
  Map get selectedCustomer => tempselectedCustomer;
  String get prefillField => tempPrefillField;
  String tempPrefillField;




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

    String productID;
    if (product['id'].runtimeType == int) {
      if (product.containsKey("to_be_saved")) {
        print("Custom Product");
        _EditableproductsInCart['custom_product_id'] = product['id'];
        _EditableproductsInCart['product_id'] = null;
        _EditableproductsInCart['id'] = "c_${product['id'].toString()}";
        productID = "c_${product['id'].toString()}";
      }
      else {
        _EditableproductsInCart['product_id'] = product['id'];
        _EditableproductsInCart['custom_product_id'] = null;
        _EditableproductsInCart['id'] = "p_${product['id'].toString()}";
        productID = "p_${product['id'].toString()}";
      }
    }
    else {
      productID = product['id'].toString();
    }


    _EditableproductsInCart['barcode'] = tempBarcode;
    print("\n\n ${_EditableproductsInCart['id']}");


    if (_EditableproductsListForCart.length == 0) {
      _EditableproductsInCart["quantity"] = 1;
      _EditableproductsListForCart.add(_EditableproductsInCart);
      print("\n\nProduct added to _EditableproductsListForCart");
    }
    else {
      var indexOfItemToAdd = _EditableproductsListForCart.indexWhere((p) => p['id'] == productID);

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
      barcodedProductName = "";
      tempBarcode = "";
      tempPaymentMethod = '';


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



  int tempCartQuantity;
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

      tempCartQuantity = 0;
      _EditableproductsListForCart.forEach((item) {


//        print(double.parse(item['cgst'].toString())*item['quantity']*double.parse(item['sp'].toString())/100);
//        print((double.parse(item['sgst'].toString())*item['quantity']*double.parse(item['sp'].toString())/100));
//        print((double.parse(item['cess'].toString())*item['quantity']*double.parse(item['sp'].toString())/100));
        cgstValue = cgstValue + (double.parse((item['cgst'] == null)? "0.0" : item['cgst'].toString())*item['quantity']*double.parse(item['sp'].toString())/100);
        sgstValue = sgstValue + (double.parse((item['sgst'] == null)? "0.0" : item['sgst'].toString())*item['quantity']*double.parse(item['sp'].toString())/100);
        cessValue = cessValue + (double.parse((item['cess'] == null)? "0.0" : item['cess'].toString())*item['quantity']*double.parse(item['sp'].toString())/100);
        print("no error in cess :::: Item Quantity = ${item['quantity']}\n\n");
        tempCartQuantity = ((tempCartQuantity == null) ? 0 : tempCartQuantity) + item['quantity'];
        print("no error in tempCartQuantity\n\n");

      });
      print("Current Taxes value = $taxes :::: tempCartQuantity = $tempCartQuantity :::: totalCartQuantity = $totalCartQuantity\n\n");
      taxes = cgstValue + sgstValue + cessValue;
      print("new Taxes value = $taxes \n\n Old subtotal value = $subTotalValue");
      //print("CGST = $cgstValue :::: SGST = $sgstValue :::: CESS = $cessValue :::: Discount = $discountProvided");
      subTotalValue = subTotalValue + taxes;

      print("new Taxes value = $taxes \n\n New subtotal value = $subTotalValue");
    }
    else {
      tempCartQuantity = 0;
      _EditableproductsListForCart.forEach((item) {

        tempCartQuantity = ((tempCartQuantity == null) ? 0 : tempCartQuantity) + item['quantity'];

      });
      print("Current Taxes value = $taxes :::: tempCartQuantity = $tempCartQuantity :::: totalCartQuantity = $totalCartQuantity\n\n");
      print("new Taxes value = $taxes :::: New subtotal value = $subTotalValue\n\n");
    }




    cartTotalValue = subTotalValue - discountProvided;

    print("CGST = $cgstValue :::: SGST = $sgstValue :::: CESS = $cessValue :::: Discount = $discountProvided :::: Total amount to be pad = $cartTotalValue");
    notifyListeners();

  }



  void setGST(bool value){
    if (value) {
      includeTaxesValue = true;
      print('gst 1');

    }
    else{
      includeTaxesValue = false;
      print('gst 0');
    }

    notifyListeners();
  }




  processBarcode(RawKeyEvent key) {
    print(key);
    print("Event runtimeType is ${key}");
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
          print("barcode detected: $barcode\n\n");
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

    String queryReuestFromCustomProductTable = "SELECT * FROM ${DatabaseHelper.customProductsTable} WHERE ${DatabaseHelper.barcode} = '$barcode' LIMIT 1";
    List<Map<String, dynamic>> productListFromCustomProductTable = await dbHelper.raw_query(queryReuestFromCustomProductTable);

    if (barcodedProductList.length > 0) {

      var id = barcodedProductList[0]['id'];

      String queryRequestFromProductTable = "SELECT * FROM ${DatabaseHelper.productsTable} WHERE ${DatabaseHelper.id} = '$id' LIMIT 1";
      List<Map<String, dynamic>> productListFromProductTable = await dbHelper.raw_query(queryRequestFromProductTable);


      if (productListFromProductTable.length > 0) {
        print("\n\nStore product detected :::: Discount = $Discount");

        addEditableProductToCart(productListFromProductTable[0]);
        calculateCartTotalValue(Discount.toString());
        displayCustomProductPage = false;

      }
      else {
        barcodedProductName = barcodedProductList[0]['name'];
        displayCustomProductPage = true;
        print("Barcoded product detected but need to add new custom product = $barcode\n\n");
      }

    }
    else if(productListFromCustomProductTable.length > 0) {
      addEditableProductToCart(productListFromCustomProductTable[0]);
      calculateCartTotalValue(Discount.toString());
      displayCustomProductPage = false;
      print("custom product detected");
    }
    else {
      barcodedProductName = "";
      displayCustomProductPage = true;
      print("Barcoded product not detected and need to add new custom product = $barcode\n\n");
    }

    notifyListeners();
    //print(barcode);
  }


  void analyzeCredit (double totalAmountPaid, String paymentMode) {
    if (paymentMode == "credit") {
      tempTotalAmountPaid = totalAmountPaid;
      tempCredit = cartTotalValue - tempTotalAmountPaid;
    }
    else {
      tempTotalAmountPaid = totalAmountPaid;
      tempCredit = 0;
    }
    tempPaymentMethod = paymentMode;
    notifyListeners();
  }

  /*
  Create invoice Number - formula pending
  Check whether to print receipt - pending on thermal printer
  Create entry in Orders table - done
  Create Entry in order items table - done
  Create Entry in Credits items table - done
  Update inventory in products table - done
  Update Customer Table - Pending
  Clear Cart
   */
  void generateInvoice (bool printReceipt) async{



    String invoiceNumber = "invoice_${DateTime.now().toString()}";
    bool is_receipt_printed = printReceipt;
    List<Map<String, dynamic>> storeProductsInCart = [];

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
    }
                                         );

    List<Map<String, dynamic>> enterProductsToCart = [];

    _EditableproductsListForCart.forEach((item) {
      Map<String, dynamic> productItem = {};
      item.forEach((key, value){
        print("$key::::$value");
        productItem[key.toString()] = value;
      });
      if (item.containsKey("to_be_saved")) {
        productItem["id"] = item["custom_product_id"];
      }
      else {
        productItem["id"] = item["product_id"];
      }
      enterProductsToCart.add(productItem);
      print(enterProductsToCart);
    });


    List<orderItems> ordersListParsedFromCartItems = enterProductsToCart.map((i) => orderItems.fromJson(i)).toList();
    insert_Order_Products(ordersListParsedFromCartItems);

    //Adding Credit to table
    if (paymentMethod == "credit") {
      Map<String, dynamic> rowCredit = {
        DatabaseHelper.customer_id : customerID,
        DatabaseHelper.amount : tempCredit,
        DatabaseHelper.order_id : invoiceNumber,
        DatabaseHelper.updated_at : new DateTime.now().toString()
      };

      return_id = await dbHelper.insert(DatabaseHelper.customerCreditTable, rowCredit);
      print('${DatabaseHelper.customerCreditTable} inserted row id on order submission: $return_id');
    }

    // Update customer Data

    if (tempselectedCustomer.length>0) {


      var totalOrders = (selectedCustomer['total_orders'] == "") ? 1 : (int.parse(selectedCustomer['total_orders'].toString()) + 1);
      var totalSpent = (selectedCustomer['total_spent'] == "") ? cartTotalValue : (int.parse(selectedCustomer['total_spent'].toString()) + cartTotalValue);
      var totalDiscountOfCustomer = (selectedCustomer['total_discount'] == "") ? Discount : (int.parse(selectedCustomer['total_discount'].toString()) + Discount);
      var credit_balance = (selectedCustomer['credit_balance'] == "") ? credit : (int.parse(selectedCustomer['credit_balance'].toString()) + credit);
      print("selectedCustomer['total_orders'] = ${selectedCustomer['total_orders']}");
      Map<String, dynamic> row = {
        DatabaseHelper.name : selectedCustomer['name'],
        DatabaseHelper.phone_number : selectedCustomer['phone_number'],
        DatabaseHelper.gender : selectedCustomer['gender'],
        DatabaseHelper.total_orders : totalOrders,
        DatabaseHelper.total_spent : totalSpent,
        DatabaseHelper.average_spent : totalSpent/totalOrders,
        DatabaseHelper.total_discount : totalDiscountOfCustomer,
        DatabaseHelper.avg_discount_per_order : totalDiscountOfCustomer/totalOrders,
        DatabaseHelper.credit_balance : credit_balance,
        DatabaseHelper.updated_at : new DateTime.now().toString()

      };

//    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(DatabaseHelper.customerTable, id, DatabaseHelper.id,"=");
      insertRow(customerID, row, DatabaseHelper.customerTable,"=");

    }



    // Adding order items to table
    _EditableproductsListForCart.forEach((p) {
      p[DatabaseHelper.order_id] = invoiceNumber;
    }
                                         );

    // Updating Inventory
    enterProductsToCart.forEach((p) {
      if (!p.containsKey(DatabaseHelper.to_be_saved)) {
        p['id'] = p['product_id'].toString();
        p[DatabaseHelper.inventory] = (int.parse(p[DatabaseHelper.inventory]) - p['quantity']).toString();
        storeProductsInCart.add(p);
      }
    }
                                );

    List<Map<String, dynamic>> allCategories = await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.productCategoriesTable} WHERE ${DatabaseHelper.parent_id} = 'null'");
    print(allCategories);

    if (storeProductsInCart.runtimeType != null) {
      print("storeProductsInCart = ${storeProductsInCart}");
      List<products> productsListParsedFromCart = storeProductsInCart.map((i) => products.fromJson(i)).toList();
      insert_products(productsListParsedFromCart);
    }

//    List<Map<String, dynamic>> allOrders = await dbHelper.queryAllRows(DatabaseHelper.ordersTable);
//    List<Map<String, dynamic>> allItems = await dbHelper.queryAllRows(DatabaseHelper.orderProductsTable);
//    List<Map<String, dynamic>> allCreditItems = await dbHelper.queryAllRows(DatabaseHelper.customerCreditTable);
//    List<Map<String, dynamic>> updatedProduct = await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.productsTable} WHERE ${DatabaseHelper.id} = '${storeProductsInCart[0]['id']}'");
//
//    print("verify entry into order table: $allOrders\n\n\n");
//    print("verify entry into allItems table: $allItems\n\n\n");
//    print("verify entry into allCreditItems table: $allCreditItems\n\n\n");
//    print("verify entry into updatedProduct table: $updatedProduct\n\n\n");


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
    barcodedProductName = "";
    tempBarcode = "";
    calculateCartTotalValue(Discount.toString());
    tempPaymentMethod = "";


    notifyListeners();
  }

//  void queryAllCustomers () async {
//    String queryRequestForAllCustomers = "SELECT * FROM ${DatabaseHelper.customerTable} ORDER BY ${DatabaseHelper.name}";
//    List<Map<String, dynamic>> barcodedProductList = await dbHelper.raw_query(queryRequestForAllCustomers);
//}

  // Returns the Product instance matching the provided id.
  Map getProductById(String id) {
    //print("Returning product for actions = ${_EditableproductsListForCart.firstWhere((p) => p['id'] == id)} \n\n\n");
    return _EditableproductsListForCart.firstWhere((p) => p['id'] == id);
  }



  // Code for QuickLinks Starts

  List<Map<String, dynamic>> _dbProducts ;
  List<Map<String, dynamic>> _dbCustomProducts ;
  List<Map<String, dynamic>> _dbCategories ;
  List<Map<String, dynamic>> get dbProducts => List<Map>.from(_dbProducts);
  List<Map<String, dynamic>> get dbCustomProducts => List<Map>.from(_dbCustomProducts);
  List<Map<String, dynamic>> get dbCategories => List<Map>.from(_dbCategories);

  // The currently selected category of products.
  String _selectedCategory = '';
  String get selectedCategory => _selectedCategory;


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

  //Code for QuickLinks Ends




  // Code for adding customer Started

  void selectCustomer (Map customer){
    tempselectedCustomer = customer;
    notifyListeners();
  }

  void addNewCustomer (String phoneNumber, String name) async {

    Map<String, dynamic> row = {
      DatabaseHelper.name : name,
      DatabaseHelper.phone_number : phoneNumber,
      DatabaseHelper.gender : "",
      DatabaseHelper.total_orders : "",
      DatabaseHelper.total_spent : "",
      DatabaseHelper.average_spent : "",
      DatabaseHelper.total_discount : "",
      DatabaseHelper.avg_discount_per_order : "",
      DatabaseHelper.credit_balance : "",
      DatabaseHelper.updated_at : new DateTime.now().toString()

    };

    final return_id = await dbHelper.insert(DatabaseHelper.customerTable, row);

    String searchQueryById = "SELECT * FROM ${DatabaseHelper.customerTable} WHERE ${DatabaseHelper.id} = '$return_id'";
    List<Map<String, dynamic>> customerByID = await dbHelper.raw_query(searchQueryById);

    customerByID[0].forEach((key, value) {
      tempselectedCustomer[key.toString()] = value;
    });

    print("\n\nSelected Customer in addNewCustomerTable : $tempselectedCustomer\n\n");
    notifyListeners();
  }

  queryCustomerInDatabase (String searchString) async {
    tempCustomersInDatabaseToDisplay = [];
    List<Map<String, dynamic>> customerList = [];
    print("Entered into queryCustomerInDatabase");
    if (searchString.length < 3) {
      customerList = await dbHelper.queryAllRows(DatabaseHelper.customerTable);
      tempPrefillField = "";
    }
    else if (searchString.length >= 3) {
      String searchQueryPhoneNumber = "SELECT * FROM ${DatabaseHelper.customerTable} WHERE ${DatabaseHelper.phone_number} LIKE '%$searchString% COLLATE utf8_general_ci ORDER BY ${DatabaseHelper.name}";
      String searchQueryName = "SELECT * FROM ${DatabaseHelper.customerTable} WHERE ${DatabaseHelper.name} LIKE '%$searchString%' COLLATE utf8_general_ci ORDER BY ${DatabaseHelper.name}";
      List<Map> customerListPhoneNumber = await dbHelper.raw_query(searchQueryPhoneNumber);
      List<Map> customerListName = await dbHelper.raw_query(searchQueryName);
      print("customerListPhoneNumber = $customerListPhoneNumber :::: customerListName = $customerListName\n\n");

      if(customerListPhoneNumber.length > 0) {
        tempPrefillField = "phone";
      }
      else if (customerListName.length > 0) {
        tempPrefillField = "name";
      }
      else {
        tempPrefillField = "phone";
      }

      customerList = customerListPhoneNumber;
      customerListName.forEach((item) {
        print("item id = ${item['id']}\n\n");
        if (customerList.length<=0) {
          customerList = customerListName;
        }
        else {
          customerList.forEach((item2) {

            if (item2['id'] != item['id']) {
              customerList.add(item);
            }
          });
        }
      });

    }
    print("customerList = $customerList\n\n");

    if (customerList.length > 0) {
      customerList.forEach((item) {
        Map tempCustomer = {};
        item.forEach((key, value) {
          tempCustomer[key.toString()] = value.toString();
        });
        tempCustomersInDatabaseToDisplay.add(tempCustomer);
      });
    }

    print("tempCustomersInDatabaseToDisplay = $tempCustomersInDatabaseToDisplay :::: tempPrefillField = $tempPrefillField :::: searchString = $searchString\n\n");
    notifyListeners();
  }

  // Code for adding customer Ended




// Code for adding custom Item Started

  //String fina = finalBarcode;

  void updateFlagOfAddCustomItem (bool status) {
    displayCustomProductPage = true;
  }

  void addCustomItem (String name, String mrp, String sp, String cgst, String sgst, String cess) async {

    print("\n\nEntered into Add Custom Item");

    Map<String, dynamic> row = {
      DatabaseHelper.name : name,
      DatabaseHelper.mrp : mrp,
      DatabaseHelper.sp : sp,
      DatabaseHelper.cgst : cgst,
      DatabaseHelper.sgst : sgst,
      DatabaseHelper.cess : cess,
      DatabaseHelper.to_be_saved : true,
      DatabaseHelper.barcode : finalBarcode,
      DatabaseHelper.category_id : "",
      DatabaseHelper.uom : "",
      DatabaseHelper.updated_at : new DateTime.now().toString()

    };

    print("\n\n Row to be inserted = $row");
//    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(DatabaseHelper.customProductsTable, id, DatabaseHelper.id,"=");
    final return_id = await dbHelper.insert(DatabaseHelper.customProductsTable, row);
    print('\n\n${DatabaseHelper.customProductsTable} inserted row id: $return_id');

    List<Map> addedCustomItemFromDatabse = await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.customProductsTable} WHERE ${DatabaseHelper.id} = '$return_id' LIMIT 1");

    print('\n\ninserted row : $addedCustomItemFromDatabse');

    barcode = "";
    barcodedProductName = "";
    displayCustomProductPage = false;
    notifyListeners();

    addEditableProductToCart(addedCustomItemFromDatabse[0]);



  }

// Code for adding custom Item Started

}



