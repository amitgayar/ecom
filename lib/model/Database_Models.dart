import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';


// class for ProductCategories
class categories {
  String name;
  int parent_id;
  int id;
  var created_at;
  var updated_at;

  categories(this.name, this.id, this.parent_id, this.created_at, this.updated_at);

  categories.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        parent_id = json['parent_id'],
        id = json['id'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];

  Map<String, dynamic> toJson() =>
      {
        'name' : name,
        'parent_id': parent_id,
        'id': id,
        'created_at': created_at,
        'updated_at': updated_at,
      };
}



// class for orderItems
class orderItems {
  int id;
  int order_id;
  double mrp;
  double sp;
  double cgst;
  double sgst;
  double cess;
  int quantity;
  int product_id;
  String barcode;
  int custom_product_id;
  var created_at;
  var updated_at;



  orderItems(this.id, this.order_id, this.mrp, this.sp, this.cgst, this.sgst, this.cess, this.quantity, this.product_id, this.barcode, this.custom_product_id, this.created_at, this.updated_at);

  orderItems.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        order_id = json['order_id'],
        mrp = json['mrp'].toDouble(),
        sp = json['sp'].toDouble(),
        cgst = json['cgst'].toDouble(),
        sgst = json['sgst'].toDouble(),
        cess = json['cess'].toDouble(),
        quantity = json['quantity'],
        product_id = json['product_id'],
        barcode = json['barcode'],
        custom_product_id = json['custom_product_id'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];

  Map<String, dynamic> toJson() =>
      {
        'id' : id,
        'order_id' : order_id,
        'mrp' : mrp,
        'sp' : sp,
        'cgst' : cgst,
        'sgst' : sgst,
        'cess' : cess,
        'quantity' : quantity,
        'product_id' : product_id,
        'barcode' : barcode,
        'custom_product_id' : custom_product_id,
        'created_at' : created_at,
        'updated_at' : updated_at,
      };
}



// class for Orders
class Orders {
  int customer_id;
  double cart_discount_total;
  double cgst;
  double sgst;
  double cess;
  double mrp_total;
  bool is_receipt_printed;
  int id;
  String payment_method;
  double paid_amount_total;
  String status;
  String invoice;
  var created_at;
  var updated_at;

  Orders(this.customer_id, this.cart_discount_total, this.cgst, this.sgst, this.cess, this.mrp_total, this.is_receipt_printed, this.id, this.payment_method, this.paid_amount_total, this.status, this.invoice, this.created_at, this.updated_at);

  Orders.fromJson(Map<String, dynamic> json)
      : customer_id = json['customer_id'],
        cart_discount_total = json['cart_discount_total'].toDouble(),
        cgst = json['cgst'].toDouble(),
        sgst = json['sgst'].toDouble(),
        cess = json['cess'].toDouble(),
        mrp_total = json['mrp_total'].toDouble(),
        is_receipt_printed = json['is_receipt_printed'],
        id = json['id'],
        payment_method = json['payment_method'],
        paid_amount_total = json['paid_amount_total'].toDouble(),
        status = json['status'],
        invoice = json['invoice'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];

  Map<String, dynamic> toJson() =>
      {
        'customer_id' : customer_id,
        'cart_discount_total' : cart_discount_total,
        'cgst' : cgst,
        'sgst' : sgst,
        'cess' : cess,
        'mrp_total' : mrp_total,
        'is_receipt_printed' : is_receipt_printed,
        'id' : id,
        'payment_method' : payment_method,
        'paid_amount_total' : paid_amount_total,
        'status' : status,
        'invoice' : invoice,
        'created_at' : created_at,
        'updated_at' : updated_at,
      };
}


// class for productsTable
class products {
  int id;
  String name;
  double mrp;
  double sp;
  double cgst;
  double sgst;
  double cess;
  String brand;
  int category_id;
  int inventory;
  bool is_barcode_available;
  String hsn;
  String uom;
  String size;
  String color;
  var created_at;
  var updated_at;

  products(this.id, this.name, this.mrp, this.sp, this.cgst, this.sgst, this.cess, this.brand, this.category_id, this.inventory, this.is_barcode_available, this.hsn, this.uom, this.size, this.color, this.created_at, this.updated_at);

  products.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        mrp = json['mrp'].toDouble(),
        sp = json['sp'].toDouble(),
        cgst = json['cgst'].toDouble(),
        sgst = json['sgst'].toDouble(),
        cess = json['cess'].toDouble(),
        brand = json['brand'],
        category_id = json['category_id'],
        inventory = json['inventory'],
        is_barcode_available = json['is_barcode_available'],
        hsn = json['hsn'],
        uom = json['uom'],
        size = json['size'],
        color = json['color'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];

  Map<String, dynamic> toJson() =>
      {
        'id' : id,
        'name' : name,
        'mrp' : mrp,
        'sp' : sp,
        'cgst' : cgst,
        'sgst' : sgst,
        'cess' : cess,
        'brand' : brand,
        'category_id' : category_id,
        'inventory' : inventory,
        'is_barcode_available' : is_barcode_available,
        'hsn' : hsn,
        'uom' : uom,
        'size' : size,
        'color' : color,
        'created_at' : created_at,
        'updated_at' : updated_at,
      };
}



// class for customProductsTable
class customProducts {
  int id;
  String name;
  double mrp;
  double sp;
  double cgst;
  double sgst;
  double cess;
  bool to_be_saved;
  String barcode;
  int category_id;
  String uom;
  var created_at;
  var updated_at;


  customProducts(this.id, this.name, this.mrp, this.sp, this.to_be_saved, this.barcode, this.category_id, this.uom, this.created_at, this.updated_at);

  customProducts.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        mrp = json['mrp'].toDouble(),
        sp = json['sp'].toDouble(),
        cgst = json['cgst'].toDouble(),
        sgst = json['sgst'].toDouble(),
        cess = json['cess'].toDouble(),
        to_be_saved = json['to_be_saved'],
        barcode = json['barcode'],
        category_id = json['category_id'],
        uom = json['uom'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];

  Map<String, dynamic> toJson() =>
      {
        'id' : id,
        'name' : name,
        'mrp' : mrp,
        'sp' : sp,
        'cgst' : cgst,
        'sgst' : sgst,
        'cess' : cess,
        'to_be_saved' : to_be_saved,
        'barcode' : barcode,
        'category_id' : category_id,
        'uom' : uom,
        'created_at' : created_at,
        'updated_at' : updated_at,
      };
}



// class for customerTable
class customer {
  String name;
  int id;
  String phone_number;
  String gender;
  int total_orders;
  double total_spent;
  double average_spent;
  double total_discount;
  double avg_discount_per_order;
  double credit_balance;
  var created_at;
  var updated_at;

  customer(this.name, this.id, this.phone_number, this.gender, this.total_orders, this.total_spent, this.average_spent, this.total_discount, this.avg_discount_per_order, this.credit_balance, this.created_at, this.updated_at);

  customer.fromJson(Map<String, dynamic> json)
      :  name = json['name'],
        id = json['id'],
        phone_number = json['phone_number'],
        gender = json['gender'],
        total_orders = json['total_orders'],
        total_spent = json['total_spent'].toDouble(),
        average_spent = json['average_spent'].toDouble(),
        total_discount = json['total_discount'].toDouble(),
        avg_discount_per_order = json['avg_discount_per_order'].toDouble(),
        credit_balance = json['credit_balance'].toDouble(),
        created_at = json['created_at'],
        updated_at = json['updated_at'];

  Map<String, dynamic> toJson() =>
      {
        'name' : name,
        'id' : id,
        'phone_number' : phone_number,
        'gender' : gender,
        'total_orders' : total_orders,
        'total_spent' : total_spent,
        'average_spent' : average_spent,
        'total_discount' : total_discount,
        'avg_discount_per_order' : avg_discount_per_order,
        'credit_balance' : credit_balance,
        'created_at' : created_at,
        'updated_at' : updated_at,
      };
}


// class for stockRequestsTable
class requestStocks {
  String status;
  var delivered_at;
  var accepted_at;
  double total_amount;
  var created_at;
  var updated_at;
  int id;

  requestStocks(this.status, this.delivered_at, this.accepted_at, this.total_amount, this.created_at, this.updated_at, this.id);

  requestStocks.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        delivered_at = json['delivered_at'],
        accepted_at = json['accepted_at'],
        total_amount = json['total_amount'].toDouble(),
        created_at = json['created_at'],
        updated_at = json['updated_at'],
        id = json['id'];

  Map<String, dynamic> toJson() =>
      {
        'status' : status,
        'delivered_at' : delivered_at,
        'accepted_at' : accepted_at,
        'total_amount' : total_amount,
        'created_at' : created_at,
        'updated_at' : updated_at,
        'id' : id,
      };
}




// class for stockRequestsProductsTable
class requestStockItems {
  int stock_request_id;
  int id;
  int product_id;
  int custom_product_id;
  int requested_qty;
  int accepted_qty;
  String note;
  int delivered_qty;
  double product_price;
  String barcode;
  bool is_custom_product;
  var created_at;
  var updated_at;

  requestStockItems(this.stock_request_id, this.id, this.product_id, this.custom_product_id, this.requested_qty, this.accepted_qty, this.note, this.delivered_qty, this.product_price, this.barcode, this.is_custom_product, this.created_at, this.updated_at);

  requestStockItems.fromJson(Map<String, dynamic> json)
      :stock_request_id = json['stock_request_id'],
        id = json['id'],
        product_id = json['product_id'],
        custom_product_id = json['custom_product_id'],
        requested_qty = json['requested_qty'],
        accepted_qty = json['accepted_qty'],
        note = json['note'],
        delivered_qty = json['delivered_qty'],
        product_price = json['product_price'].toDouble(),
        barcode = json['barcode'],
        is_custom_product = json['is_custom_product'],
        created_at = json['created_at'],
        updated_at = json['updated_at'];

  Map<String, dynamic> toJson() =>
      {
        'stock_request_id' : stock_request_id,
        'id' : id,
        'product_id' : product_id,
        'custom_product_id' : custom_product_id,
        'requested_qty' : requested_qty,
        'accepted_qty' : accepted_qty,
        'note' : note,
        'delivered_qty' : delivered_qty,
        'product_price' : product_price,
        'barcode' : barcode,
        'is_custom_product' : is_custom_product,
        'created_at' : created_at,
        'updated_at' : updated_at,
      };
}

// class for BarcodeTable
class Barcode {
  String barcode;
  String product_name;
  int product_id;
  int id;
  var created_at;
  var updated_at;


  Barcode(this.barcode, this.id, this.product_name, this.product_id, this.created_at, this.updated_at);

  Barcode.fromJson(Map<String, dynamic> json)
      : barcode = json['barcode'],
        product_name = json['product_name'],
        product_id = json['product_id'],
        created_at = json['created_at'],
        id = json['id'],
        updated_at = json['updated_at'];

  Map<String, dynamic> toJson() =>
      {
        'barcode' : barcode,
        'product_name' : product_name,
        'product_id' : product_id,
        'created_at' : created_at,
        'updated_at' : updated_at,
        'id' : id,
      };
}


// class for customerCreditTable
class customerCredit {
  int customer_id;
  double amount;
  int order_id;
  var created_at;
  var updated_at;
  int id;


  customerCredit(this.customer_id, this.id, this.amount, this.order_id, this.created_at, this.updated_at);

  customerCredit.fromJson(Map<String, dynamic> json)
      : order_id = json['order_id'],
        amount = json['amount'].toDouble(),
        customer_id = json['customer_id'],
        created_at = json['created_at'],
        updated_at = json['updated_at'],
        id = json['id'];

  Map<String, dynamic> toJson() =>
      {
        'order_id' : order_id,
        'amount' : amount,
        'customer_id' : customer_id,
        'created_at' : created_at,
        'updated_at' : updated_at,
        'id' : id,
      };
}




// class for OrderRefundTable
class refunds {
  int orderItems_id;
  int refund_qty;
  String refund_mode;
  double refund_amt;
  var created_at;
  var updated_at;
  int id;

  refunds(this.refund_amt, this.orderItems_id, this.refund_qty, this.refund_mode, this.created_at, this.updated_at, this.id);

  refunds.fromJson(Map<String, dynamic> json)
      : orderItems_id = json['orderItems_id'],
        refund_qty = json['refund_qty'],
        refund_mode = json['refund_mode'],
        created_at = json['created_at'],
        updated_at = json['updated_at'],
        id = json['id'],
        refund_amt = json['refund_amt'].toDouble();

  Map<String, dynamic> toJson() =>
      {
        'orderItems_id' : orderItems_id,
        'refund_qty' : refund_qty,
        'refund_mode' : refund_mode,
        'created_at' : created_at,
        'updated_at' : updated_at,
        'refund_amt' : refund_amt,
        'id' : id,
      };
}


// class for dataSyncTable
class dataSync {
  int id;
  String syncType;
  var updated_at;
  bool sync_status;
  String sync_comment;

  dataSync(this.syncType, this.updated_at, this.id, this.sync_status, this.sync_comment);

  dataSync.fromJson(Map<String, dynamic> json)
      : syncType = json['syncType'],
        updated_at = json['updated_at'],
        sync_comment = json['sync_comment'],
        sync_status = json['sync_comment'],
        id = json['id'];

  Map<String, dynamic> toJson() =>
      {
        'syncType' : syncType,
        'updated_at' : updated_at,
        'sync_comment' : sync_comment,
        'sync_status' : sync_status,
        'id' : id,
      };
}