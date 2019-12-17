import 'dart:async' show Future;
import 'dart:async';
import '../Constants/const.dart';
import '../Databases/Database.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../model/ProcessJsonToUpdateDB.dart';
import 'addDataToTable.dart';
import '../Utilities/DBsync.dart';
import '../model/Database_Models.dart';

/*
Product _parseJsonForCrossword(String jsonString) {
  Map JSON = json.decode(jsonString);
  List<Image> words = new List<Image>();
  for (var word in JSON['across']) {
    words.add(new Image(word['number'], word['word']));
  }
  return new Product(JSON['id'], JSON['name'], new Image(words));
}
*/

Future getSyncAPI() async {
  var syncGetResponse = await dbSyncGet(
      syncGetAPI);

  //print(jsonResponse['products']);

  var testJsonCreation = dataSync("ghj", 45678, 456);
  String json_test = jsonEncode(testJsonCreation);

  if(syncGetResponse.statusCode == 200){
    await insert_syncData("GET");
  }
  //Data of get request

  //Replace next line by syncGetResponse.body when API is ready
  String body =  await rootBundle.loadString('assets/getRequestFormat.json');
  //print("print response $body");
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


  //Data for post request

  String body1 =  await rootBundle.loadString('assets/PostRequestFormat.json');
  //print("print response $body1");
  final jsonResponse1 = json.decode(body1);


  ProcessDataSentToFromBackend updateDatabase1 = new ProcessDataSentToFromBackend.fromJson(jsonResponse1);


  //List<Map<String, dynamic>> listOfItems = await dbHelper.queryAllRows(DatabaseHelper.stockRequestsTable);


  // insert data to barcode table
  await insert_stockRequests(updateDatabase1.requestStocksList);

  // insert data to products table
  await insert_stockRequestsProducts(updateDatabase1.requestStockItemsList);

  // insert data to insert_Orders table
  await insert_Orders(updateDatabase1.ordersList);

  // insert data to insert_Order_Products table
  await insert_Order_Products(updateDatabase1.orderItemsList);

  // insert data to stockRequestsProducts table
  await insert_Customer(updateDatabase1.customerList);

  // insert data to productCategories table
  await insert_customerCredit(updateDatabase1.creditLogsList);

  // insert data to stockRequests table
  await insert_OrderRefund(updateDatabase1.refundsList);

  // insert data to stockRequestsProducts table
  await insert_customProducts(updateDatabase1.customProductsList);


}