
import 'dart:ffi';
//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'queryForUI.dart';
import 'package:scoped_model/scoped_model.dart';
import '../Databases/Database.dart';
import '../model/Database_Models.dart';
import 'package:async/async.dart';
import '../services/addDataToTable.dart';


final dbHelper = DatabaseHelper.instance;

class manageOrders extends Model {
  List<Map> tempOrdersInDatabaseToDisplay = [];
  List<Map> get finalOrdersToDisplay => tempOrdersInDatabaseToDisplay;
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

  List<Map> tempRefundedOrderItems = [];
  List<Map> get finaltempRefundedOrderItems => tempRefundedOrderItems;
  List<Map> tempOrderItemsList = [];
  List<Map> get finalOrderItemsList => tempOrderItemsList;
  Map tempSelectedOrder = {};
  Map get finalSelectedOrder => tempSelectedOrder;
  Map selectedCustomer = {};
  Map get finalSelectedCustomer => selectedCustomer;
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


  bool _isNumeric(String str) {
    if(str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  //Code to getOrdersFromDatabase in Database Starts
  getOrdersFromDatabase(int id, String type /*"customer_credit_history" or "all_orders" or "all_orders_of_customer"*/) async {
    print("\n\nEnter Into getOrdersFromDatabase");

    tempOrdersInDatabaseToDisplay = [];
    List<Map> retrievedOrders = [];
    if (type == "customer_credit_history") {
      String searchingOrderHistory = "SELECT ${DatabaseHelper.ordersTable}.*, ${DatabaseHelper.customerCreditTable}.amount FROM ${DatabaseHelper.ordersTable} LEFT JOIN ${DatabaseHelper.customerCreditTable} ON ${DatabaseHelper.ordersTable}.${DatabaseHelper.invoice}=${DatabaseHelper.customerCreditTable}.${DatabaseHelper.order_id} WHERE ${DatabaseHelper.ordersTable}.${DatabaseHelper.customer_id} = '$id' AND ${DatabaseHelper.ordersTable}.${DatabaseHelper.payment_method} = 'credit' ORDER BY ${DatabaseHelper.updated_at} DESC";
      retrievedOrders = await dbHelper.raw_query(searchingOrderHistory);
      //print("\n\nQuery = $searchingOrderHistory");
    }
    else if (type == "all_orders_of_customer"){
      String searchingOrderHistory = "SELECT * FROM ${DatabaseHelper.ordersTable} LEFT JOIN ${DatabaseHelper.customerCreditTable} ON ${DatabaseHelper.ordersTable}.${DatabaseHelper.invoice}=${DatabaseHelper.customerCreditTable}.${DatabaseHelper.order_id} WHERE ${DatabaseHelper.ordersTable}.${DatabaseHelper.customer_id} = '$id' ORDER BY ${DatabaseHelper.updated_at} DESC";
      retrievedOrders = await dbHelper.raw_query(searchingOrderHistory);
    }
    else {
      String searchingOrderHistory = "SELECT * FROM ${DatabaseHelper.ordersTable} LEFT JOIN ${DatabaseHelper.customerCreditTable} ON ${DatabaseHelper.ordersTable}.${DatabaseHelper.invoice}=${DatabaseHelper.customerCreditTable}.${DatabaseHelper.order_id} ORDER BY ${DatabaseHelper.updated_at} DESC";
      retrievedOrders = await dbHelper.raw_query(searchingOrderHistory);
    }

    retrievedOrders.forEach((item) {
      Map orderTemp = {};
      item.forEach((key, value) {
        orderTemp[key.toString()] = value;
      });
      //print("\n\n orderTemp = $orderTemp");
      tempOrdersInDatabaseToDisplay.add(orderTemp);
    });

//    print("\n\ntempOrdersInDatabaseToDisplay = $tempOrdersInDatabaseToDisplay");
//    print("\n\nfinalOrdersToDisplay = $finalOrdersToDisplay");

    tempOrderItemsList = [];
    tempSelectedOrder = {};
    selectedCustomer = {};

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
    print("entered into filterorders : $searchString");
    String finalQuery, query1, query2, query3, query4, query5, query6, query7, query8, query9, query10, query11, query12;

    query1 = "SELECT ${DatabaseHelper.ordersTable}.*, ${DatabaseHelper.customerCreditTable}.${DatabaseHelper.amount}, "
              "COUNT(${DatabaseHelper.orderProductsTable}.${DatabaseHelper.id}) as order_quantity";

    query2 = ", ${DatabaseHelper.customerTable}.${DatabaseHelper.name}, ${DatabaseHelper.customerTable}.${DatabaseHelper.phone_number}";

    query3 = " FROM ${DatabaseHelper.ordersTable} LEFT OUTER JOIN ${DatabaseHelper.orderProductsTable} ON "
        "${DatabaseHelper.ordersTable}.${DatabaseHelper.invoice} = ${DatabaseHelper.orderProductsTable}.${DatabaseHelper.order_id} "
        "LEFT OUTER JOIN ${DatabaseHelper.customerCreditTable} ON ${DatabaseHelper.ordersTable}.${DatabaseHelper.invoice} = "
        "${DatabaseHelper.customerCreditTable}.${DatabaseHelper.order_id} ";

    query4 = "INNER JOIN ${DatabaseHelper.customerTable} ON ${DatabaseHelper.ordersTable}.${DatabaseHelper.customer_id} = "
        "${DatabaseHelper.customerTable}.${DatabaseHelper.id} ";

    query5 = "UPPER(${DatabaseHelper.ordersTable}.${DatabaseHelper.payment_method}) = UPPER('$paymentMethod') ";

    query6 = "UPPER(${DatabaseHelper.ordersTable}.${DatabaseHelper.status}) = UPPER('$status') ";

    query7 = "${DatabaseHelper.ordersTable}.${DatabaseHelper.created_at} LIKE '%$date%' COLLATE utf8_general_ci ";

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
    if (status != "" && finalQuery.substring(finalQuery.length - 6) == "WHERE ") {
      finalQuery = finalQuery+query6;
    }
    else if (status != "" && finalQuery.substring(finalQuery.length - 6) != "WHERE "){
      finalQuery = finalQuery+"AND "+query6;
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
    print("\n\nretrievedOrders = ${retrievedOrders.length}");

    retrievedOrders.forEach((item) {
      Map orderTemp = {};
      item.forEach((key, value) {
        orderTemp[key.toString()] = value;
      });

      int indexOfRefundedItem = tempOrdersInDatabaseToDisplay.indexWhere((p) => p['id'] == item['id']);
      //print("\n\n orderTemp = $orderTemp :::: indexOfRefundedItem = $indexOfRefundedItem");
      if (indexOfRefundedItem < 0) {
        tempOrdersInDatabaseToDisplay.add(orderTemp);
      }

    });

//    print("\n\ntempOrdersInDatabaseToDisplay = $tempOrdersInDatabaseToDisplay");
//    print("\n\nfinalOrdersToDisplay = ${finalOrdersToDisplay.length}");

    notifyListeners();

  }
  //Code to filterOrders in Database Ends

  //Code to selectOrder in Database Starts
  selectOrder (int id) async {
    tempSelectedOrder = tempOrdersInDatabaseToDisplay.firstWhere((p) => p['id'] == id);

    if (_isNumeric(tempSelectedOrder['customer_id'].toString())) {
      await orderCustomer(tempSelectedOrder['customer_id']);
    }
    else {
      selectedCustomer = {};
    }

      await itemsOfSelectedOrder(tempSelectedOrder['invoice']);
    if (tempSelectedOrder['status'] != 'completed') {
      await refundItemsOfSelectedOrder(tempSelectedOrder['invoice']);
      await refundListSelectedOrder(tempSelectedOrder['invoice']);
    }

    notifyListeners();
  }
  //Code to selectOrder in Database Ends

  //Code for getting data of refundListSelectedOrder starts
  refundListSelectedOrder(String invoice) async {
    List<Map> refundListFromDb =  await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.refundTable} WHERE "
        "${DatabaseHelper.order_id} = '$invoice'"
    );


    refundListFromDb.forEach((item) {
      Map tempOrder = {};
      item.forEach((key, value) {
        tempOrder[key.toString()] = value;
      });
      print("\n\ntempOrder = $tempOrder");
      tempRefundedOrders.add(tempOrder);
    });

    orderRefundedDetails(tempRefundedOrders);
    notifyListeners();
  }
  //Code for getting data of orderCustomer Ends

  //Code for getting data of orderCustomer starts
  orderCustomer(int id) async {
  List<Map> customer =  await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.customerTable} WHERE ${DatabaseHelper.id} = '$id'");
  Map tempCustomer = {};
  customer[0].forEach((key, value) {
    tempCustomer[key.toString()] = value;
  });
  selectedCustomer = tempCustomer;
  notifyListeners();
  }
  //Code for getting data of orderCustomer Ends

  //Code for getting data of itemsOfSelectedOrder starts
  itemsOfSelectedOrder(String invoice) async {
    List<Map> itemsSelectedOrder =  await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.orderProductsTable} "
        "WHERE ${DatabaseHelper.order_id} = '$invoice'");

    itemsSelectedOrder.forEach((item) {
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

  //Code for getting data of refundItemsOfSelectedOrder starts
  refundItemsOfSelectedOrder(String invoice) async {
    List<Map> refundItemsFromDb =  await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.OrderRefundItemsTable} WHERE "
        "${DatabaseHelper.order_id} = '$invoice'"
    );


    refundItemsFromDb.forEach((item) {
      Map tempOrder = {};
      item.forEach((key, value) {
        tempOrder[key.toString()] = value;
      });
      print("\n\ntempOrder = $tempOrder");
      tempRefundedOrderItems.add(tempOrder);
    });

    notifyListeners();
  }
  //Code for getting data of orderCustomer Ends

  //Code for getting data of updateRefundDetailsOnUi starts
  updateRefundDetailsOnUi(int refundQuantity, int id) async {
    tempTotalAmountToBeRefunded = 0.0;
    tempTotalItemsToBeRefunded = 0;
    Map refundItemToBeUpdated = tempOrderItemsList.firstWhere((p) => p['id'] == id);
    int indexOfRefundedItem = tempOrdersItemsToBeRefunded.indexWhere((p) => p['id'] == id);
    if (indexOfRefundedItem<0){
      refundItemToBeUpdated['quantity'] = refundQuantity;
      tempOrdersItemsToBeRefunded.add(refundItemToBeUpdated);
    }
    else{
      tempOrdersItemsToBeRefunded[indexOfRefundedItem]['quantity'] = refundQuantity;
    }

    tempOrdersItemsToBeRefunded.forEach((item){
      tempTotalItemsToBeRefunded = tempTotalItemsToBeRefunded + item['quantity'];
      tempTotalAmountToBeRefunded = tempTotalAmountToBeRefunded + item['quantity'];

    });

    notifyListeners();

  }
  //Code for getting data of updateRefundDetailsOnUi Ends

  //Code for getting data of orderRefundDetails Starts
  orderRefundedDetails (List<Map> refundedOrders) {
    tempTotalRefundQuantity = 0;
    tempRefundTotalAmount = 0;
    tempRefundPaidTotalAmount = 0;
    tempAmountCredited = 0;
    List paymentMethod = [];

    refundedOrders.forEach((item){
      tempTotalRefundQuantity = tempTotalRefundQuantity + item[DatabaseHelper.total_quantity_refunded];
      tempRefundTotalAmount = tempRefundTotalAmount + item[DatabaseHelper.total_amount_refunded];
      tempRefundPaidTotalAmount = tempRefundPaidTotalAmount + item[DatabaseHelper.paid_amount_total];
      paymentMethod.add(item[DatabaseHelper.payment_method]);
    });

    paymentMethod = paymentMethod.toSet().toList();

    paymentMethod.forEach((item){
      tempRefundedOrderPaymentMethod = tempRefundedOrderPaymentMethod.toString() + " " + tempRefundedOrderPaymentMethod.toString();
    });

    tempAmountCredited = tempRefundTotalAmount - tempRefundPaidTotalAmount;

    notifyListeners();
  }
  //Code for getting data of orderRefundDetails Ends

  //Code for getting data of setRefundDetails Starts
  setRefundDetails (String refundedAmount, String refundedPaymentMode) {
    tempAmountRefundedToCustomer = double.parse(refundedAmount);
    tempPaymentModeToCustomer = refundedPaymentMode;

    notifyListeners();
  }
  //Code for getting data of setRefundDetails Ends

  //Code for getting data of submitRefundDetailsToDb Starts
  submitRefundDetailsToDb (String refundedPaymentMode) async {
    selectedCustomer[DatabaseHelper.credit_balance] = selectedCustomer[DatabaseHelper.credit_balance] -
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

    final id = await dbHelper.update(DatabaseHelper.customerTable, selectedCustomer, DatabaseHelper.id, selectedCustomer[DatabaseHelper.id]);
    print('${DatabaseHelper.customerTable} update row id: $id');

    //Update Order Status
    tempSelectedOrder[DatabaseHelper.status] = ((tempSelectedOrder[DatabaseHelper.cart_total] == tempTotalAmountToBeRefunded)
        ? "refunded" : "partially_refunded");
    final order_id = await dbHelper.update(DatabaseHelper.ordersTable, tempSelectedOrder, DatabaseHelper.id, tempSelectedOrder[DatabaseHelper.id]);
    print('${DatabaseHelper.ordersTable} update row id: $order_id');

    //Insert refundedOrder
    Map<String, dynamic> row = {
      DatabaseHelper.order_id : tempSelectedOrder[DatabaseHelper.invoice],
      DatabaseHelper.total_amount_refunded : tempTotalAmountToBeRefunded,
      DatabaseHelper.paid_amount_total : tempAmountRefundedToCustomer,
      DatabaseHelper.payment_method : tempPaymentModeToCustomer,
      DatabaseHelper.updated_at : new DateTime.now().toString(),
      DatabaseHelper.is_receipt_printed : false,
      DatabaseHelper.total_quantity_refunded : tempTotalItemsToBeRefunded,

    };
    final refundreturn_id = await dbHelper.insert(DatabaseHelper.refundTable, row);
    print('${DatabaseHelper.refundTable} inserted row id: $refundreturn_id');

    //Insert refundOrderItems
    tempOrdersItemsToBeRefunded.forEach((item) async {

      Map<String, dynamic> row = {
        DatabaseHelper.orderItems_id : item['id'],
        DatabaseHelper.refund_qty : tempTotalItemsToBeRefunded,
        DatabaseHelper.refunded_item_refund_amount : tempTotalAmountToBeRefunded,
        DatabaseHelper.updated_at : new DateTime.now().toString(),
        DatabaseHelper.order_id : item[DatabaseHelper.order_id],
        DatabaseHelper.refund_id : refundreturn_id,

      };

//    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(DatabaseHelper.OrderRefundTable, id, DatabaseHelper.id,"=");
      final return_id = await dbHelper.insert(DatabaseHelper.OrderRefundItemsTable, row);
      print('${DatabaseHelper.OrderRefundItemsTable} inserted row id: $return_id');

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
    tempOrdersInDatabaseToDisplay = [];
    tempRefundedOrders = [];
    tempRefundedOrderPaymentMethod = "";
    tempRefundedOrderItems = [];
    tempOrderItemsList = [];
    tempSelectedOrder = {};
    selectedCustomer = {};
    tempTotalRefundQuantity = 0;
    tempRefundTotalAmount = 0;
    tempRefundPaidTotalAmount = 0;
    tempAmountCredited = 0;
    tempOrdersItemsToBeRefunded = [];
    tempTotalAmountToBeRefunded = 0.0;
    tempTotalItemsToBeRefunded = 0;
    tempAmountRefundedToCustomer = 0.0;
    tempPaymentModeToCustomer = "";
  }
  // code to clear All Data Ends


}