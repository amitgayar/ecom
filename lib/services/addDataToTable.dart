import '../home.dart';
import '../Databases/Database.dart';
import '../model/Database_Models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';



final dbHelper = DatabaseHelper.instance;

Map<String, int> tempIdMappingForRequestStocks = {};

void insertRow(String id, Map<String, dynamic> row, String dbTable, String operator) async {
  if (id == "null") {
    print(row);
    final return_id = await dbHelper.insert(dbTable, row);
    print('$dbTable inserted row id: $return_id');
    if (dbTable == DatabaseHelper.stockRequestsTable) {
      tempIdMappingForRequestStocks[row['temp_id'].toString()] = return_id;
    }
  }
  else {

    //print(row);
    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(dbTable, id, DatabaseHelper.id, operator);
    //print(listOfItems);
    if (listOfItems.length != 0){
      listOfItems.forEach((items) async {
        //print(items[DatabaseHelper.id]);
        final id = await dbHelper.update(dbTable, row, DatabaseHelper.id, items[DatabaseHelper.id]);
      });
      print('$dbTable update row id: $id');
    }
    else{
      print('\n\n:::: inserted row = $row');
      final return_id = await dbHelper.insert(dbTable, row);
      print('$dbTable inserted row id: $return_id :::: inserted row = $row');

    }
  }
}


// Insert into productCategories of Database
Future<Map<String, dynamic>> insert_productCategories(List<categories> data) async {

  data.forEach((obj) async {
    String name = '${obj.name}';
    String parent_id = '${obj.parent_id}';
    String id = '${obj.id}';



    //print("data to be inserted: ${obj}");

    Map<String, dynamic> row = {
      DatabaseHelper.name : name,
      DatabaseHelper.parent_id : parent_id,
      DatabaseHelper.updated_at : new DateTime.now().toString(),


    };

//    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(DatabaseHelper.productCategoriesTable, id, DatabaseHelper.id,"=");
//    List<Map<String, dynamic>> listOfAllItems = await dbHelper.queryAllRows(DatabaseHelper.productCategoriesTable);
    //print(listOfAllItems);
    insertRow(id, row, DatabaseHelper.productCategoriesTable,"=");


  });

}


// Insert into Order_Products of Database
Future<Map<String, dynamic>> insert_Order_Products(List<orderItems> data) async {

  print("Entered into insert_Order_Products\n\n\n");

  data.forEach((obj) async {

    String id = '${obj.id}';
    String name = '${obj.name}';
    String order_id = '${obj.order_id}';
    String mrp = '${obj.mrp}';
    String sp = '${obj.sp}';
    String cgst = '${obj.cgst}';
    String sgst = '${obj.sgst}';
    String cess = '${obj.cess}';
    String quantity = '${obj.quantity}';
    String product_id = '${obj.product_id}';
    String barcode = '${obj.barcode}';
    String custom_product_id = '${obj.custom_product_id}';



    print("data to be inserted: ${obj.id} :::: id = $id\n\n\n");

    Map<String, dynamic> row = {
      DatabaseHelper.order_id : order_id,
      DatabaseHelper.mrp : mrp,
      DatabaseHelper.name : name,
      DatabaseHelper.sp : sp,
      DatabaseHelper.cgst : cgst,
      DatabaseHelper.sgst : sgst,
      DatabaseHelper.cess : cess,
      DatabaseHelper.quantity : quantity,
      DatabaseHelper.product_id : product_id,
      DatabaseHelper.barcode : barcode,
      DatabaseHelper.custom_product_id : custom_product_id,
      DatabaseHelper.updated_at : new DateTime.now().toString()

    };

    print("print ID to be inserted in insert_Order_Products: ${id} :::: row = $row\n\n\n");

    insertRow(id, row, DatabaseHelper.orderProductsTable,"=");


  });

}



// Insert into Orders of Database
Future<Map<String, dynamic>> insert_Orders(List<Orders> data) async {

  data.forEach((obj) async {

    String customer_id = '${obj.customer_id}';
    String cart_discount_total = '${obj.cart_discount_total}';
    String cgst = '${obj.cgst}';
    String sgst = '${obj.sgst}';
    String cess = '${obj.cess}';
    String cart_total = '${obj.cart_total}';
    String is_receipt_printed = '${obj.is_receipt_printed}';
    String id = '${obj.id}';
    String payment_method = '${obj.payment_method}';
    String paid_amount_total = '${obj.paid_amount_total}';
    String status = '${obj.status}';
    String invoice = '${obj.invoice}';
    String total_quantity = '${obj.total_quantity}';
    String total_items = '${obj.total_items}';


    //print("data to be inserted: ${obj}");

    Map<String, dynamic> row = {
      DatabaseHelper.customer_id : customer_id,
      DatabaseHelper.cart_discount_total : cart_discount_total,
      DatabaseHelper.cgst : cgst,
      DatabaseHelper.sgst : sgst,
      DatabaseHelper.cess : cess,
      DatabaseHelper.cart_total : cart_total,
      DatabaseHelper.is_receipt_printed : is_receipt_printed,
      DatabaseHelper.payment_method : payment_method,
      DatabaseHelper.paid_amount_total : paid_amount_total,
      DatabaseHelper.status : status,
      DatabaseHelper.invoice : invoice,
      DatabaseHelper.total_items : total_items,
      DatabaseHelper.total_quantity : total_quantity,
      DatabaseHelper.updated_at : new DateTime.now().toString()

    };

    insertRow(id, row, DatabaseHelper.ordersTable,"=");


  });

}



// Insert into products table of Database
Future<Map<String, dynamic>> insert_products(List<products> data) async {

  data.forEach((obj) async {

    String id = '${obj.id}';
    //print(id);
    String name = '${obj.name}';
    String mrp = '${obj.mrp}';
    String sp = '${obj.sp}';
    String cgst = '${obj.cgst}';
    String sgst = '${obj.sgst}';
    String cess = '${obj.cess}';
    String brand = '${obj.brand}';
    String category_id = '${obj.category_id}';
    String inventory = '${obj.inventory}';
    String is_barcode_available = '${obj.is_barcode_available}';
    String hsn = '${obj.hsn}';
    String uom = '${obj.uom}';
    String size = '${obj.size}';
    String color = '${obj.color}';
    String dbTable = DatabaseHelper.productsTable;


    ////print("data to be inserted: ${obj}");
    Map<String, dynamic> row = {
      DatabaseHelper.name : name,
      DatabaseHelper.mrp : mrp,
      DatabaseHelper.sp : sp,
      DatabaseHelper.cgst : cgst,
      DatabaseHelper.sgst : sgst,
      DatabaseHelper.cess : cess,
      DatabaseHelper.brand : brand,
      DatabaseHelper.category_id : category_id,
      DatabaseHelper.inventory : inventory,
      DatabaseHelper.is_barcode_available : is_barcode_available,
      DatabaseHelper.hsn : hsn,
      DatabaseHelper.uom : uom,
      DatabaseHelper.size : size,
      DatabaseHelper.color : color,
      DatabaseHelper.updated_at : new DateTime.now().toString()

    };

    insertRow(id, row, dbTable,"=");





  });

}


// Insert into customProductsTable of Database
Future<Map<String, dynamic>> insert_customProducts(List<customProducts> data) async {

  data.forEach((obj) async {
    String id = '${obj.id}';
    String name = '${obj.name}';
    String mrp = '${obj.mrp}';
    String sp = '${obj.sp}';
    String cgst = '${obj.cgst}';
    String sgst = '${obj.sgst}';
    String cess = '${obj.cess}';
    String to_be_saved = '${obj.to_be_saved}';
    String barcode = '${obj.barcode}';
    String category_id = '${obj.category_id}';
    String uom = '${obj.uom}';
    String brand = '${obj.brand}';


    //print("data to be inserted: ${obj}");

    Map<String, dynamic> row = {
      DatabaseHelper.name : name,
      DatabaseHelper.mrp : mrp,
      DatabaseHelper.sp : sp,
      DatabaseHelper.cgst : cgst,
      DatabaseHelper.sgst : sgst,
      DatabaseHelper.cess : cess,
      DatabaseHelper.to_be_saved : to_be_saved,
      DatabaseHelper.barcode : barcode,
      DatabaseHelper.category_id : category_id,
      DatabaseHelper.uom : uom,
      DatabaseHelper.brand : brand,
      DatabaseHelper.updated_at : new DateTime.now().toString()

    };

//    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(DatabaseHelper.customProductsTable, id, DatabaseHelper.id,"=");
    insertRow(id, row, DatabaseHelper.customProductsTable,"=");


  });

}





// Insert into Customer table of Database
Future<Map<String, dynamic>> insert_Customer(List<customer> data) async {

  data.forEach((obj) async {
    String name = '${obj.name}';
    String id = '${obj.id}';
    String phone_number = '${obj.phone_number}';
    String gender = '${obj.gender}';
    String total_orders = '${obj.total_orders}';
    String total_spent = '${obj.total_spent}';
    String average_spent = '${obj.average_spent}';
    String total_discount = '${obj.total_discount}';
    String avg_discount_per_order = '${obj.avg_discount_per_order}';
    String credit_balance = '${obj.credit_balance}';


    //print("data to be inserted: ${obj}");

    Map<String, dynamic> row = {
      DatabaseHelper.name : name,
      DatabaseHelper.phone_number : phone_number,
      DatabaseHelper.gender : gender,
      DatabaseHelper.total_orders : total_orders,
      DatabaseHelper.total_spent : total_spent,
      DatabaseHelper.average_spent : average_spent,
      DatabaseHelper.total_discount : total_discount,
      DatabaseHelper.avg_discount_per_order : avg_discount_per_order,
      DatabaseHelper.credit_balance : credit_balance,
      DatabaseHelper.updated_at : new DateTime.now().toString()

    };

//    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(DatabaseHelper.customerTable, id, DatabaseHelper.id,"=");
    insertRow(id, row, DatabaseHelper.customerTable,"=");


  });

}



// Insert into requestStocksAndPackageDispatch table of Database
Future<Map<String, dynamic>> insert_requestStocksAndPackageDispatch(List<requestStocksAndPackageDispatch> data, String tableName) async {

  data.forEach((obj) async {
    String status = '${obj.status}';
    String delivered_at = '${obj.delivered_at}';
    String accepted_at = '${obj.accepted_at}';
    String total_amount = '${obj.total_amount}';
    String id = '${obj.id}';
    String temp_id = '${obj.temp_id}';
    String total_quantity = '${obj.total_quantity}';
    String total_items = '${obj.total_items}';


    //print("data to be inserted: ${obj}");

    Map<String, dynamic> row = {
      DatabaseHelper.id : id,
      DatabaseHelper.status : status,
      DatabaseHelper.delivered_at : delivered_at,
      DatabaseHelper.accepted_at : accepted_at,
      DatabaseHelper.total_amount : total_amount,
      DatabaseHelper.temp_id : temp_id,
      DatabaseHelper.updated_at : new DateTime.now().toString(),
      DatabaseHelper.total_quantity : total_quantity,
      DatabaseHelper.total_items : total_items

    };

//    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(DatabaseHelper.stockRequestsTable, id, DatabaseHelper.id,"=");
    insertRow(id, row, tableName,"=");


  });

}



// Insert into stockRequestsProducts table of Database
Future<Map<String, dynamic>> insert_stockRequestsProducts(List<requestStockItems> data) async {

  data.forEach((obj) async {
    String stock_request_id = '${obj.stock_request_id}';
    String id = '${obj.id}';
    String product_id = '${obj.product_id}';
    String custom_product_id = '${obj.custom_product_id}';
    String requested_qty = '${obj.requested_qty}';
    String accepted_qty = '${obj.accepted_qty}';
    String note = '${obj.note}';
    String delivered_qty = '${obj.delivered_qty}';
    String product_price = '${obj.product_price}';
    String barcode = '${obj.barcode}';
    String packageId = '${obj.packageId}';

    if (id.toString() == "null") {
      stock_request_id = tempIdMappingForRequestStocks[stock_request_id.toString()].toString();
    }
    //print("data to be inserted: ${obj}");

    Map<String, dynamic> row = {
      DatabaseHelper.id : id,
      DatabaseHelper.stock_request_id : stock_request_id,
      DatabaseHelper.product_id : product_id,
      DatabaseHelper.custom_product_id : custom_product_id,
      DatabaseHelper.requested_qty : requested_qty,
      DatabaseHelper.accepted_qty : accepted_qty,
      DatabaseHelper.note : note,
      DatabaseHelper.delivered_qty : delivered_qty,
      DatabaseHelper.product_price : product_price,
      DatabaseHelper.barcode : barcode,
      DatabaseHelper.updated_at : new DateTime.now().toString(),
      DatabaseHelper.packageId : packageId

    };

//    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(DatabaseHelper.stockRequestsProductsTable, id, DatabaseHelper.id,"=");
    print(row);
    insertRow(id, row, DatabaseHelper.stockRequestsProductsTable,"=");


  });

  print("allrequestitemsinseretd");
  tempIdMappingForRequestStocks = {};

}



// Insert into Barcode table of Database
Future<Map<String, dynamic>> insert_Barcode(List<Barcode> data) async {

  data.forEach((obj) async {


    String id = "${obj.id}";
    String barcode = "${obj.barcode}";
    String product_name = "${obj.product_name}";
    String product_id = "${obj.product_id}";


    ////print("data to be inserted: ${obj}");


      Map<String, dynamic> row = {
        DatabaseHelper.product_name : product_name.toString(),
        DatabaseHelper.barcode : barcode.toString(),
        DatabaseHelper.product_id : product_id,
        DatabaseHelper.updated_at : new DateTime.now().toString()

      };



//    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(DatabaseHelper.barcodeTable, id, DatabaseHelper.id,"=");

    insertRow(id, row, DatabaseHelper.barcodeTable,"=");


  });

}



// Insert into customerCredit table of Database
Future<Map<String, dynamic>> insert_customerCredit(List<customerCredit> data) async {

  data.forEach((obj) async {
    String customer_id = "${obj.customer_id}";
    String amount = "${obj.amount}";
    String order_id = "${obj.order_id}";
    String id = "${obj.id}";
    String payment_method = "${obj.payment_method}";


    //print("data to be inserted: ${obj}");


    Map<String, dynamic> row = {
      DatabaseHelper.customer_id : customer_id,
      DatabaseHelper.amount : amount,
      DatabaseHelper.order_id : order_id,
      DatabaseHelper.updated_at : new DateTime.now().toString(),
      DatabaseHelper.payment_method : payment_method

    };



//    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(DatabaseHelper.customerCreditTable, id, DatabaseHelper.id,"=");
    insertRow(id, row, DatabaseHelper.customerCreditTable,"=");



  });

}



// insert_OrderRefundItems table of Database
Future<Map<String, dynamic>> insert_OrderRefundItems(List<refundItems> data) async {

  data.forEach((obj) async {
    String id = "${obj.id}";
    String orderItems_id = "${obj.orderItems_id}";
    String refund_qty = "${obj.refund_qty}";
    String refunded_item_refund_amount = "${obj.refunded_item_refund_amount}";
    String order_id = "${obj.order_id}";
    String refund_id = "${obj.refund_id}";



    //print("data to be inserted: ${obj}");

    Map<String, dynamic> row = {
      DatabaseHelper.orderItems_id : orderItems_id,
      DatabaseHelper.refund_qty : refund_qty,
      DatabaseHelper.refunded_item_refund_amount : refunded_item_refund_amount,
      DatabaseHelper.updated_at : new DateTime.now().toString(),
      DatabaseHelper.order_id : order_id,
      DatabaseHelper.refund_id : refund_id,

    };

//    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(DatabaseHelper.OrderRefundTable, id, DatabaseHelper.id,"=");
    print("\n\n${DatabaseHelper.OrderRefundItemsTable} = $row\n\n");
    String queryRequest = "SELECT sql FROM sqlite_master "
        "WHERE tbl_name = '${DatabaseHelper.OrderRefundItemsTable}' AND type = 'table'";
//        "WHERE TABLE_NAME = '${DatabaseHelper.OrderRefundItemsTable}' ORDER BY ORDINAL_POSITION";
    List<Map<String, dynamic>> OrderRefundItemsTable = await dbHelper.raw_query(queryRequest);
    print("\n\ncolumns of OrderRefundItemsTable = $OrderRefundItemsTable\n\n");
    insertRow(id, row, DatabaseHelper.OrderRefundItemsTable,"=");


  });

}



// insert_OrderRefund table of Database
Future<Map<String, dynamic>> insert_OrderRefund(List<refunds> data) async {


//  $order_id INTEGER NOT NULL,
//  $total_amount_refunded INTEGER NOT NULL,
//  $paid_amount_total TEXT,
//  $payment_method DECIMAL,
//  $is_receipt_printed TEXT,
//  $total_quantity_refunded INTEGER,
//  $created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
//  $updated_at DATETIME


  data.forEach((obj) async {
    String id = "${obj.id}";
    String order_id = "${obj.order_id}";
    String total_amount_refunded = "${obj.total_amount_refunded}";
    String paid_amount_total = "${obj.paid_amount_total}";
    String payment_method = "${obj.payment_method}";
    String is_receipt_printed = "${obj.is_receipt_printed}";
    String total_quantity_refunded = "${obj.total_quantity_refunded}";



    //print("data to be inserted: ${obj}");

    Map<String, dynamic> row = {
      DatabaseHelper.order_id : order_id,
      DatabaseHelper.total_amount_refunded : total_amount_refunded,
      DatabaseHelper.paid_amount_total : paid_amount_total,
      DatabaseHelper.payment_method : payment_method,
      DatabaseHelper.updated_at : new DateTime.now().toString(),
      DatabaseHelper.is_receipt_printed : is_receipt_printed,
      DatabaseHelper.total_quantity_refunded : total_quantity_refunded,

    };

//    List<Map<String, dynamic>> listOfItems = await dbHelper.queryRow(DatabaseHelper.OrderRefundTable, id, DatabaseHelper.id,"=");
    insertRow(id, row, DatabaseHelper.refundTable,"=");


  });

}



// Insert into syncData table of Database
Future<Map<String, dynamic>> insert_syncData(String apiTpye, bool status, String comment) async {

    String syncType = apiTpye;
    String sync_status = status.toString();
    String sync_comment = comment;


    //print("data to be inserted: ${obj}");

    Map<String, dynamic> row = {
      DatabaseHelper.syncType : syncType,
      DatabaseHelper.sync_status : sync_status,
      DatabaseHelper.sync_comment : sync_comment,
      DatabaseHelper.updated_at : new DateTime.now().toString()

    };

    insertRow("null", row, DatabaseHelper.dataSyncTable,"=");


}