

import 'dart:ffi';
//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'queryForUI.dart';
import 'package:scoped_model/scoped_model.dart';
import '../Databases/Database.dart';
import '../model/Database_Models.dart';
import 'package:async/async.dart';
import '../services/addDataToTable.dart';
import 'package:shared_preferences/shared_preferences.dart';


final dbHelper = DatabaseHelper.instance;
class NewAppStateModel extends Model {

  //.................................................inputs by gayar ...............................................................................................................
  bool _selectCustomerForCartFlag = false;
  bool get selectCustomerForCartFlag => _selectCustomerForCartFlag;
  void setSelectCustomerForCartFlag(bool value){
    _selectCustomerForCartFlag = value;
    notifyListeners();
  }

  bool _addCustomerForCartFlag = true;
  bool get addCustomerForCartFlag => _addCustomerForCartFlag;
  void setAddCustomerForCartFlag(bool value){
    _addCustomerForCartFlag = value;
    notifyListeners();
  }


  bool _bottomBarHide = false;
  bool get bottomBarHide => _bottomBarHide;
  bool _creditModeFlag = false;
  bool get creditModeFlag => _creditModeFlag;
  String _creditModeBy = '';
  String get creditModeBy => _creditModeBy;
  void setBottomBarHide() {
    _bottomBarHide = !_bottomBarHide;
    notifyListeners();
  }

  bool _otherPaymentFlag = false;
  bool get otherPaymentFlag => _otherPaymentFlag;
  bool _creditPaymentFlag = false;
  bool get creditPaymentFlag => _creditPaymentFlag;
  String _paymentMode = 'Payment Mode';
  String get paymentMode => _paymentMode;



  void creditModeFunc(String mode, bool value){
    _creditModeFlag = value;
    _creditModeBy = mode;
    print('.......selected payment mode from UI is .........'+mode);
    notifyListeners();
  }

  void cartState(String state, bool value){

    if (state == 'CREDIT'){
      _creditPaymentFlag = value;
    }
    else{{_otherPaymentFlag = value;}}
    _paymentMode = state;
    print('.......selected payment mode from UI is .........'+state);
    notifyListeners();
  }


  bool _secondScreen = false;
  bool _thirdScreen = false;

  bool get secondScreen => _secondScreen;
  bool get thirdScreen => _thirdScreen;

  String _orderPagePayment = '';
  String get orderPagePayment => _orderPagePayment;

  void orderPageState(value2, value3, {value4 = false}){
    _secondScreen = value2;
    _thirdScreen = value3;
    notifyListeners();
  }
  void setOrderPagePayment({String mode:''}){
    _orderPagePayment = mode;
    notifyListeners();
  }

  bool _customerSecondScreen = false;
  bool _customerThirdScreen = false;

  bool get customerSecondScreen => _customerSecondScreen;
  bool get customerThirdScreen => _customerThirdScreen;



  void setCustomerPageState(value2, value3){
    _customerSecondScreen = value2;
    _customerThirdScreen = value3;
    notifyListeners();
  }


  //.....................................................inputs by gayar...........................................................................................................





  List tempListOfCategories = [];
  List get finalListOfCategories => tempListOfCategories;
  List tempListOfBrands = [];
  List get finalListOfBrands => tempListOfBrands;
  List<Map> _EditableproductsListForCart = [];
  int indexOfProductInCart = -1;
  double discountProvided = 0.0;

  double subTotalValue = 0.0;
  double cartTotalValue = 0.0;
  double cgstValue = 0.0;
  double sgstValue = 0.0;
  double cessValue = 0.0;
  bool includeTaxesValue = true;

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
  String barcode = "";
  String barcodedProductName = "";
  String tempBarcode = "";
  String get finalBarcode => barcode;
  bool displayCustomProductPage = false, tempIsCustomerSelectedInCart = false, tempAllowCartSubnissiom = false;
  bool get isCustomerSelectedInCart => tempIsCustomerSelectedInCart;
  bool get allowCartSubmissiom => tempAllowCartSubnissiom;
  int get totalCartQuantity => tempCartQuantity;
  String tempPaymentMethod = "";
  double tempTotalAmountPaid = 0.0, tempCredit = 0.0;
  String get customerID => selectedCustomer['id'].toString();
  String get paymentMethod => tempPaymentMethod;
  double get AmountPaid => tempTotalAmountPaid;
  double get credit => tempCredit;
  List<Map> get customersInDatabaseToDisplay => tempCustomersInDatabaseToDisplay;
  List<Map> tempCustomersInDatabaseToDisplay = [];
  List<Map<String, dynamic>> _stack = [null];
  List<Map<String, dynamic>> get stack => _stack;
  List<Map<String, dynamic>> _dbProducts ;
  List<Map<String, dynamic>> _dbCustomProducts ;
  List<Map<String, dynamic>> _dbCategories ;
  List<Map<String, dynamic>> get dbProducts => List<Map>.from(_dbProducts);
  List<Map<String, dynamic>> get dbCustomProducts => List<Map>.from(_dbCustomProducts);
  List<Map<String, dynamic>> get dbCategories => List<Map>.from(_dbCategories);

  // The currently selected category of products.
  String _selectedCategory = '';
  String get selectedCategory => _selectedCategory;
  int tempCartQuantity = 0;




  // Adds a Editable product to the cart.
  addEditableProductToCart(Map product) {
    print("enter into addEditableProductToCart\n\n received argumet: $product");
    //print("\n\nentered state of _EditableproductsListForCart: $_EditableproductsListForCart");

    Map _EditableproductsInCart = {};
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

  // Removes an item from the cart Starts
  void removeEditableItemFromCart(Map product, String actionToPerform) {


    var indexOfItemToRemove = _EditableproductsListForCart.indexWhere((p) => p['id'] == product['id']);

    print("enter into removeItemFromCart(cartModel, product)\n\n received argumet: $product\n\n indexOfItemToRemove = $indexOfItemToRemove\n\n");

    if (actionToPerform == "clear_cart") {
      print("Request received to clear Cart\n\n");
      _EditableproductsListForCart.clear();
      discountProvided = 0.0;
      subTotalValue = 0.0;
      cgstValue = 0.0;
      cartTotalValue = 0.0;
      sgstValue = 0.0;
      cessValue = 0.0;
      includeTaxesValue = false;
      barcode = "";
      barcodedProductName = "";
      tempBarcode = "";
      selectedCustomer = {};


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
          print("Current Quantity = ${_EditableproductsListForCart[indexOfItemToRemove]['quantity']}");
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
    print("\n\nexiting remove item gfrom cart");
    notifyListeners();
  }
  // Removes an item from the cart Ends

  //changeProductValue starts
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
  //changeProductValue Ends

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

  bool flagToCheckBarcodeState = false;
  processBarcode(RawKeyEvent key) {


    print("Event runtimeType is ${key.runtimeType}");
    print(key.logicalKey);
    print(key.physicalKey);
    print(key.data);
    if(key.runtimeType.toString() == 'RawKeyDownEvent'){
      if (key.data.logicalKey.keyLabel != null) {
        tempBarcode = tempBarcode + key.data.keyLabel;
        barcode = tempBarcode;
        print("\n\n${barcode}");
        flagToCheckBarcodeState = true;

      }
      else {
        flagToCheckBarcodeState = false;

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
    print("\n\n flagToCheckBarcodeState in process barcode = ${flagToCheckBarcodeState}\n\n");

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

    }
    else if(productListFromCustomProductTable.length > 0) {
      addEditableProductToCart(productListFromCustomProductTable[0]);
      calculateCartTotalValue(Discount.toString());
      displayCustomProductPage = false;
      print("custom product detected");
    }
    else if (barcodedProductList.length > 0) {
      barcodedProductName = barcodedProductList[0]['name'];
      displayCustomProductPage = true;
      print("Barcoded product detected but need to add new custom product = $barcode\n\n");
    }
    else {
      barcodedProductName = "";
      displayCustomProductPage = true;
      print("Barcoded product not detected and need to add new custom product = $barcode\n\n");
    }

    notifyListeners();
    //print(barcode);
  }


  void analyzeCredit (double totalAmountPaid, String paymentMode, bool isCredit) {
    print("\n\n analyzeCredit entered");
    if (isCredit) {
      tempTotalAmountPaid = totalAmountPaid;
      tempCredit = cartTotalValue - tempTotalAmountPaid;
    }
    else {
      tempTotalAmountPaid = totalAmountPaid;
      tempCredit = 0;
    }
    tempPaymentMethod = paymentMode;

    print("\n\ntempTotalAmountPaid = $tempTotalAmountPaid :::: cartTotalValue = $cartTotalValue");
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
  void generateInvoice (bool printReceipt, bool isCredit) async{

    print("\n\nenter into generate invoice");
    String invoiceNumber = "invoice_${DateTime.now().toString()}";
    bool is_receipt_printed = printReceipt;
    List<Map<String, dynamic>> storeProductsInCart = [];




    // Adding order items to table
    int totalOrderQuantity = 0;
    List<Map<String, dynamic>> enterProductsToCart = [];

    _EditableproductsListForCart.forEach((item) {
      Map<String, dynamic> productItem = {};
      item[DatabaseHelper.order_id] = invoiceNumber;
      totalOrderQuantity = totalOrderQuantity + int.parse(item['quantity'].toString());

      item.forEach((key, value){
        print("$key::::$value");
        productItem[key.toString()] = value;
      });
      enterProductsToCart.add(productItem);
      print("\n\nproduct items to be inserted: $productItem\n\n");
    });


    List<orderItems> ordersListParsedFromCartItems = enterProductsToCart.map((i) => orderItems.fromJson(i)).toList();
    await insert_Order_Products(ordersListParsedFromCartItems);



    //Adding Order to table
    Map<String, dynamic> rowOrder = {
      DatabaseHelper.invoice : invoiceNumber,
      DatabaseHelper.cart_total : subTotal,
      DatabaseHelper.cart_discount_total : discountProvided,
      DatabaseHelper.paid_amount_total : tempTotalAmountPaid,
      DatabaseHelper.customer_id : customerID,
      DatabaseHelper.cgst : cgstValue,
      DatabaseHelper.sgst : sgstValue,
      DatabaseHelper.cess : cessValue,
      DatabaseHelper.is_receipt_printed : is_receipt_printed,
      DatabaseHelper.payment_method : tempPaymentMethod,
      DatabaseHelper.status : "completed",
      DatabaseHelper.total_items : ordersListParsedFromCartItems.length,
      DatabaseHelper.total_quantity : totalOrderQuantity,
      DatabaseHelper.updated_at : new DateTime.now().toString()
    };

    print('\n\n${DatabaseHelper.ordersTable} Order Row to be inserted: $rowOrder\n\n');
    var return_id = await dbHelper.insert(DatabaseHelper.ordersTable, rowOrder);
    print('${DatabaseHelper.ordersTable} inserted row id on order submission: $return_id');


    //Adding Credit to table
    print('\n\n${DatabaseHelper.customerCreditTable} check status of credit: $isCredit\n\n');
    if (isCredit) {
      Map<String, dynamic> rowCredit = {
        DatabaseHelper.customer_id : customerID,
        DatabaseHelper.amount : tempCredit,
        DatabaseHelper.order_id : invoiceNumber,
        DatabaseHelper.updated_at : new DateTime.now().toString()
      };

      return_id = await dbHelper.insert(DatabaseHelper.customerCreditTable, rowCredit);
      print('\n\n${DatabaseHelper.customerCreditTable} inserted row id on order submission: $return_id\n\n');
    }

    // Update customer Data

    if (selectedCustomer.length>0) {


      var totalOrders = (selectedCustomer['total_orders'] == "") ? 1 : (int.parse(selectedCustomer['total_orders'].toString()) + 1);
      var totalSpent = (selectedCustomer['total_spent'].toString() == "") ? tempTotalAmountPaid : (double.parse(selectedCustomer['total_spent'].toString()) + tempTotalAmountPaid);
      var totalDiscountOfCustomer = (selectedCustomer['total_discount'] == "") ? Discount : (double.parse(selectedCustomer['total_discount'].toString()) + Discount);
      var credit_balance = (selectedCustomer['credit_balance'] == "") ? credit : (double.parse(selectedCustomer['credit_balance'].toString()) + credit);
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

      print("\n\nCustomer row to be updated: $row\n\n");
//    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(DatabaseHelper.customerTable, id, DatabaseHelper.id,"=");
      insertRow(customerID, row, DatabaseHelper.customerTable,"=");

    }

//
//
//    // Adding order items to table
//    _EditableproductsListForCart.forEach((p) {
//      p[DatabaseHelper.order_id] = invoiceNumber;
//    }
//    );

    // Updating Inventory
    enterProductsToCart.forEach((p) {
      if (!p.containsKey(DatabaseHelper.to_be_saved)) {
        p['id'] = p['product_id'].toString();
        p[DatabaseHelper.inventory] = (int.parse(p[DatabaseHelper.inventory]) - p['quantity']).toString();
        storeProductsInCart.add(p);
        print("\n\n Updated product inventory : $p");
      }
    }
                                );

    if (storeProductsInCart.length > 0) {
      print("storeProductsInCart = ${storeProductsInCart}");
      List<products> productsListParsedFromCart = storeProductsInCart.map((i) => products.fromJson(i)).toList();
      insert_products(productsListParsedFromCart);
    }

//    List<Map<String, dynamic>> allCategories = await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.productCategoriesTable} WHERE ${DatabaseHelper.parent_id} = 'null'");
//    print(allCategories);



//    List<Map<String, dynamic>> allOrders = await dbHelper.queryAllRows(DatabaseHelper.ordersTable);
//    List<Map<String, dynamic>> allItems = await dbHelper.queryAllRows(DatabaseHelper.orderProductsTable);
//    List<Map<String, dynamic>> allCreditItems = await dbHelper.queryAllRows(DatabaseHelper.customerCreditTable);
//    List<Map<String, dynamic>> updatedProduct = await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.productsTable} WHERE ${DatabaseHelper.id} = '${storeProductsInCart[0]['id']}'");
//
//    print("verify entry into order table: $allOrders\n\n\n");
//    print("verify entry into allItems table: $allItems\n\n\n");
//    print("verify entry into allCreditItems table: $allCreditItems\n\n\n");
//    print("verify entry into updatedProduct table: $updatedProduct\n\n\n");


    print("\n\n All Data inserted Successfully");
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
    tempPaymentMethod = "";
    selectedCustomer = {};
    calculateCartTotalValue(Discount.toString());


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


  bool _isNumeric(String str) {
    if(str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  // Code for adding customer Ended

// Code for adding custom Item Started

  //String fina = finalBarcode;

  //call from +custom item button
  void updateFlagOfAddCustomItem (bool status) {
    displayCustomProductPage = status;
    notifyListeners();
  }

  void addCustomItem (String name, String mrp, String sp, String cgst, String sgst, String cess, String category, String brand) async {

    print("\n\nEntered into Add Custom Item :::: retrievedCategories = $retrievedCategories");

    int categoryID = retrievedCategories.indexWhere(((p) => p['name'] == category));

    print("\n\nEntered into Add Custom Item :::: categoryID = $categoryID");
    Map<String, dynamic> row = {
      DatabaseHelper.name : name,
      DatabaseHelper.mrp : (mrp != "") ? double.parse(mrp) : 0.0,
      DatabaseHelper.sp : (sp != "") ? double.parse(sp) : 0.0,
      DatabaseHelper.cgst : (cgst != "") ? double.parse(cgst) : 0.0,
      DatabaseHelper.sgst : (sgst != "") ? double.parse(sgst) : 0.0,
      DatabaseHelper.cess : (cess != "") ? double.parse(cess) : 0.0,
      DatabaseHelper.to_be_saved : true,
      DatabaseHelper.barcode : finalBarcode,
      DatabaseHelper.category_id : (categoryID>=0) ? retrievedCategories.firstWhere(((p) => p['name'] == category))['id'] : "null",
      DatabaseHelper.brand : brand,
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

    addEditableProductToCart(addedCustomItemFromDatabse[0]);


    notifyListeners();

  }
// Code for adding custom Item Ended

  // Code to get list of categories
  List<Map> retrievedCategories = [];
  getListOfCategories () async{

    tempListOfCategories = [];
    String query = "SELECT * FROM ${DatabaseHelper.productCategoriesTable} ORDER BY "
        "${DatabaseHelper.name}";
    retrievedCategories = await dbHelper.raw_query(query);
    print("\n\nretrievedCategories = $retrievedCategories");

    retrievedCategories.forEach((item) {
      if (!tempListOfCategories.contains(item)){
        tempListOfCategories.add(item[DatabaseHelper.name]);
      }

    });
    print("\n\ntempListOfCategories = $tempListOfCategories");

    notifyListeners();

  }

  // Code to get list of brands

  getListOfBrands () async{
    List<Map> retrievedBrands = [];
    tempListOfBrands = [];
    String query = "SELECT ${DatabaseHelper.brand} FROM ${DatabaseHelper.productsTable} ORDER BY "
        "${DatabaseHelper.brand}";
    retrievedBrands = await dbHelper.raw_query(query);
    print("\n\nretrievedBrands = $retrievedBrands");


    retrievedBrands.forEach((item) {
      if(!tempListOfBrands.contains(item)) {

        tempListOfBrands.add(item[DatabaseHelper.brand]);
      }

    });
    print("\n\tempListOfBrands = $tempListOfBrands");

    notifyListeners();

  }






  // Code Specific for StockRequest and items

  List<Map> tempRequestStocksToDisplay = [];
  List<Map> get finalRequestStocksToDisplay => tempRequestStocksToDisplay;
  List<Map> tempRequestStockItemsToDisplay = [];
  List<Map> get finalRequestStockItemsToDisplay => tempRequestStockItemsToDisplay;
  int stockRequestGeneratedID = 0;
  List<Map> tempGeneratedRequestStocksToDisplay = [];
  List<Map> get finalGeneratedRequestStocksToDisplay => tempGeneratedRequestStocksToDisplay;
  List<Map> tempGeneratedRequestStockItemsToDisplay = [];
  List<Map> get finalGeneratedRequestStockItemsToDisplay => tempGeneratedRequestStockItemsToDisplay;

  Map tempSelectedStock = {};
  Map get finalSelectedStock => tempSelectedStock;
  double totalStockRequestAmount = 0.0;
  double get finalTotalStockRequestAmount => totalStockRequestAmount;


  //Code to getStockRequestsFromDatabase in Database Starts
  getStockRequestsFromDatabase(String status /*"delivered" or "all"*/) async {
    print("\n\nEnter Into getStockRequestsFromDatabase");

    tempRequestStocksToDisplay = [];
    List<Map> retrievedStocks = [];
    if (status == "delivered") {
      String query = "SELECT * FROM ${DatabaseHelper.packageDispatch} ORDER BY ${DatabaseHelper.updated_at} DESC";
      retrievedStocks = await dbHelper.raw_query(query);
      print("\n\nretrievedDeliveredStocks = $retrievedStocks");
    }
    else {
      String query = "SELECT * FROM ${DatabaseHelper.stockRequestsTable} ORDER BY ${DatabaseHelper.updated_at} DESC";
      retrievedStocks = await dbHelper.raw_query(query);
      print("\n\nretrievedAllStocks = $retrievedStocks");
    }

    retrievedStocks.forEach((item) {
      Map stockTemp = {};
      item.forEach((key, value) {
        stockTemp[key.toString()] = value;
      });
      int index = tempRequestStocksToDisplay.indexWhere((p) => p['id'] == stockTemp['id']);
      print("\n\n orderTemp = $stockTemp");
      if (index < 0) {
        tempRequestStocksToDisplay.add(stockTemp);
      }

    });

    print("\n\ntempOrdersInDatabaseToDisplay = $tempRequestStocksToDisplay");
    print("\n\nfinalOrdersToDisplay = $finalRequestStocksToDisplay");

    notifyListeners();

  }
  //Code to getStockRequestsFromDatabase in Database Ends

  //Code to getStockRequestItemsFromDatabase in Database Starts
  getStockRequestItemsFromDatabase(int id, String tableName, Map selectedOrder) async {
    print("\n\nEnter Into getStockRequestItemsFromDatabase");

    tempSelectedStock = selectedOrder;
    tempRequestStockItemsToDisplay = [];
    List<Map> retrievedStockItems = [];

    String query = '';

    if (tableName == 'dispatch') {
      query = "SELECT ${DatabaseHelper.stockRequestsProductsTable}.*, ${DatabaseHelper.productsTable}.${DatabaseHelper.name} as storeProductName"
          ", ${DatabaseHelper.customProductsTable}.${DatabaseHelper.name} as customProductName"
          " FROM ${DatabaseHelper.stockRequestsProductsTable} "
          "LEFT OUTER JOIN ${DatabaseHelper.productsTable} ON "
          "${DatabaseHelper.productsTable}.${DatabaseHelper.id} = ${DatabaseHelper.stockRequestsProductsTable}.${DatabaseHelper.product_id} "
          "LEFT OUTER JOIN ${DatabaseHelper.customProductsTable} ON ${DatabaseHelper.customProductsTable}.${DatabaseHelper.id} = "
          "${DatabaseHelper.stockRequestsProductsTable}.${DatabaseHelper.custom_product_id} "
          "WHERE ${DatabaseHelper.stockRequestsProductsTable}.${DatabaseHelper.packageId} = '$id' "
          "ORDER BY ${DatabaseHelper.updated_at} DESC";
    }
    else {
      query = "SELECT ${DatabaseHelper.stockRequestsProductsTable}.*, ${DatabaseHelper.productsTable}.${DatabaseHelper.name} as storeProductName"
          ", ${DatabaseHelper.customProductsTable}.${DatabaseHelper.name} as customProductName"
          " FROM ${DatabaseHelper.stockRequestsProductsTable} "
          "LEFT OUTER JOIN ${DatabaseHelper.productsTable} ON "
          "${DatabaseHelper.productsTable}.${DatabaseHelper.id} = ${DatabaseHelper.stockRequestsProductsTable}.${DatabaseHelper.product_id} "
          "LEFT OUTER JOIN ${DatabaseHelper.customProductsTable} ON ${DatabaseHelper.customProductsTable}.${DatabaseHelper.id} = "
          "${DatabaseHelper.stockRequestsProductsTable}.${DatabaseHelper.custom_product_id} "
          "WHERE ${DatabaseHelper.stockRequestsProductsTable}.${DatabaseHelper.stock_request_id} = '$id' "
          "ORDER BY ${DatabaseHelper.updated_at} DESC";
    }


    print("\n\nquery= $query");
    retrievedStockItems = await dbHelper.raw_query(query);
    print("\n\nretrievedStockItems = $retrievedStockItems");

    retrievedStockItems.forEach((item) {
      Map stockItemTemp = {};
      item.forEach((key, value) {
        stockItemTemp[key.toString()] = value;
      });
      stockItemTemp['${DatabaseHelper.accepted_qty}'] = stockItemTemp['${DatabaseHelper.delivered_qty}'];
      print("\n\n stockItemTemp = $stockItemTemp");
      int index = tempRequestStockItemsToDisplay.indexWhere((p) => p['id'] == stockItemTemp['id']);
      if (index < 0) {
        tempRequestStockItemsToDisplay.add(stockItemTemp);
      }
    });

    totalStockRequestAmount = 0.0;
    tempRequestStockItemsToDisplay.forEach((item){
      print("\n\ntotalStockRequestAmount = $totalStockRequestAmount :::: accepted_qty = ${item['${DatabaseHelper.accepted_qty}']}"
                " :::: product_price = ${item['${DatabaseHelper.product_price}']}");
      totalStockRequestAmount = totalStockRequestAmount + int.parse(item['${DatabaseHelper.accepted_qty}'].toString())*double.parse(item['${DatabaseHelper.product_price}'].toString());
    });

    print("\n\ntempRequestStockItemsToDisplay = $tempRequestStockItemsToDisplay");
    print("\n\nfinalRequestStockItemsToDisplay = $finalRequestStockItemsToDisplay");

    notifyListeners();

  }
  //Code to getStockRequestItemsFromDatabase in Database Ends

  //Code to saveStockRequestToDatabase in Database Starts
  saveStockRequestToDatabase() async {
    print("\n\nEnter Into getStockRequestItemsFromDatabase");

    int total_quantity = 0;
    stockRequestGeneratedID = 0;
    _EditableproductsListForCart.forEach((item) {
      total_quantity  = total_quantity + item["quantity"];
    });

    Map<String, dynamic> row = {
      DatabaseHelper.status : "request sent",
      DatabaseHelper.updated_at : new DateTime.now().toString(),
      DatabaseHelper.total_quantity : total_quantity,
      DatabaseHelper.total_items : _EditableproductsListForCart.length

    };

//    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(DatabaseHelper.stockRequestsTable, id, DatabaseHelper.id,"=");
    final return_id = await dbHelper.insert(DatabaseHelper.stockRequestsTable, row);
    print('${DatabaseHelper.stockRequestsTable} inserted row id: $return_id');

    stockRequestGeneratedID = return_id;

    tempGeneratedRequestStocksToDisplay = await dbHelper.raw_query("Select * from ${DatabaseHelper.stockRequestsTable} WHERE ${DatabaseHelper.id} = '$stockRequestGeneratedID'");
    tempSelectedStock = {};
    tempGeneratedRequestStocksToDisplay[0].forEach((key, value) {
      tempSelectedStock['$key'] = value;
    });


    //Add stockRequestsProductsTable
    _EditableproductsListForCart.forEach((item) async {
      Map<String, dynamic> row = {
        DatabaseHelper.stock_request_id : stockRequestGeneratedID,
        DatabaseHelper.product_id : item['product_id'],
        DatabaseHelper.custom_product_id : item['custom_product_id'],
        DatabaseHelper.requested_qty : item['quantity'],
        DatabaseHelper.accepted_qty : 0,
        DatabaseHelper.note : "",
        DatabaseHelper.delivered_qty : 0,
        DatabaseHelper.product_price : 0.0,
        DatabaseHelper.barcode : item['barcode'],
        DatabaseHelper.updated_at : new DateTime.now().toString()

      };

//    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(DatabaseHelper.stockRequestsProductsTable, id, DatabaseHelper.id,"=");
      //print(listOfItems);
      final return_id = await dbHelper.insert(DatabaseHelper.stockRequestsProductsTable, row);
      print('${DatabaseHelper.stockRequestsProductsTable} inserted row id: $return_id');
    });

    await getStockRequestItemsFromDatabase(stockRequestGeneratedID, 'request', tempSelectedStock);

    removeEditableItemFromCart({},"clear_cart");
    notifyListeners();

  }
  //Code to saveStockRequestToDatabase in Database Ends

  //Code to updateStockRequestToDatabase in Database Starts
  updateStockRequestToDatabase() async {
    print("\n\nEnter Into getStockRequestItemsFromDatabase");

    int total_quantity = 0;
    stockRequestGeneratedID = 0;
    _EditableproductsListForCart.forEach((item) {
      total_quantity  = total_quantity + item["quantity"];
    });

    Map<String, dynamic> row = {
      DatabaseHelper.status : "request_sent",
      DatabaseHelper.delivered_at : "",
      DatabaseHelper.accepted_at : "",
      DatabaseHelper.total_amount : "",
      DatabaseHelper.temp_id : "",
      DatabaseHelper.updated_at : new DateTime.now().toString(),
      DatabaseHelper.total_quantity : total_quantity

    };

//    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(DatabaseHelper.stockRequestsTable, id, DatabaseHelper.id,"=");
    final return_id = await dbHelper.insert(DatabaseHelper.stockRequestsTable, row);
    print('${DatabaseHelper.stockRequestsTable} inserted row id: $return_id');

    stockRequestGeneratedID = return_id;

    tempGeneratedRequestStocksToDisplay = await dbHelper.raw_query("Select * from ${DatabaseHelper.stockRequestsTable} WHERE ${DatabaseHelper.id} = '$stockRequestGeneratedID'");

    //Add stockRequestsProductsTable
    _EditableproductsListForCart.forEach((item) async {
      Map<String, dynamic> row = {
        DatabaseHelper.stock_request_id : stockRequestGeneratedID,
        DatabaseHelper.product_id : item['product_id'],
        DatabaseHelper.custom_product_id : item['custom_product_id'],
        DatabaseHelper.requested_qty : item['quantity'],
        DatabaseHelper.accepted_qty : 0,
        DatabaseHelper.note : "",
        DatabaseHelper.delivered_qty : 0,
        DatabaseHelper.product_price : 0.0,
        DatabaseHelper.barcode : item['barcode'],
        DatabaseHelper.updated_at : new DateTime.now().toString()

      };

//    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(DatabaseHelper.stockRequestsProductsTable, id, DatabaseHelper.id,"=");
      //print(listOfItems);
      final return_id = await dbHelper.insert(DatabaseHelper.stockRequestsProductsTable, row);
      print('${DatabaseHelper.stockRequestsProductsTable} inserted row id: $return_id');
    });

    tempGeneratedRequestStockItemsToDisplay = await dbHelper.raw_query("Select * from ${DatabaseHelper.stockRequestsProductsTable} WHERE ${DatabaseHelper.stock_request_id} = '$stockRequestGeneratedID'");

    notifyListeners();

  }
  //Code to updateStockRequestToDatabase in Database Ends

  //Code to cancelStockRequest in Database Starts
  cancelStockRequest(int id) async {
    print("\n\nEnter Into cancelStockRequest :::: id = id");

    tempSelectedStock[DatabaseHelper.status] = 'canceled';
//    String query = "UPDATE ${DatabaseHelper.stockRequestsTable} SET ${DatabaseHelper.status} = 'canceled', ${DatabaseHelper.updated_at} = "
//        "'${new DateTime.now().toString()}' WHERE ${DatabaseHelper.id} = '$id'";
    Map<String, dynamic> tempStockToUpdate = {};

    tempSelectedStock.forEach((key, value) {
      tempStockToUpdate['$key'] = value;
    });

    await dbHelper.update(DatabaseHelper.stockRequestsTable, tempStockToUpdate, DatabaseHelper.id, tempSelectedStock['id']);

//    await dbHelper.raw_query(query);

    String query2 = "SELECT * FROM ${DatabaseHelper.stockRequestsTable} WHERE ${DatabaseHelper.id} = '$id'";

    List<Map> updatedItem = await dbHelper.raw_query(query2);
    print("\n\n updatedItem = $updatedItem\n\n");

    notifyListeners();

  }
  //Code to cancelStockRequest in Database Ends

  //Code to acceptStockQuantitySetter in Database Starts
  acceptStockQuantitySetter(int id, int updatedQuantity) async {
    print("\n\nEnter Into cancelStockRequest :::: id = id");
    int index = tempRequestStockItemsToDisplay.indexWhere((p) => p['id'].toString() == '$id');
    tempRequestStockItemsToDisplay[index]['${DatabaseHelper.accepted_qty}'] = updatedQuantity;
    print("\n\n tempRequestStockItemsToDisplay = ${tempRequestStockItemsToDisplay[index]}\n\n");

    totalStockRequestAmount = 0.0;
    tempRequestStockItemsToDisplay.forEach((item){
      print("\n\ntotalStockRequestAmount = $totalStockRequestAmount :::: accepted_qty = ${item['${DatabaseHelper.accepted_qty}']}"
                " :::: product_price = ${item['${DatabaseHelper.product_price}']}");
      totalStockRequestAmount = totalStockRequestAmount + int.parse(item['${DatabaseHelper.accepted_qty}'].toString())*double.parse(item['${DatabaseHelper.product_price}'].toString());
    });

    notifyListeners();

  }
  //Code to acceptStockQuantitySetter in Database Ends

  //Code to updateDatabaseOnAcceptStock in Database Starts
  updateDatabaseOnAcceptStock() async {
    print("\n\nEnter Into updateDatabaseOnAcceptStock");


    int totalAcceptedQuantity = 0;
    List<Map<String, dynamic>> RequestStockItemsToBeUpdate =[];
    tempRequestStockItemsToDisplay.forEach((item) async {
      Map<String, dynamic> tempStockToUpdate = {};
      totalAcceptedQuantity = totalAcceptedQuantity + item['${DatabaseHelper.accepted_qty}'];
      item.forEach((key, value) {
        tempStockToUpdate['$key'] = value;
      });
    });

    List<requestStockItems> stockRequestsProductsListParsedFromJson = RequestStockItemsToBeUpdate.map((i) => requestStockItems.fromJson(i)).toList();

    await insert_stockRequestsProducts(stockRequestsProductsListParsedFromJson);


    String query2 = "SELECT * FROM ${DatabaseHelper.stockRequestsProductsTable} WHERE ${DatabaseHelper.packageId} = '${tempSelectedStock['id']}'";

    List<Map> updatedStockItems = await dbHelper.raw_query(query2);
    print("\n\n updatedItem = $updatedStockItems :::: item to be updated = : $insert_stockRequestsProducts\n\n");



    tempSelectedStock[DatabaseHelper.status] = 'accepted';
    tempSelectedStock[DatabaseHelper.total_amount] = totalStockRequestAmount;
    tempSelectedStock[DatabaseHelper.total_quantity] = totalAcceptedQuantity;
    tempSelectedStock[DatabaseHelper.total_items] = tempRequestStockItemsToDisplay.length;
    Map<String, dynamic> tempStockToUpdate = {};

    tempSelectedStock.forEach((key, value) {
      tempStockToUpdate['$key'] = value;
    });
    tempStockToUpdate['${DatabaseHelper.accepted_at}'] = new DateTime.now().toString();

    print("\n\n tempSelectedStock = $tempSelectedStock :::: tempStockToUpdate = $tempStockToUpdate\n\n");

    await dbHelper.update(DatabaseHelper.packageDispatch, tempStockToUpdate, DatabaseHelper.id, tempSelectedStock['id']);

//    await dbHelper.raw_query(query);

    query2 = "SELECT * FROM ${DatabaseHelper.packageDispatch} WHERE ${DatabaseHelper.id} = '${tempSelectedStock['id']}'";

    List<Map> updatedItem = await dbHelper.raw_query(query2);
    print("\n\n updatedItem = $updatedItem\n\n");


    notifyListeners();

  }
  //Code to updateDatabaseOnAcceptStock in Database Ends














// Code for customer management

  String get prefillField => tempPrefillFieldType;
  String tempPrefillFieldType;
  String get PrefillFieldContentCustomer => tempPrefillFieldContentCustomer;
  String tempPrefillFieldContentCustomer;
  Map selectedCustomer = {};
  Map get finalselectedCustomer => selectedCustomer;
  List<Map> tempOrdersInDatabaseToDisplay = [];
  List<Map> get finalOrdersToDisplay => tempOrdersInDatabaseToDisplay;
  double amountPaidTemp = 0.0;
  double get finalAmountPaid => amountPaidTemp;
  double creditTemp = 0.0;
  double get finalRemainingCredit => creditTemp;
  double get totalCreditsFinal => totalCreditsTemp;
  double totalCreditsTemp = 0.0;


  //Code to calculateCredit in Database Starts
  calculateCredit (String amountPaid) {
    print("\n\nEnter into updateCreditValue :::: selectedCustomer['credit_balance'] = ${selectedCustomer['credit_balance']} :::: amountPaid"
              " = $amountPaid");
    amountPaidTemp = double.parse(amountPaid);
    creditTemp = double.parse(selectedCustomer['credit_balance']) - double.parse(amountPaid);
    print("\n\n$creditTemp");
    notifyListeners();
  }
  //Code to calculateCredit in Database Ends


  //Code to Search customer in Database Starts
  queryCustomerInDatabase (String type /*all, credit*/, String searchString) async {
    print("Entered into queryCustomerInDatabase");
    tempCustomersInDatabaseToDisplay = [];
    tempPrefillFieldType = "";
    selectedCustomer = {};
    List<Map<String, dynamic>> customerList = [];



    if (type == "credit") {
      if (searchString.length < 3) {
        String searchQueryPhoneNumber = "SELECT * FROM ${DatabaseHelper.customerTable} WHERE ${DatabaseHelper.credit_balance} != '0' AND ${DatabaseHelper.credit_balance} != '0.0' AND ${DatabaseHelper.credit_balance} != '' ORDER BY ${DatabaseHelper.name}";
        customerList = await dbHelper.raw_query(searchQueryPhoneNumber);
        tempPrefillFieldType = "";
      }
      else if (searchString.length >= 3) {
        if (_isNumeric(searchString)) {
          print("\n\n string is numeric");
          String searchQueryPhoneNumber = "SELECT * FROM ${DatabaseHelper.customerTable} WHERE ${DatabaseHelper.phone_number} LIKE '%$searchString%' COLLATE utf8_general_ci AND ${DatabaseHelper.credit_balance} != '0' AND ${DatabaseHelper.credit_balance} != '0.0' AND ${DatabaseHelper.credit_balance} != '' ORDER BY ${DatabaseHelper.name}";
          customerList = await dbHelper.raw_query(searchQueryPhoneNumber);
          tempPrefillFieldType = "phone";
          tempPrefillFieldContentCustomer = searchString;
        }
        else {
          print("\n\n string is not numeric");
          String searchQueryName = "SELECT * FROM ${DatabaseHelper.customerTable} WHERE ${DatabaseHelper.name} LIKE '%$searchString%' COLLATE utf8_general_ci AND ${DatabaseHelper.credit_balance} != '0' AND ${DatabaseHelper.credit_balance} != '0.0' AND ${DatabaseHelper.credit_balance} != '' ORDER BY ${DatabaseHelper.name}";
          customerList = await dbHelper.raw_query(searchQueryName);
          tempPrefillFieldType = "name";
          tempPrefillFieldContentCustomer = searchString;
        }

      }
    }
    else {

      if (searchString.length < 3) {
        String searchQueryPhoneNumber = "SELECT * FROM ${DatabaseHelper.customerTable} ORDER BY ${DatabaseHelper.name}";
        customerList = await dbHelper.raw_query(searchQueryPhoneNumber);
        tempPrefillFieldType = "";
      }
      else if (searchString.length >= 3) {
        if (_isNumeric(searchString)) {
          print("\n\n string is numeric");
          String searchQueryPhoneNumber = "SELECT * FROM ${DatabaseHelper.customerTable} WHERE ${DatabaseHelper.phone_number} LIKE '%$searchString%' COLLATE utf8_general_ci ORDER BY ${DatabaseHelper.name}";
          customerList = await dbHelper.raw_query(searchQueryPhoneNumber);
          tempPrefillFieldType = "phone";
          tempPrefillFieldContentCustomer = searchString;
        }
        else {
          print("\n\n string is not numeric");
          String searchQueryName = "SELECT * FROM ${DatabaseHelper.customerTable} WHERE ${DatabaseHelper.name} LIKE '%$searchString%' COLLATE utf8_general_ci ORDER BY ${DatabaseHelper.name}";
          customerList = await dbHelper.raw_query(searchQueryName);
          tempPrefillFieldType = "name";
          tempPrefillFieldContentCustomer = searchString;
        }

      }

    }

    print("\n\ncustomerList = $customerList");
    totalCreditsTemp = 0;
    if (customerList.length > 0) {
      customerList.forEach((item) {
        Map tempCustomer = {};
        item.forEach((key, value) {
          tempCustomer[key.toString()] = value.toString();
        });
        totalCreditsTemp = totalCreditsTemp + ((tempCustomer['credit_balance'].toString() != 'null') ?
        double.parse(tempCustomer['credit_balance'].toString()) : 0);
        int index = tempCustomersInDatabaseToDisplay.indexWhere((p) => p['id'] == tempCustomer['id']);

        if (index<0) {
          tempCustomersInDatabaseToDisplay.add(tempCustomer);
        }

      });
    }



    print("tempCustomersInDatabaseToDisplay = $tempCustomersInDatabaseToDisplay :::: tempPrefillFieldType = $tempPrefillFieldType :::: searchString = $searchString :::: tempPrefillFieldContentCustomer = $tempPrefillFieldContentCustomer\n\n");
    notifyListeners();

  }
  //Code to Search customer in Database Ends

  //Code to selectCustomer in Database Starts
  Future<String> selectCustomerById (int id, String source /* "cart" or "customer_section"*/) async {



    if (id < 0){
      selectedCustomer = {};
      notifyListeners();
      print('customer removed');
      return 'customer removed';
    }
    else{
      print(("\n\n tempCustomersInDatabaseToDisplay = $tempCustomersInDatabaseToDisplay"));
      selectedCustomer = tempCustomersInDatabaseToDisplay.firstWhere((p) => p['id'] == id.toString());
      notifyListeners();
      print(("\n\n selectedCustomer = $selectedCustomer"));

      if (source == "cart") {
        return "add_customer_to_cart";
      }
      else {

        await getOrdersFromDatabase(int.parse(selectedCustomer['id'].toString()), "customer_credit_history");

        return "display_customer_details";
      }

    }




  }
  //Code to selectCustomer in Database Ends

  //Code to selectCustomer in Database Ends



  //Code to updateCustomerDatabase in Database Starts
  updateCustomerDatabase (String payment_method) async {

    selectedCustomer["credit_balance"] = finalRemainingCredit;
    print("\n\nEntered into updateCustomerDatabase :::: selectedCustomer to update = $selectedCustomer\n\n");

    Map<String, dynamic> curtomerRowToUpdate = {};

    selectedCustomer.forEach((key, value) {
      curtomerRowToUpdate['$key'] = value;

    });
    insertRow(curtomerRowToUpdate['id'], curtomerRowToUpdate, DatabaseHelper.customerTable,"=");

    //Adding item to credit table
    Map<String, dynamic> row = {
      DatabaseHelper.customer_id : selectedCustomer['id'],
      DatabaseHelper.amount : (0-finalAmountPaid),
      DatabaseHelper.order_id : "not_required",
      DatabaseHelper.updated_at : new DateTime.now().toString(),
      DatabaseHelper.payment_method : payment_method

    };

    final return_id = await dbHelper.insert(DatabaseHelper.customerCreditTable, row);
    amountPaidTemp = 0.0;
    payment_method = "";
    creditTemp = 0.0;

    print("\n\nExiting from updateCustomerDatabase :::: credit table to update = $row :::: selectedCustomer =$selectedCustomer :::: finalAmountPaid = $finalAmountPaid\n\n");

    notifyListeners();

  }
  //Code to updateCustomerDatabase in Database Ends


  // Code to getCustomerById in Database Starts
  Map getCustomerById(int id) {
    //print("Returning product for actions = ${_EditableproductsListForCart.firstWhere((p) => p['id'] == id)} \n\n\n");
    return tempCustomersInDatabaseToDisplay.firstWhere((p) => p['id'] == id);
  }
  // Code to getCustomerById in Database Ends

  // Code to addNewCustomer in Database Starts
  addNewCustomer (String phoneNumber, String name, String source) async {

    Map<String, dynamic> row = {
      DatabaseHelper.name : name,
      DatabaseHelper.phone_number : phoneNumber,
      DatabaseHelper.gender : "",
      DatabaseHelper.total_orders : "0",
      DatabaseHelper.total_spent : "0",
      DatabaseHelper.average_spent : "0",
      DatabaseHelper.total_discount : "0",
      DatabaseHelper.avg_discount_per_order : "0",
      DatabaseHelper.credit_balance : "0",
      DatabaseHelper.updated_at : new DateTime.now().toString()

    };

    print("\n\nCustomer to add = $row\n\n");
    final return_id = await dbHelper.insert(DatabaseHelper.customerTable, row);

    print("\n\nCustomer return_id = $return_id\n\n");
    List<Map> newCustomer = await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.customerTable} WHERE ${DatabaseHelper.id} = '$return_id'");
    print("\n\nCustomer newCustomer = $newCustomer\n\n");
    Map tempCustomer = {};
    newCustomer[0].forEach((key,value) {
      tempCustomer['$key'] = value;
    });
    selectedCustomer = tempCustomer;

    print("\n\n selectedCustomer = $selectedCustomer\n\n");
    _selectCustomerForCartFlag = false;
    notifyListeners();
  }
// Code to addNewCustomer in Database Ends

// Code to addNewCustomer in Database Ends


//  ----------------------Gayar------------------------------

  void setCustomerListData(List<Map<String, dynamic>> customerList){
    tempCustomersInDatabaseToDisplay = customerList;
    print('[from File : manageCustomers.dart] Number of Customers in DB ........ = .........' + tempCustomersInDatabaseToDisplay.length.toString());
    notifyListeners();
  }
  List<Map<String, dynamic>> getCustomers(){
    return tempCustomersInDatabaseToDisplay;

  }

















  // Code to manage orders
  List<Map> tempRefundedOrders = [];
  List<Map> get finalRefundedOrders => tempRefundedOrders;

  String tempDateForFilter = "";
  String tempSearchStringForFilter = "";
  String tempPaymentMethodForFilter = "";
  String tempStatusForFilter = "";
  bool tempCreditForFilter = false;
  String get finalDateForFilter => tempDateForFilter;
  String get finalSearchStringForFilter => tempSearchStringForFilter;
  String get finalPaymentMethodForFilter => tempPaymentMethodForFilter;
  String get finalStatusForFilter => tempStatusForFilter;
  bool get finalCreditForFilter => tempCreditForFilter;

  String tempRefundedOrderPaymentMethod = "";
  String get finalRefundedOrderPaymentMethod => tempRefundedOrderPaymentMethod;

  List<List<Map>> listOfListOfRefundedOrderItems = [];
  List<List<Map>> get finallistOfListOfRefundedOrderItems => listOfListOfRefundedOrderItems;
  List<Map> tempOrderItemsList = [];
  List<Map> get finalOrderItemsList => tempOrderItemsList;
  Map tempSelectedOrder = {};
  Map get finalSelectedOrder => tempSelectedOrder;
  double tempTotalRefundQuantity = 0;
  double tempRefundTotalAmount = 0;
  double tempRefundPaidTotalAmount = 0;
  double tempAmountCredited = 0;
  double get finalTotalRefundQuantity => tempTotalRefundQuantity;
  double get finalRefundTotalAmount => tempRefundTotalAmount;
  double get finalRefundPaidTotalAmount => tempRefundPaidTotalAmount;
  double get finalAmountCredited => tempAmountCredited;

  List<Map> tempOrdersItemsToBeRefunded = [];
  List<Map> get finalOrdersItemsToBeRefunded => tempOrdersItemsToBeRefunded;

  double tempTotalAmountToBeRefunded = 0.0;
  int tempTotalItemsToBeRefunded = 0;
  double get finalAmountToBeRefunded => tempTotalAmountToBeRefunded;
  int get finalItemsItemsToBeRefunded => tempTotalItemsToBeRefunded;
  double tempAmountRefundedToCustomer = 0.0;
  double get finalAmountRefundedToCustomer => tempAmountRefundedToCustomer;
  String tempPaymentModeToCustomer = "";
  String get finalPaymentModeToCustomer => tempPaymentModeToCustomer;



  //Code to getOrdersFromDatabase in Database Starts
  getOrdersFromDatabase(int id, String type /*"customer_credit_history" or "all_orders" or "all_orders_of_customer"*/) async {
    print("\n\nEnter Into getOrdersFromDatabase :::: id = $id");

    tempOrdersInDatabaseToDisplay = [];
    List<Map> retrievedOrders = [];
    if (type == "customer_credit_history") {
      String searchingOrderHistory = "SELECT ${DatabaseHelper.ordersTable}.*, ${DatabaseHelper.customerCreditTable}.amount FROM ${DatabaseHelper.ordersTable} LEFT JOIN ${DatabaseHelper.customerCreditTable} ON ${DatabaseHelper.ordersTable}.${DatabaseHelper.invoice}=${DatabaseHelper.customerCreditTable}.${DatabaseHelper.order_id} WHERE ${DatabaseHelper.ordersTable}.${DatabaseHelper.customer_id} = '$id' AND ${DatabaseHelper.ordersTable}.${DatabaseHelper.payment_method} = 'credit' ORDER BY ${DatabaseHelper.updated_at} DESC";
      retrievedOrders = await dbHelper.raw_query(searchingOrderHistory);
      print("\n\n customer_credit_history :::: Query = $searchingOrderHistory :::: retrievedOrders = $retrievedOrders\n\n");
    }
    else if (type == "all_orders_of_customer"){
      String searchingOrderHistory = "SELECT ${DatabaseHelper.ordersTable}.*, ${DatabaseHelper.customerCreditTable}.${DatabaseHelper.amount} "
          "FROM ${DatabaseHelper.ordersTable} "
          "LEFT JOIN ${DatabaseHelper.customerCreditTable} ON ${DatabaseHelper.ordersTable}.${DatabaseHelper.invoice} = "
          "${DatabaseHelper.customerCreditTable}.${DatabaseHelper.order_id} WHERE ${DatabaseHelper.ordersTable}.${DatabaseHelper.customer_id} "
          "= '$id' ORDER BY ${DatabaseHelper.updated_at} DESC";

      retrievedOrders = await dbHelper.raw_query(searchingOrderHistory);
      print("\n\n all_orders_of_customer :::: Query = $searchingOrderHistory :::: retrievedOrders = $retrievedOrders\n\n");
    }
    else {
      String searchingOrderHistory = "SELECT * FROM ${DatabaseHelper.ordersTable} LEFT JOIN ${DatabaseHelper.customerCreditTable} ON ${DatabaseHelper.ordersTable}.${DatabaseHelper.invoice} = ${DatabaseHelper.customerCreditTable}.${DatabaseHelper.order_id} ORDER BY ${DatabaseHelper.updated_at} DESC";
      retrievedOrders = await dbHelper.raw_query(searchingOrderHistory);
      print("\n\n all_orders :::: Query = $searchingOrderHistory :::: retrievedOrders = $retrievedOrders\n\n");
    }

    retrievedOrders.forEach((item) {
      Map orderTemp = {};
      item.forEach((key, value) {
        orderTemp[key.toString()] = value;
      });
      //print("\n\n orderTemp = $orderTemp");
      tempOrdersInDatabaseToDisplay.add(orderTemp);
    });

    print("\n\ntempOrdersInDatabaseToDisplay = $tempOrdersInDatabaseToDisplay");
    print("\n\nfinalOrdersToDisplay = $finalOrdersToDisplay");

    tempOrderItemsList = [];
    tempSelectedOrder = {};

    notifyListeners();

  }
  //Code to getOrdersFromDatabase in Database Ends

  //Code to filterOrders in Database Starts
  filterOrders (String searchString, String date /*YYYY-DD-MM*/, String paymentMethod, String status, bool isCredit) async {
    tempDateForFilter = date;
    tempSearchStringForFilter = searchString;
    tempPaymentMethodForFilter = paymentMethod;
    tempStatusForFilter = status;
    tempCreditForFilter = isCredit;
    print("entered into filterorders :::: isCredit = $isCredit");
    String finalQuery, query1, query2, query3, query4, query5, query6, query7, query8, query9, query10, query11, query12;

    query1 = "SELECT ${DatabaseHelper.ordersTable}.*, ${DatabaseHelper.customerCreditTable}.${DatabaseHelper.amount}";

    query2 = ", ${DatabaseHelper.customerTable}.${DatabaseHelper.name}, ${DatabaseHelper.customerTable}.${DatabaseHelper.phone_number}";

    query3 = " FROM ${DatabaseHelper.ordersTable} LEFT OUTER JOIN ${DatabaseHelper.orderProductsTable} ON "
        "${DatabaseHelper.ordersTable}.${DatabaseHelper.invoice} = ${DatabaseHelper.orderProductsTable}.${DatabaseHelper.order_id} "
        "LEFT OUTER JOIN ${DatabaseHelper.customerCreditTable} ON ${DatabaseHelper.ordersTable}.${DatabaseHelper.invoice} = "
        "${DatabaseHelper.customerCreditTable}.${DatabaseHelper.order_id} ";

    query4 = "INNER JOIN ${DatabaseHelper.customerTable} ON ${DatabaseHelper.ordersTable}.${DatabaseHelper.customer_id} = "
        "${DatabaseHelper.customerTable}.${DatabaseHelper.id} ";

    query5 = "UPPER(${DatabaseHelper.ordersTable}.${DatabaseHelper.payment_method}) = UPPER('$paymentMethod') ";

    query6 = "UPPER(${DatabaseHelper.ordersTable}.${DatabaseHelper.status}) = UPPER('$status') ";

    query7 = "${DatabaseHelper.ordersTable}.${DatabaseHelper.created_at} > '$date' ";

    query8 = "${DatabaseHelper.customerTable}.${DatabaseHelper.phone_number} LIKE '%$searchString%' COLLATE utf8_general_ci ";

    query9 = "${DatabaseHelper.customerTable}.${DatabaseHelper.name} LIKE '%$searchString%' COLLATE utf8_general_ci ";

    query10 = "GROUP BY ${DatabaseHelper.ordersTable}.${DatabaseHelper.invoice} ORDER BY "
        "${DatabaseHelper.ordersTable}.${DatabaseHelper.updated_at} DESC";

    query11 = "${DatabaseHelper.customerCreditTable}.${DatabaseHelper.amount} != '0' AND "
        "${DatabaseHelper.customerCreditTable}.${DatabaseHelper.amount} != '0.0' AND "
        "${DatabaseHelper.customerCreditTable}.${DatabaseHelper.amount} != '' ";

    tempOrdersInDatabaseToDisplay = [];

    if (searchString.length>=3) {
      print("\n\n${searchString.length}");
      finalQuery = query1+query2+query3+query4+"WHERE ";
    }
    else {
      finalQuery = query1+query3+"WHERE ";
    }

    //Adding Where Clause for credit Filter
    if (isCredit) {
      finalQuery = finalQuery+query11;
    }
    //Adding Where Clause for Date Filter
    if (date != "" && finalQuery.substring(finalQuery.length - 6) == "WHERE ") {
      finalQuery = finalQuery+query7;
    }
    else if (date != "" && finalQuery.substring(finalQuery.length - 6) != "WHERE "){
      finalQuery = finalQuery+"AND "+query7;
    }

    //Adding Where Clause for Status Filter
    if (status != "" && status != "all" && finalQuery.substring(finalQuery.length - 6) == "WHERE ") {

      print("status in if = $status");
      finalQuery = finalQuery+query6;
    }
    else if (status != "" && status != "all" && finalQuery.substring(finalQuery.length - 6) != "WHERE "){
      finalQuery = finalQuery+"AND "+query6;
      print("status in else = $status");
    }

    //Adding Where Clause for payment mode Filter
    if (paymentMethod != "" && finalQuery.substring(finalQuery.length - 6) == "WHERE ") {
      finalQuery = finalQuery+query5;
    }
    else if (paymentMethod != "" && finalQuery.substring(finalQuery.length - 6) != "WHERE "){
      finalQuery = finalQuery+"AND "+query5;
    }

    //Adding Where Clause for Sear String Filter
    if (searchString.length>=3 && _isNumeric(searchString)) {
      if (finalQuery.substring(finalQuery.length - 6) == "WHERE ") {
        finalQuery = finalQuery+query8;
      }
      else if (finalQuery.substring(finalQuery.length - 6) != "WHERE "){
        finalQuery = finalQuery+"AND "+query8;
      }
    }
    if (searchString.length>=3 && !_isNumeric(searchString)) {
      if (finalQuery.substring(finalQuery.length - 6) == "WHERE ") {
        finalQuery = finalQuery+query9;
      }
      else if (finalQuery.substring(finalQuery.length - 6) != "WHERE "){
        finalQuery = finalQuery+"AND "+query9;
      }
    }

    if (finalQuery.substring(finalQuery.length - 6) == "WHERE ") {
      finalQuery = query1+query3+query10;
    }
    else {
      finalQuery = finalQuery+query10;
    }





    print("\n\nquery = ${finalQuery}\n\n");
    List<Map> retrievedOrders = await dbHelper.raw_query(finalQuery);
    print("\n\nretrievedOrders = ${retrievedOrders}");

    print("\n\n number of retrievedOrders = ${retrievedOrders.length}");

    retrievedOrders.forEach((item) {
      Map orderTemp = {};
      item.forEach((key, value) {
        orderTemp[key.toString()] = value;
      });

      int index = tempOrdersInDatabaseToDisplay.indexWhere((p) => p['id'] == item['id']);
      print("\n\n orderTemp = $orderTemp :::: index = $index");
      if (index < 0) {
        tempOrdersInDatabaseToDisplay.add(orderTemp);
      }

    });

//    print("\n\ntempOrdersInDatabaseToDisplay = $tempOrdersInDatabaseToDisplay");
//    print("\n\nfinalOrdersToDisplay = ${finalOrdersToDisplay.length}");

    notifyListeners();

  }
  //Code to filterOrders in Database Ends

  //Code to selectOrder in Database Starts tempSelectedOrder, tempOrderItemsList, selectedCustomer, tempRefundedOrders, tempRefundedOrderItems
  selectOrder (int id) async {
    tempSelectedOrder = tempOrdersInDatabaseToDisplay.firstWhere((p) => p['id'] == id);
    listOfListOfRefundedOrderItems = [];
    tempRefundedOrders = [];

    print("\n\ntempSelectedOrder = $tempSelectedOrder\n");

    if (_isNumeric(tempSelectedOrder['customer_id'].toString())) {
      print("\n\ntempSelectedOrder = $tempSelectedOrder\n\n");
      await orderCustomer(tempSelectedOrder['customer_id']);
    }
    else {
      selectedCustomer = {};
    }

    await itemsOfSelectedOrder(tempSelectedOrder['invoice']);
    if (tempSelectedOrder['status'] != 'completed') {
      await refundListSelectedOrder(tempSelectedOrder['invoice']);

    }

    notifyListeners();
  }
  //Code to selectOrder in Database Ends



  //Code for getting data of orderCustomer starts
  orderCustomer(int id) async {
    print("\n\nEntered into order customer");
    List<Map> customer =  await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.customerTable} WHERE ${DatabaseHelper.id} = '$id'");
    Map tempCustomer = {};
    print("\n\n orderCustomer = $orderCustomer");
    if(customer.length>0) {
      customer[0].forEach((key, value) {
        tempCustomer[key.toString()] = value;
      });
      selectedCustomer = tempCustomer;
    }
    else{
      selectedCustomer = {};
    }

    notifyListeners();
  }
  //Code for getting data of orderCustomer Ends

  List<Map> readOnlyListOftemsSelectedOrder = [];
  List<Map> get finalReadOnlyListOftemsSelectedOrder => readOnlyListOftemsSelectedOrder;

  //Code for getting data of itemsOfSelectedOrder starts
  itemsOfSelectedOrder(String invoice) async {
    readOnlyListOftemsSelectedOrder =  await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.orderProductsTable} "
                                                                    "WHERE ${DatabaseHelper.order_id} = '$invoice'");
    tempOrderItemsList =[];

    readOnlyListOftemsSelectedOrder.forEach((item) async {
      Map tempOrder = {};
      item.forEach((key, value) {
        tempOrder[key.toString()] = value;
      });
      print("\n\ntempOrder = $tempOrder");
      tempOrderItemsList.add(tempOrder);

    });
    print("\n\ntempOrderItemsList = $tempOrderItemsList");
    notifyListeners();
  }
  //Code for getting data of itemsOfSelectedOrder Ends

  //Code for getting data of refundListSelectedOrder starts
  Future refundListSelectedOrder(String invoice) async {
    print("\n\nEntered into refundListSelectedOrder\n\n");
    List<Map> refundListFromDb =  await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.refundTable} WHERE "
                                                               "${DatabaseHelper.order_id} = '$invoice'"
                                                           );

    print("\n\n refundListFromDb = $refundListFromDb\n\n");

    String query = "SELECT * FROM ${DatabaseHelper.OrderRefundItemsTable} WHERE "
        "${DatabaseHelper.order_id} = '$invoice'";
    List<Map> refundItemsFromDb =  await dbHelper.raw_query(query);

    print("\n\n refundItemsFromDb = $refundItemsFromDb :::: query = $query\n\n");

    refundListFromDb.forEach((item) {
      Map tempOrder = {};
      item.forEach((key, value) {
        tempOrder[key.toString()] = value;
      });
      print("\n\ntempRefundedOrder = $tempOrder");
//      int index = tempRefundedOrders.indexWhere((p) => p['${DatabaseHelper.id}'].toString() == tempOrder['id'].toString());
      int index= -1;
      if (index <0 ){
        tempRefundedOrders.add(tempOrder);
      }

      List<Map> tempRefundITems = [];
      refundItemsFromDb.forEach((refundItem) {
        if (refundItem['${DatabaseHelper.refund_id}'] == item['id']) {
          Map refundITemMap = {};
          refundItem.forEach((key, value) {
            refundITemMap['$key'] = value;
          });

          int index = tempOrderItemsList.indexWhere((p) => p['${DatabaseHelper.id}'].toString() == refundItem['${DatabaseHelper.orderItems_id}'].toString());
          refundITemMap['name'] = tempOrderItemsList[index]['name'];
          refundITemMap['mrp'] = tempOrderItemsList[index]['mrp'];
          refundITemMap['sp'] = tempOrderItemsList[index]['sp'];
          refundITemMap['${DatabaseHelper.quantity}'] = refundITemMap['${DatabaseHelper.refund_qty}'];

          print("\n\nrefundITemMap = $refundITemMap\n\n");
          tempRefundITems.add(refundITemMap);
        }
      });
      listOfListOfRefundedOrderItems.add(tempRefundITems);



    });






    print("\n\n listOfListOfRefundedOrderItems = $listOfListOfRefundedOrderItems\n\n");
    print("\n\n listOfListOfRefundedOrderItems length  = ${listOfListOfRefundedOrderItems.length}\n\n");

    print("\n\n tempRefundedOrders = $tempRefundedOrders\n\n");
    print("\n\n tempRefundedOrders length = ${tempRefundedOrders.length}\n\n");
    await orderRefundedDetails(tempRefundedOrders);


    print("\n\n Exited from refundListSelectedOrder\n\n");
    notifyListeners();
  }
  //Code for getting data of orderCustomer Ends

  clearRefundItemList(){
    tempOrdersItemsToBeRefunded = [];
    notifyListeners();
  }

  //Code for getting data of validateRefundQuantity starts
  int validateRefundQuantity(int orderItemId) {
    int orderedQuantity = int.parse(readOnlyListOftemsSelectedOrder.firstWhere((p) => p['id'].toString() == orderItemId.toString())['${DatabaseHelper.quantity}'].toString());
    int refundedQuantity = 0;
    listOfListOfRefundedOrderItems.forEach((item) {
      int index = item.indexWhere((p) => p['${DatabaseHelper.orderItems_id}'].toString() == orderItemId.toString());
      if(index>=0) {
        refundedQuantity = refundedQuantity + item[index]['${DatabaseHelper.refund_qty}'];
      }
    });

    int maxPossibleItems = orderedQuantity - refundedQuantity;
    return maxPossibleItems;
    notifyListeners();
  }
  //Code for getting data of validateRefundQuantity ends

  //Code for getting data of updateRefundDetailsOnUi starts
  updateRefundDetailsOnUi(int refundQuantity, int id) {
    print("\n\n Entered into updateRefundDetailsOnUi\n\n");
    tempTotalAmountToBeRefunded = 0.0;
    tempTotalItemsToBeRefunded = 0;
    print("\n\ntempOrderItemsList before = $tempOrderItemsList\n\n");

    int indexRefundItemToBeUpdated = tempOrderItemsList.indexWhere((p) => p['id'].toString() == id.toString());

    print("\n\ntempOrderItemsList after = $tempOrderItemsList\n\n");
    int indexOfRefundedItem = tempOrdersItemsToBeRefunded.indexWhere((p) => p['id'].toString() == id.toString());
    if (indexOfRefundedItem<0){
      Map refundItem = {};
      refundItem = tempOrderItemsList[indexRefundItemToBeUpdated];

      refundItem['${DatabaseHelper.refund_qty}'] = refundQuantity;
      refundItem['${DatabaseHelper.custom_product_id}'] = tempOrderItemsList[indexRefundItemToBeUpdated]['${DatabaseHelper.custom_product_id}'];
      refundItem['${DatabaseHelper.product_id}'] = tempOrderItemsList[indexRefundItemToBeUpdated]['${DatabaseHelper.product_id}'];
      tempOrdersItemsToBeRefunded.add(refundItem);
    }
    else{
      print("\n\n item in itemto be refunded list\n\n");
      tempOrdersItemsToBeRefunded[indexOfRefundedItem]['${DatabaseHelper.refund_qty}'] = refundQuantity;
    }

    tempOrdersItemsToBeRefunded.forEach((item){
      tempTotalItemsToBeRefunded = tempTotalItemsToBeRefunded + item['${DatabaseHelper.refund_qty}'];
      tempTotalAmountToBeRefunded = tempTotalAmountToBeRefunded + item['${DatabaseHelper.refund_qty}']*item['sp'];

    });
    print("\n\n tempOrdersItemsToBeRefunded = $tempOrdersItemsToBeRefunded :::: tempTotalItemsToBeRefunded = $tempTotalItemsToBeRefunded"
              " :::: tempTotalAmountToBeRefunded = $tempTotalAmountToBeRefunded\n\n");
    print("\n\ntempOrderItemsList end = $tempOrderItemsList :::: readOnlyListOftemsSelectedOrder = $readOnlyListOftemsSelectedOrder\n\n");

    notifyListeners();

  }
//  Code for getting data of updateRefundDetailsOnUi Ends

  //Code for getting data of orderRefundDetails Starts
  orderRefundedDetails (List<Map> refundedOrders) {
    tempTotalRefundQuantity = 0;
    tempRefundTotalAmount = 0;
    tempRefundPaidTotalAmount = 0;
    tempAmountCredited = 0;
    List paymentMethod = [];

    refundedOrders.forEach((item){
      tempTotalRefundQuantity = tempTotalRefundQuantity + int.parse(item[DatabaseHelper.total_quantity_refunded].toString());
      tempRefundTotalAmount = tempRefundTotalAmount + double.parse(item[DatabaseHelper.total_amount_refunded].toString());
    });



    tempAmountCredited = tempRefundTotalAmount - tempRefundPaidTotalAmount;

    notifyListeners();
  }
  //Code for getting data of orderRefundDetails Ends


  //Code for getting data of submitRefundDetailsToDb Starts
  submitRefundDetailsToDb (String refundedAmount, String refundedPaymentMode) async {
    print("\n\n refundedAmount = $refundedAmount");
    tempAmountRefundedToCustomer = double.parse(refundedAmount);
    tempPaymentModeToCustomer = refundedPaymentMode;
    selectedCustomer[DatabaseHelper.credit_balance] = (!selectedCustomer.containsKey('id')) ? 0 : selectedCustomer[DatabaseHelper.credit_balance] -
        tempTotalAmountToBeRefunded + tempAmountRefundedToCustomer;
    selectedCustomer[DatabaseHelper.total_spent] = selectedCustomer[DatabaseHelper.credit_balance] + tempTotalAmountToBeRefunded;
    if (tempSelectedOrder[DatabaseHelper.cart_total] == tempTotalAmountToBeRefunded) {
      selectedCustomer[DatabaseHelper.total_orders] = selectedCustomer[DatabaseHelper.total_orders] - 1;
    }
    selectedCustomer[DatabaseHelper.average_spent] = selectedCustomer[DatabaseHelper.total_spent]/
        (selectedCustomer[DatabaseHelper.total_orders] == 0 ? 1 : selectedCustomer[DatabaseHelper.total_orders]);
    selectedCustomer[DatabaseHelper.total_discount] = selectedCustomer[DatabaseHelper.total_discount] -
        tempSelectedOrder[DatabaseHelper.cart_discount_total];
    selectedCustomer[DatabaseHelper.avg_discount_per_order] = selectedCustomer[DatabaseHelper.total_discount]/
        (selectedCustomer[DatabaseHelper.total_orders] == 0 ? 1 : selectedCustomer[DatabaseHelper.total_orders]);

    selectedCustomer.remove(DatabaseHelper.created_at);

    Map<String, dynamic> row = {};
    selectedCustomer.forEach((key, value){
      row['$key'] = value;
    });

    final id = await dbHelper.update(DatabaseHelper.customerTable, row, DatabaseHelper.id, selectedCustomer[DatabaseHelper.id]);
    print('\n\n${DatabaseHelper.customerTable} update row id: $id :::: selectedCustomer = $selectedCustomer\n\n');

    //Update Order Status
    tempSelectedOrder[DatabaseHelper.status] = ((tempSelectedOrder[DatabaseHelper.cart_total] == tempTotalAmountToBeRefunded)
        ? "refunded" : "Partially Refunded");

    print("\n\ntempSelectedOrder = $tempSelectedOrder\n\n");

    Map<String, dynamic> orderRow = {
      DatabaseHelper.id : tempSelectedOrder['id'],
      DatabaseHelper.customer_id : tempSelectedOrder['customer_id'],
      DatabaseHelper.cart_discount_total : tempSelectedOrder['cart_discount_total'],
      DatabaseHelper.cgst : tempSelectedOrder['cgst'],
      DatabaseHelper.sgst : tempSelectedOrder['sgst'],
      DatabaseHelper.cess : tempSelectedOrder['cess'],
      DatabaseHelper.cart_total : tempSelectedOrder['cart_total'],
      DatabaseHelper.is_receipt_printed : tempSelectedOrder['is_receipt_printed'],
      DatabaseHelper.payment_method : tempSelectedOrder['payment_method'],
      DatabaseHelper.paid_amount_total : tempSelectedOrder['paid_amount_total'],
      DatabaseHelper.status : tempSelectedOrder['${DatabaseHelper.status}'],
      DatabaseHelper.invoice : tempSelectedOrder['invoice'],
      DatabaseHelper.total_items : tempSelectedOrder['total_items'],
      DatabaseHelper.total_quantity : tempSelectedOrder['total_quantity'],
      DatabaseHelper.updated_at : new DateTime.now().toString()

    };

    print("\n\norder row to be inserted = $orderRow\n\n");

    final order_id = await dbHelper.update(DatabaseHelper.ordersTable, orderRow, DatabaseHelper.id, tempSelectedOrder[DatabaseHelper.id]);
    print('\n\n${DatabaseHelper.ordersTable} update row id: $order_id :::: tempSelectedOrder = $tempSelectedOrder\n\n');

    //Insert refundedOrder
    row = {
      DatabaseHelper.order_id : tempSelectedOrder[DatabaseHelper.invoice],
      DatabaseHelper.total_amount_refunded : tempTotalAmountToBeRefunded,
      DatabaseHelper.paid_amount_total : tempAmountRefundedToCustomer,
      DatabaseHelper.payment_method : tempPaymentModeToCustomer,
      DatabaseHelper.updated_at : new DateTime.now().toString(),
      DatabaseHelper.is_receipt_printed : false,
      DatabaseHelper.total_quantity_refunded : tempTotalItemsToBeRefunded,

    };
    final refundreturn_id = await dbHelper.insert(DatabaseHelper.refundTable, row);
    print('\n\n${DatabaseHelper.refundTable} inserted row id: $refundreturn_id :::: refundedOrder = $row\n\n');

    //Insert refundOrderItems
    tempOrdersItemsToBeRefunded.forEach((item) async {

      if (int.parse(item['${DatabaseHelper.refund_qty}'].toString()) > 0) {
        Map<String, dynamic> row = {
          DatabaseHelper.orderItems_id : item['id'],
          DatabaseHelper.refund_qty : item['${DatabaseHelper.refund_qty}'],
          DatabaseHelper.refunded_item_refund_amount : (double.parse(item['sp'].toString())*double.parse(item['${DatabaseHelper.refund_qty}'].toString())).toString(),
          DatabaseHelper.updated_at : new DateTime.now().toString(),
          DatabaseHelper.order_id : item[DatabaseHelper.order_id],
          DatabaseHelper.refund_id : refundreturn_id,

        };

//    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(DatabaseHelper.OrderRefundTable, id, DatabaseHelper.id,"=");
        final return_id = await dbHelper.insert(DatabaseHelper.OrderRefundItemsTable, row);
        print('${DatabaseHelper.OrderRefundItemsTable} inserted row id: $return_id :::: refundedItem = $row\n\n');
      }



    });



    clearAllData();
    notifyListeners();
  }
  //Code for getting data of submitRefundDetailsToDb Ends

  // Code to getCustomerById in refundItemsOfSelectedOrder Starts
  Map getOrderById(int id) {
    //print("Returning product for actions = ${_EditableproductsListForCart.firstWhere((p) => p['id'] == id)} \n\n\n");
    return tempOrdersInDatabaseToDisplay.firstWhere((p) => p['id'] == id);
  }
  // Code to getCustomerById in Database Ends

  // code to clear All Data Starts
  clearAllData () {
    tempTotalRefundQuantity = 0;
    tempRefundTotalAmount = 0;
    tempRefundPaidTotalAmount = 0;
    tempAmountCredited = 0;
    tempTotalAmountToBeRefunded = 0.0;
    tempTotalItemsToBeRefunded = 0;
    tempAmountRefundedToCustomer = 0.0;
    notifyListeners();
  }
// code to clear All Data Ends
}



