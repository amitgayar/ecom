import 'dart:async' show Future;
import 'dart:async';
import '../Constants/const.dart' as constants;
import '../Databases/Database.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../model/ProcessJsonToUpdateDB.dart';
import 'addDataToTable.dart';
import '../Utilities/DBsync.dart';
import '../app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import '../Utilities/authentication.dart';
import 'package:http/http.dart' as http;

//
Future getSyncAPI() async {
  print("Enter GET Sync");

  var syncGetResponse = await dbSyncGet(
      constants.syncGetAPIUrl);
  SharedPreferences is_post_sync_successful = await SharedPreferences.getInstance();

  if (syncGetResponse != null) {
    if(syncGetResponse.statusCode == 200){
      await insert_syncData("GET", true, "Data Received Successfylly");

      await is_post_sync_successful.setBool('getSyncStatus', true);

    }
    else if(syncGetResponse.statusCode == 401)
    {
      await insert_syncData("GET", false, "Authentication failed");
      await is_post_sync_successful.setBool('getSyncStatus', false);
      navigatorKey.currentState.pushNamed('/login');
    }
  }

  else {
    await is_post_sync_successful.setBool('getSyncStatus', false);
    await insert_syncData("GET", false, "No Internet Connection");
  }
  //Data of get request
  //print("xcfghvbjnkrdtcfghvbjnkmrtfcghvb m ${syncGetResponse.body}");

  //*****************Replace next line by syncGetResponse.body when API is ready**********************

  String body;

  body = syncGetResponse.body;
  body =  await rootBundle.loadString('assets/getRequestFormat.json');






  print("print response $body");
  final jsonResponse = json.decode(body);


  ProcessDataReceivedFromFromBackend updateDatabase = new ProcessDataReceivedFromFromBackend.fromJson(jsonResponse);
  // insert data to barcode table
  await insert_Barcode(updateDatabase.BarcodeList);

  // insert data to products table
  await insert_products(updateDatabase.productsList);

  // insert data to productCategories table
  await insert_productCategories(updateDatabase.ProductCategoriesList);

  // insert data to stockRequests table
  await insert_stockRequests(updateDatabase.stockRequestsList);

  // insert data to stockRequestsProducts table
  await insert_stockRequestsProducts(updateDatabase.stockRequestsProductsList);

  String body1 =  await rootBundle.loadString('assets/PostRequestFormat.json');
  final jsonResponse1 = json.decode(body1);


  ProcessDataSentToFromBackend updateDatabase1 = new ProcessDataSentToFromBackend.fromJson(jsonResponse1);

  // insert data to barcode table
  await insert_stockRequests(updateDatabase1.requestStocksList);

  // insert data to products table
  await insert_stockRequestsProducts(updateDatabase1.requestStockItemsList);

  // insert data to insert_Orders table
  await insert_Orders(updateDatabase1.ordersList);

  // insert data to insert_Order_Products table
  await insert_Order_Products(updateDatabase1.orderItemsList);

  // insert data to insert_Customer table
  await insert_Customer(updateDatabase1.customerList);

  // insert data to insert_customerCredit table
  await insert_customerCredit(updateDatabase1.creditLogsList);

  // insert data to stockRequests table
  await insert_OrderRefund(updateDatabase1.refundsList);

  // insert data to insert_customProducts table
  await insert_customProducts(updateDatabase1.customProductsList);


}


Future PostSyncAPI() async {

  //Data for post request

  print("Enter POST Sync");
  String queryReuest = "SELECT * FROM ${DatabaseHelper.dataSyncTable} WHERE ${DatabaseHelper.syncType} = 'POST' AND ${DatabaseHelper.sync_comment} = 'Data Posted Successfylly' ORDER BY ${DatabaseHelper.id} DESC LIMIT 1";
  List<Map<String, dynamic>> syncPostAPIRequestList = await dbHelper.raw_query(queryReuest);


  print(queryReuest);
  print(syncPostAPIRequestList);
  var getLastSync;
  if (syncPostAPIRequestList.length > 0) {
    getLastSync = syncPostAPIRequestList[syncPostAPIRequestList.length-1]["updated_at"].toString();
  }
  else{
    getLastSync = "1991-01-01 00:00:00";
  }


  //List<Map<String, dynamic>> listOfItems = await dbHelper.queryAllRows(DatabaseHelper.stockRequestsTable);
  //print(getLastSync);
  //print(DateTime.now());
  List<Map<String, dynamic>> getStockRequestList = await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.stockRequestsTable} WHERE ${DatabaseHelper.updated_at} >= '" + getLastSync + "'");
  List<Map<String, dynamic>> getStockRequestsProductsList = await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.stockRequestsProductsTable} WHERE ${DatabaseHelper.updated_at} >= '" + getLastSync + "'");
  List<Map<String, dynamic>> getOrdersList = await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.ordersTable} WHERE ${DatabaseHelper.updated_at} >= '" + getLastSync + "'");
  List<Map<String, dynamic>> getOrderProductsList = await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.orderProductsTable} WHERE ${DatabaseHelper.updated_at} >= '" + getLastSync + "'");
  List<Map<String, dynamic>> getCustomerList = await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.customerTable} WHERE ${DatabaseHelper.updated_at} >= '" + getLastSync + "'");
  List<Map<String, dynamic>> getCustomerCreditList = await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.customerCreditTable} WHERE ${DatabaseHelper.updated_at} >= '" + getLastSync + "'");
  List<Map<String, dynamic>> getOrderRefundList = await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.OrderRefundTable} WHERE ${DatabaseHelper.updated_at} >= '" + getLastSync + "'");
  List<Map<String, dynamic>> getCustomProductsList = await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.customProductsTable} WHERE ${DatabaseHelper.updated_at} >= '" + getLastSync + "'");
  List<Map<String, dynamic>> getSyncDataList = await dbHelper.raw_query("SELECT * FROM ${DatabaseHelper.dataSyncTable} WHERE ${DatabaseHelper.updated_at} >= '" + getLastSync + "'");
  sendDataToBackend backendDataObject = new sendDataToBackend(getStockRequestList, getStockRequestsProductsList, getOrdersList, getOrderProductsList, getCustomerList, getCustomerCreditList, getOrderRefundList, getCustomProductsList, getSyncDataList);
  String backendData = jsonEncode(backendDataObject);
  print(constants.syncPostAPIUrl);
  var syncPostResponse = await dbSyncPost(constants.syncPostAPIUrl, backendData);
  print("POST Response Received");

  //print("weqwef ${syncPostResponse}");

  SharedPreferences is_post_sync_successful = await SharedPreferences.getInstance();
    if (syncPostResponse != null) {
      if(syncPostResponse.statusCode == 200){
        await insert_syncData("POST", true, "Data Posted Successfylly");

        await is_post_sync_successful.setBool('postSyncStatus', true);


        //var CheckValue = is_post_sync_successful.getBool('boolValue');

        //print("\n\n\nShared Preferences $CheckValue \n\n\n\n");

        await getSyncAPI();
      }
      else if(syncPostResponse.statusCode == 401)
      {
        await insert_syncData("POST", false, "Authentication failed");
        await is_post_sync_successful.setBool('postSyncStatus', false);
        navigatorKey.currentState.pushNamed('/login');
      }
    }
  
  else {
    await insert_syncData("POST", false, "No Internet Connection");
    await is_post_sync_successful.setBool('postSyncStatus', false);
  }


}








Future getFrequencyAPI() async {
  print("Enter GET Frequency API");

  //print(constants.syncGetFrequencyAPIUrl);
  var syncGetFrequencyResponse = await dbSyncGet(
      constants.syncGetFrequencyAPIUrl);

  //print("dqewfes ${syncGetFrequencyResponse.statusCode}");

  SharedPreferences is_get_frequency_sync_successful = await SharedPreferences.getInstance();

  if (syncGetFrequencyResponse != null) {
    if(syncGetFrequencyResponse.statusCode == 200){
      await insert_syncData("GET", true, "Frequency Received Successfylly");
      await is_get_frequency_sync_successful.setBool('cronFrequencyStatus', true);

    }
    else if(syncGetFrequencyResponse.statusCode == 401)
    {
      await insert_syncData("GET", false, "Authentication failed");
      await is_get_frequency_sync_successful.setBool('cronFrequencyStatus', false);
      navigatorKey.currentState.pushNamed('/login');
    }
  }

  else {
    await is_get_frequency_sync_successful.setBool('cronFrequencyStatus', false);
    await insert_syncData("GET", false, "No Internet Connection");
  }
  //Data of get request
  //print("xcfghvbjnkrdtcfghvbjnkmrtfcghvb m ${syncGetResponse.body}");

  //*****************Replace next line by syncGetResponse.body when API is ready**********************

  String body;

  body =  syncGetFrequencyResponse.body;
  body =  await rootBundle.loadString('assets/getFrequency.json');

  //print("print response $body");
  final jsonResponse = json.decode(body);


  SharedPreferences cronFrequency = await SharedPreferences.getInstance();

  if (jsonResponse["frequency"] != "") {
      await cronFrequency.setString('cronFrequency', jsonResponse["frequency"]);

  }
  //print(cronFrequency.getString('cronFrequency'));


  //print(cronFrequency.getString("cronFrequency"));
  final postDataCron = new Cron();
  postDataCron.schedule(new Schedule.parse(cronFrequency.getString("cronFrequency")), () async {
    print('every three minutes');
    await PostSyncAPI();
  });

}




Future getStoreDetailsAPI(processOTP newPost) async {
  print("Enter getStoreDetailsAPI");




  http.Response otpVerificationApiResponse = await submitAuthenticationDetails(
      constants.submitOTP,
      body: newPost.toMap());
  //print(p);


  print("otpVerificationApiResponse body in login OTP file ${otpVerificationApiResponse.body}");

  //print("dqewfes ${syncGetFrequencyResponse.statusCode}");

  SharedPreferences is_get_frequency_sync_successful = await SharedPreferences.getInstance();

  if (otpVerificationApiResponse != null) {
    if(otpVerificationApiResponse.statusCode == 200){
      await insert_syncData("GET", true, "Store Details Received Successfylly");
      await is_get_frequency_sync_successful.setBool('cronStoreDetailsStatus', true);

    }
    else if(otpVerificationApiResponse.statusCode == 401)
    {
      await insert_syncData("GET", false, "Authentication failed");
      await is_get_frequency_sync_successful.setBool('cronStoreDetailsStatus', false);
      navigatorKey.currentState.pushNamed('/login');
    }
  }

  else {
    await is_get_frequency_sync_successful.setBool('cronFrequencyStatus', false);
    await insert_syncData("GET", false, "No Internet Connection");
  }
  //Data of get request
  //print("xcfghvbjnkrdtcfghvbjnkmrtfcghvb m ${syncGetResponse.body}");

  //*****************Replace next line by syncGetResponse.body when API is ready**********************

  String body;

  body =  otpVerificationApiResponse.body;
  body =  await rootBundle.loadString('assets/getStoreDetails.json');

  //print("print response $body");
  final jsonResponse = json.decode(body);


  SharedPreferences cronFrequency = await SharedPreferences.getInstance();

  jsonResponse.forEach((key, value) async {

    print("\n\nStore Details json key: $key : $value\n");
    await cronFrequency.setString(key.toString(), value.toString());
    print("\n\nShared Preferences: $key : ${cronFrequency.getString("authentication_token")}");


  });

  //print(cronFrequency.getString('cronFrequency'));


  return otpVerificationApiResponse;


}


