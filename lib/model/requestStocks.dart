
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

class requestStocks extends Model {

  List<Map> tempRequestStocksToDisplay = [];
  List<Map> get finalRequestStocksToDisplay => tempRequestStocksToDisplay;
  List<Map> tempRequestStockItemsToDisplay = [];
  List<Map> get finalRequestStockItemsToDisplay => tempRequestStockItemsToDisplay;

//Code to getStockRequestsFromDatabase in Database Starts
  getStockRequestsFromDatabase(String status /*"delivered" or "all"*/) async {
    print("\n\nEnter Into getStockRequestsFromDatabase");

    tempRequestStocksToDisplay = [];
    List<Map> retrievedStocks = [];
    if (status == "delivered") {
      String query = "SELECT * FROM ${DatabaseHelper.stockRequestsTable} WHERE ${DatabaseHelper.status} = '$status' "
          "ORDER BY ${DatabaseHelper.updated_at} DESC";
      retrievedStocks = await dbHelper.raw_query(query);
      print("\n\nretrievedStocks = $retrievedStocks");
    }
    else {
      String query = "SELECT * FROM ${DatabaseHelper.stockRequestsTable} ORDER BY ${DatabaseHelper.updated_at} DESC";
      retrievedStocks = await dbHelper.raw_query(query);
      print("\n\nretrievedStocks = $retrievedStocks");
    }

    retrievedStocks.forEach((item) {
      Map stockTemp = {};
      item.forEach((key, value) {
        stockTemp[key.toString()] = value;
      });
      print("\n\n orderTemp = $stockTemp");
      tempRequestStocksToDisplay.add(stockTemp);
    });

    print("\n\ntempOrdersInDatabaseToDisplay = $tempRequestStocksToDisplay");
    print("\n\nfinalOrdersToDisplay = $finalRequestStocksToDisplay");

    notifyListeners();

  }
//Code to getStockRequestsFromDatabase in Database Ends

//Code to getStockRequestItemsFromDatabase in Database Starts
  getStockRequestItemsFromDatabase(int id) async {
    print("\n\nEnter Into getStockRequestItemsFromDatabase");

    tempRequestStockItemsToDisplay = [];
    List<Map> retrievedStockItems = [];
    String query = "SELECT * FROM ${DatabaseHelper.stockRequestsProductsTable} WHERE ${DatabaseHelper.stock_request_id} = '$id' "
        "ORDER BY ${DatabaseHelper.updated_at} DESC";
    retrievedStockItems = await dbHelper.raw_query(query);
    print("\n\nretrievedStockItems = $retrievedStockItems");

    retrievedStockItems.forEach((item) {
      Map stockItemTemp = {};
      item.forEach((key, value) {
        stockItemTemp[key.toString()] = value;
      });
      print("\n\n stockItemTemp = $stockItemTemp");
      tempRequestStockItemsToDisplay.add(stockItemTemp);
    });

    print("\n\ntempRequestStockItemsToDisplay = $tempRequestStockItemsToDisplay");
    print("\n\nfinalRequestStockItemsToDisplay = $finalRequestStockItemsToDisplay");

    notifyListeners();

  }
//Code to getStockRequestItemsFromDatabase in Database Ends


}