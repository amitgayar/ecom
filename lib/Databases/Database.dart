import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static final _databaseName = "Users.db";
  static final _databaseVersion = 1;

  //variables for creating productCategories table
  static final productCategoriesTable = 'productCategories';
  static final name = 'name';
  static final parent_id = 'parent_id';

  // variables for creating orderProductsTable
  static final orderProductsTable = 'orderItems';
  static final order_id = 'order_id';
  static final custom_product_id = 'custom_product_id';
  static final mrp = 'mrp';
  static final sp = 'sp';
  static final quantity = 'quantity';
  static final product_id = 'product_id';
  static final barcode = 'barcode';
  //static final cgst = 'cgst';
  //static final sgst = 'sgst';
  //static final cess = 'cess';

  // variables for creating ordersTable
  static final ordersTable = 'orders';
  static final invoice = 'invoice';
  static final mrp_total = 'mrp_total';
  static final cart_discount_total = 'cart_discount_total';
  static final paid_amount_total = 'paid_amount_total';
  static final customer_id = 'customer_id';
  static final payment_method = 'payment_method';
  static final cgst = 'cgst';
  static final sgst = 'sgst';
  static final cess = 'cess';
  static final is_receipt_printed = 'is_receipt_printed';
  //static final status = 'Order_Status';

  // variables for creating productsTable
  static final productsTable = 'products';
  //static final mrp = 'mrp';
  //static final sp = 'sp';
  //static final cgst = 'cgst';
  //static final sgst = 'sgst';
  //static final cess = 'cess';
  static final brand = 'brand';
  static final category_id = 'category_id';
  static final inventory = 'inventory';
  //static final barcode = 'barcode';
  static final hsn = 'hsn';
  static final uom = 'uom';
  static final size = 'size';
  static final color = 'color';
  //static final name = 'name';
  //static final parent_id = 'parent_id';

  // variables for creating customProductsTable
  static final customProductsTable = 'customProducts';
  static final to_be_saved = 'to_be_saved';
  //static final name = 'name';
  //static final mrp = 'MRP';
  //static final sp = 'sp';
  //static final category_id = 'category_id';
  //static final uom = 'uom';

  // variables for creating customerTable
  static final customerTable = 'customer';
  //static final name = 'name';
  static final phone_number = 'phone_number';
  static final gender = 'gender';
  static final total_orders = 'total_orders';
  static final total_spent = 'total_spent';
  static final average_spent = 'average_spent';
  static final total_discount = 'total_discount';
  static final avg_discount_per_order = 'avg_discount_perorder';
  static final credit_balance = 'credit_balance';

  // variables for creating stockRequestsTable
  static final stockRequestsTable = 'requestStocks';
  static final status = 'Order_Status';
  static final delivered_at = 'delivered_at';
  static final accepted_at = 'accepted_at';
  static final total_amount = 'total_amount';


  // variables for creating stockRequestsProductsTable
  static final stockRequestsProductsTable = 'requestStockItems';
  static final stock_request_id = 'stock_request_id';
  //static final custom_product_id = 'custom_product_id';
  //static final product_id = 'product_id';
  static final requested_qty = 'requested_qty';
  static final accepted_qty = 'accepted_qty';
  static final note = 'note';
  static final delivered_qty = 'delivered_qty';
  static final product_price = 'product_price';
  //static final barcode = 'barcode';


  // variables for creating barcodeTable
  static final barcodeTable = 'barcode';
  //static final barcode = 'barcode';
  //static final product_id = 'product_id';
  static final product_name = 'product_name';

  // variables for creating customerCreditTable
  static final customerCreditTable = 'creditLogs';
  //static final order_id = 'order_id';
  static final amount = 'amount';
  //static final customer_id = 'customer_id';


  // variables for creating OrderRefundTable
  static final OrderRefundTable = 'refunds';
  static final orderItems_id = 'orderItems_id';
  static final refund_qty = 'refund_qty';
  static final refund_mode = 'refund_mode';
  static final refund_amt = 'refund_amt';

  // variables for creating DataSynctable
  static final dataSyncTable = 'data_sync';
  static final syncType = 'sync_type';
  //static final updated_at = 'updated_at';



  // Default Columns
  static final id = 'id';
  static final created_at = 'created_at';
  static final updated_at = 'updated_at';



  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    // Create Categories Table
    await db.execute('''
          CREATE TABLE $productCategoriesTable (
            $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $name TEXT NOT NULL,
            $parent_id INTEGER,
            $created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            $updated_at DATETIME
          )
          ''');

    // Create Order_Products Table
    await db.execute('''
          CREATE TABLE $orderProductsTable (
            $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $order_id TEXT,
            $mrp DECIMAL,
            $sp DECIMAL,
            $cgst DECIMAL,
            $sgst DECIMAL,
            $cess DECIMAL,
            $quantity INTEGER,
            $product_id INTEGER,
            $barcode TEXT,
            $custom_product_id INTEGER,
            $created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            $updated_at DATETIME
          )
          ''');

    // Create Orders Table
    await db.execute('''
          CREATE TABLE $ordersTable (
            $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $invoice TEXT NOT NULL,
            $mrp_total DECIMAL,
            $cart_discount_total DECIMAL,
            $paid_amount_total DECIMAL,
            $customer_id INTEGER,
            $payment_method TEXT NOT NULL,
            $cgst DECIMAL,
            $sgst DECIMAL,
            $cess DECIMAL,
            $is_receipt_printed BOOLEAN,
            $created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            $status TEXT,
            $updated_at DATETIME
          )
          ''');

    // Create Products Table
    await db.execute('''
          CREATE TABLE $productsTable (
            $id INTEGER PRIMARY KEY AUTOINCREMENT,
            $name INTEGER,
            $parent_id INTEGER,
            $mrp DECIMAL,
            $sp DECIMAL,
            $cgst DECIMAL,
            $sgst DECIMAL,
            $cess DECIMAL,
            $brand TEXT,
            $category_id INTEGER,
            $inventory INTEGER,
            $barcode TEXT,
            $hsn TEXT,
            $uom TEXT,
            $size TEXT,
            $color TEXT,
            $created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
            $updated_at DATETIME
          )
          ''');

    // Create customProductsTable Table
    await db.execute('''
          CREATE TABLE $customProductsTable (
            $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $name TEXT NOT NULL,
            $mrp DECIMAL,
            $sp DECIMAL,
            $category_id BOOLEAN,
            $uom TEXT,
            $to_be_saved BOOLEAN,
            $barcode TEXT,
            $created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            $updated_at DATETIME
          )
          ''');

    // Create customerTable Table
    await db.execute('''
          CREATE TABLE $customerTable (
            $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $name TEXT,
            $phone_number TEXT,
            $gender TEXT,
            $total_orders INTEGER,
            $total_spent DECIMAL,
            $average_spent DECIMAL,
            $total_discount DECIMAL,
            $avg_discount_per_order DECIMAL,
            $created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            $credit_balance DECIMAL,
            $updated_at DATETIME
          )
          ''');

    // Create stockRequestsTable
    await db.execute('''
          CREATE TABLE $stockRequestsTable (
            $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,  
            $status TEXT,
            $delivered_at DATETIME,
            $accepted_at DATETIME,
            $total_amount INTEGER,
            $created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            $updated_at DATETIME
          )
          ''');

    // Create stockRequestsProductsTable
    await db.execute('''
          CREATE TABLE $stockRequestsProductsTable (
            $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $stock_request_id INTEGER NOT NULL,
            $custom_product_id INTEGER,
            $product_id INTEGER,
            $requested_qty INTEGER,
            $accepted_qty INTEGER,
            $note TEXT,
            $delivered_qty INTEGER,
            $product_price DECIMAL,
            $created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            $barcode TEXT,
            $updated_at DATETIME
          )
          ''');

    // Create barcodeTable
    await db.execute('''
          CREATE TABLE $barcodeTable (
            $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $barcode TEXT NOT NULL,
            $product_name TEXT,
            $product_id INTEGER NOT NULL,
            $created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            $updated_at DATETIME
          )
          ''');

    // Create customerCreditTable
    await db.execute('''
          CREATE TABLE $customerCreditTable (
            $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $customer_id INTEGER NOT NULL,
            $amount DECIMAL NOT NULL,
            $order_id INTEGER NOT NULL,
            $created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            $updated_at DATETIME
          )
          ''');

    // Create OrderRefundTable
    await db.execute('''
          CREATE TABLE $OrderRefundTable (
            $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $orderItems_id INTEGER NOT NULL,
            $refund_qty INTEGER NOT NULL,
            $refund_mode TEXT,
            $refund_amt DECIMAL NOT NULL,
            $created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            $updated_at DATETIME
          )
          ''');


    // Create dataSyncTable
    await db.execute('''
          CREATE TABLE $dataSyncTable (
            $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $syncType TEXT,
            $created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            $updated_at DATETIME
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<List<Map<String, dynamic>>> queryRow(String table, String id, String colName, String operator) async {
    Database db = await instance.database;
    var res = await  db.query(table, where: "$colName $operator ?", whereArgs: [id]);
    return res;
  }



  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<List<Map<String, dynamic>>> querySyncRow(String table, String id, String colName, String operator) async {
    Database db = await instance.database;
    var res = await  db.query(table, where: "$colName $operator ?", whereArgs: [id], orderBy: DatabaseHelper.updated_at);
    return res;
  }





  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(String table, Map<String, dynamic> row, String colName, int id) async {
    Database db = await instance.database;
    String Col_Name = colName;
    return await db.update(table, row, where: '$Col_Name = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String table, int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> raw_query(String query) async {
    final db = await database;
    return await db.rawQuery(query, null);
  }
}