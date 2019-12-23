import 'Database_Models.dart';

class ProcessDataReceivedFromFromBackend {
  final List<categories> ProductCategoriesList;
  final List<products> productsList;
  final List<requestStocks> stockRequestsList;
  final List<requestStockItems> stockRequestsProductsList;
  final List<Barcode> BarcodeList;

  ProcessDataReceivedFromFromBackend({this.productsList,
                this.ProductCategoriesList,
                this.stockRequestsList,
                this.stockRequestsProductsList,
                this.BarcodeList});

  factory ProcessDataReceivedFromFromBackend.fromJson(Map<String, dynamic> parsedJson){

    var list1 = parsedJson['categories'] as List;
    var list2 = parsedJson['products'] as List;
    var list3 = parsedJson['requestStocks'] as List;
    var list4 = parsedJson['requestStockItems'] as List;
    var list5 = parsedJson['barcode'] as List;



    List<categories> ProductCategoriesListParsedFromJson = list1.map((i) => categories.fromJson(i)).toList();
    List<products> productsListParsedFromJson = list2.map((i) => products.fromJson(i)).toList();
    List<requestStocks> stockRequestsListParsedFromJson = list3.map((i) => requestStocks.fromJson(i)).toList();
    List<requestStockItems> stockRequestsProductsListParsedFromJson = list4.map((i) => requestStockItems.fromJson(i)).toList();
    List<Barcode> BarcodeListParsedFromJson = list5.map((i) => Barcode.fromJson(i)).toList();


    return ProcessDataReceivedFromFromBackend(
        ProductCategoriesList: ProductCategoriesListParsedFromJson,
        productsList: productsListParsedFromJson,
        stockRequestsList: stockRequestsListParsedFromJson,
        stockRequestsProductsList : stockRequestsProductsListParsedFromJson,
        BarcodeList : BarcodeListParsedFromJson

    );
  }
}



// class for send Data to Backend
class sendDataToBackend {
  var StockRequestList;
  var StockRequestsProductsList;
  var OrdersList;
  var OrderProductsList;
  var CustomerList;
  var CustomerCreditList;
  var OrderRefundList;
  var CustomProductsList;
  var sync_data_list;

  sendDataToBackend(this.StockRequestList, this.StockRequestsProductsList, this.OrdersList, this.OrderProductsList, this.CustomerList, this.CustomerCreditList, this.OrderRefundList, this.CustomProductsList, this.sync_data_list);

  sendDataToBackend.fromJson(Map<String, dynamic> json)
      : StockRequestList = json['requestStocks'],
        StockRequestsProductsList = json['requestStockItems'],
        OrdersList = json['orders'],
        OrderProductsList = json['orderItems'],
        CustomerList = json['customers'],
        CustomerCreditList = json['creditLogs'],
        OrderRefundList = json['refunds'],
        CustomProductsList = json['customProducts'],
        sync_data_list = json['sync_data_list'];

  Map<String, dynamic> toJson() =>
      {
        'requestStocks' : StockRequestList,
        'requestStockItems': StockRequestsProductsList,
        'orders': OrdersList,
        'orderItems': OrderProductsList,
        'customers': CustomerList,
        'creditLogs': CustomerCreditList,
        'refunds': OrderRefundList,
        'customProducts': CustomProductsList,
        'sync_data_list' : sync_data_list,
      };
}



class ProcessDataSentToFromBackend {
  final List<requestStocks> requestStocksList;
  final List<requestStockItems> requestStockItemsList;
  final List<orderItems> orderItemsList;
  final List<Orders> ordersList;
  final List<customProducts> customProductsList;
  final List<refunds> refundsList;
  final List<customerCredit> creditLogsList;
  final List<customer> customerList;

  ProcessDataSentToFromBackend({this.requestStocksList,
    this.requestStockItemsList,
    this.orderItemsList,
    this.customProductsList,
    this.refundsList,
    this.creditLogsList,
    this.customerList,
    this.ordersList
  });

  factory ProcessDataSentToFromBackend.fromJson(Map<String, dynamic> parsedJson){


    var list1 = parsedJson['requestStockItems'] as List;
    var list2 = parsedJson['orders'] as List;
    var list3 = parsedJson['orderItems'] as List;
    var list4 = parsedJson['customProducts'] as List;
    var list5 = parsedJson['refunds'] as List;
    var list6 = parsedJson['creditLogs'] as List;
    var list7 = parsedJson['customers'] as List;
    var list8 = parsedJson['requestStocks'] as List;




    //print(parsedJson);
    //print(list3);
    List<requestStockItems> requestStockItemsListParsedFromJson = list1.map((i) => requestStockItems.fromJson(i)).toList();
    List<Orders> ordersListParsedFromJson = list2.map((i) => Orders.fromJson(i)).toList();
    List<orderItems> orderItemsListParsedFromJson = list3.map((i) => orderItems.fromJson(i)).toList();
    List<customProducts> customProductsListParsedFromJson = list4.map((i) => customProducts.fromJson(i)).toList();
    List<refunds> refundsListParsedFromJson = list5.map((i) => refunds.fromJson(i)).toList();
    List<customerCredit> customerCreditListParsedFromJson = list6.map((i) => customerCredit.fromJson(i)).toList();
    List<customer> customerListParsedFromJson = list7.map((i) => customer.fromJson(i)).toList();
    List<requestStocks> requestStocksListParsedFromJson = list8.map((i) => requestStocks.fromJson(i)).toList();


    return ProcessDataSentToFromBackend(
        requestStocksList:requestStocksListParsedFromJson,
        requestStockItemsList:requestStockItemsListParsedFromJson,
        orderItemsList:orderItemsListParsedFromJson,
        customProductsList:customProductsListParsedFromJson,
        refundsList:refundsListParsedFromJson,
        creditLogsList:customerCreditListParsedFromJson,
        customerList:customerListParsedFromJson,
        ordersList:ordersListParsedFromJson

    );
  }
}
