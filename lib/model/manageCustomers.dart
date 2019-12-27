

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
class manageCustomersModel extends Model {

  List<Map> get customersInDatabaseToDisplay => tempCustomersInDatabaseToDisplay;
  List<Map> tempCustomersInDatabaseToDisplay = [];
  String get prefillField => tempPrefillFieldType;
  String tempPrefillFieldType;
  Map tempselectedCustomer = {};
  Map get selectedCustomer => tempselectedCustomer;
  List<Map> tempOrdersInDatabaseToDisplay = [];
  List<Map> get finalOrdersToDisplay => tempOrdersInDatabaseToDisplay;
  double amountPaidTemp = 0.0;
  double get finalAmountPaid => amountPaidTemp;
  double creditTemp = 0.0;
  double get finalRemainingCredit => creditTemp;


  bool _isNumeric(String str) {
    if(str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }


  //Code to Search customer in Database Starts
  queryCustomerInDatabase (String type /*all, credit*/, String searchString) async {
    print("Entered into queryCustomerInDatabase");
    tempCustomersInDatabaseToDisplay = [];
    List<Map<String, dynamic>> customerList = [];



    if (type == "credit") {
      if (searchString.length < 3) {
        String searchQueryPhoneNumber = "SELECT * FROM ${DatabaseHelper.customerTable} ORDER BY ${DatabaseHelper.name}";
        customerList = await dbHelper.raw_query(searchQueryPhoneNumber);
        tempPrefillFieldType = "";
      }
      else if (searchString.length >= 3) {
        if (_isNumeric(searchString)) {
          print("\n\n string is numeric");
          String searchQueryPhoneNumber = "SELECT * FROM ${DatabaseHelper.customerTable} WHERE ${DatabaseHelper.phone_number} LIKE '%$searchString%' COLLATE utf8_general_ci AND ${DatabaseHelper.credit_balance} != '0' AND ${DatabaseHelper.credit_balance} != '0.0' AND ${DatabaseHelper.credit_balance} != '' ORDER BY ${DatabaseHelper.name}";
          customerList = await dbHelper.raw_query(searchQueryPhoneNumber);
          tempPrefillFieldType = "phone";
        }
        else {
          print("\n\n string is not numeric");
          String searchQueryName = "SELECT * FROM ${DatabaseHelper.customerTable} WHERE ${DatabaseHelper.name} LIKE '%$searchString%' COLLATE utf8_general_ci AND ${DatabaseHelper.credit_balance} != '0' AND ${DatabaseHelper.credit_balance} != '0.0' AND ${DatabaseHelper.credit_balance} != '' ORDER BY ${DatabaseHelper.name}";
          customerList = await dbHelper.raw_query(searchQueryName);
          tempPrefillFieldType = "name";
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
        }
        else {
          print("\n\n string is not numeric");
          String searchQueryName = "SELECT * FROM ${DatabaseHelper.customerTable} WHERE ${DatabaseHelper.name} LIKE '%$searchString%' COLLATE utf8_general_ci ORDER BY ${DatabaseHelper.name}";
          customerList = await dbHelper.raw_query(searchQueryName);
          tempPrefillFieldType = "name";
        }

      }

    }

    print("\n\ncustomerList = $customerList");

    if (customerList.length > 0) {
      customerList.forEach((item) {
        Map tempCustomer = {};
        item.forEach((key, value) {
          tempCustomer[key.toString()] = value.toString();
        });
        tempCustomersInDatabaseToDisplay.add(tempCustomer);
      });
    }

    tempPrefillFieldType = "";
    tempselectedCustomer = {};

    print("tempCustomersInDatabaseToDisplay = $tempCustomersInDatabaseToDisplay :::: tempPrefillFieldType = $tempPrefillFieldType :::: searchString = $searchString\n\n");
    notifyListeners();

  }
  //Code to Search customer in Database Ends

  //Code to selectCustomer in Database Starts
  Future<String> selectCustomer (int id, String source /* "cart" or "customer_section"*/) async {

    tempselectedCustomer = tempCustomersInDatabaseToDisplay.firstWhere((p) => p['id'] == id.toString());
    notifyListeners();
    if (source == "cart") {
      return "add_customer_to_cart";
    }
    else {

      await getOrdersFromDatabase(int.parse(tempselectedCustomer['id'].toString()), "customer_credit_history");

      return "display_customer_details";
    }



  }
  //Code to selectCustomer in Database Ends

  //Code to calculateCredit in Database Starts
  calculateCredit (int id, String amountPaid) {
    amountPaidTemp = double.parse(amountPaid);
    Map customer = finalOrdersToDisplay.firstWhere((p) => p['id'] == id);
    creditTemp = customer["credit_balance"] - amountPaidTemp;
    notifyListeners();
  }
  //Code to calculateCredit in Database Ends

  //Code to updateCustomerDatabase in Database Starts
  updateCustomerDatabase (int id) async {
    Map customer = finalOrdersToDisplay.firstWhere((p) => p['id'] == id);
    customer["credit_balance"] = finalRemainingCredit;
    insertRow(id.toString(), customer, DatabaseHelper.customerTable,"=");

    //Adding item to credit table
    Map<String, dynamic> row = {
      DatabaseHelper.customer_id : id,
      DatabaseHelper.amount : (0-finalAmountPaid),
      DatabaseHelper.order_id : "not_required",
      DatabaseHelper.updated_at : new DateTime.now().toString()

    };
    final return_id = await dbHelper.insert(DatabaseHelper.customerCreditTable, row);


  }
  //Code to updateCustomerDatabase in Database Ends

  //Code to getOrdersFromDatabase in Database Starts
  getOrdersFromDatabase(int id, String type /*"customer_credit_history" or "all_orders" or "all_orders_of_customer"*/) async {
    print("\n\nEnter Into getOrdersFromDatabase");

    tempOrdersInDatabaseToDisplay = [];
    List<Map> retrievedOrders = [];
    if (type == "customer_credit_history") {
      String searchingOrderHistory = "SELECT ${DatabaseHelper.ordersTable}.*, ${DatabaseHelper.customerCreditTable}.* FROM ${DatabaseHelper.customerCreditTable} LEFT OUTER JOIN ${DatabaseHelper.ordersTable} ON ${DatabaseHelper.ordersTable}.${DatabaseHelper.invoice}=${DatabaseHelper.customerCreditTable}.${DatabaseHelper.order_id} WHERE ${DatabaseHelper.customerCreditTable}.${DatabaseHelper.customer_id} = '$id' ORDER BY ${DatabaseHelper.updated_at} DESC";
      retrievedOrders = await dbHelper.raw_query(searchingOrderHistory);
      print("\n\nQuery = $searchingOrderHistory");
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
      print("\n\n orderTemp = $orderTemp");
      tempOrdersInDatabaseToDisplay.add(orderTemp);
    });

    print("\n\ntempOrdersInDatabaseToDisplay = $tempOrdersInDatabaseToDisplay");
    print("\n\nfinalOrdersToDisplay = $finalOrdersToDisplay");

    notifyListeners();

  }
  //Code to getOrdersFromDatabase in Database Ends

  // Code to getCustomerById in Database Starts
  Map getCustomerById(int id) {
    //print("Returning product for actions = ${_EditableproductsListForCart.firstWhere((p) => p['id'] == id)} \n\n\n");
    return tempCustomersInDatabaseToDisplay.firstWhere((p) => p['id'] == id);
  }
  // Code to getCustomerById in Database Ends

  // Code to addNewCustomer in Database Starts
  Future<Map> addNewCustomer (String phoneNumber, String name, String source) async {

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
    notifyListeners();
    return newCustomer[0];
  }
  // Code to addNewCustomer in Database Ends
}




