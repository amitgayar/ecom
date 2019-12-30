import 'package:express_store/model/app_state_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:express_store/Databases/Database.dart';
import '../model/app_state_model.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


//NewAppStateModel orderModel = new NewAppStateModel();
//
//
//
//
//class OrderName extends StatefulWidget {
//  @override
//  _OrderName createState() => _OrderName();
//}
//
//class _OrderName extends State<OrderName> {
//
//  @override
//  Widget build(BuildContext context) {
//
//
//
//    orderModel.filterOrders("", "", "", "", false);
//    return Scaffold(
//      body: SafeArea(
//
//        child: ScopedModel<NewAppStateModel>(
//          model: orderModel,
//          child: OrderDescendant(),
//          ),
//        ),
//      );
//  }
//
//}
//
//
//
//
//class OrderDescendant extends StatefulWidget {
//  _OrderDescendant createState() => _OrderDescendant();
//}
//
//class _OrderDescendant extends State<OrderDescendant> {
//
//  @override
//  Widget build(BuildContext context) {
//    print('\n\n order page check     ...... ');
//    return Scaffold(
//        drawer: Drawer(
//          child: ListView(
//
//            padding: EdgeInsets.zero,
//            children: <Widget>[
//              DrawerHeader(
//                child: Container(
////                color: Color(0xff429585),
//child: Column(
//  mainAxisAlignment: MainAxisAlignment.center,
//  children: <Widget>[
//    Expanded(
//      child: Container(
//        child: Image.asset('assets/images/logo.png',
//                             width: 120.0,
//                             height: 90.0,
//                             fit: BoxFit.fitWidth,
//                             color: Colors.black87,
//                           ),
//        ),
//      flex: 2,),
//    Expanded(
//      child: Icon(Icons.account_circle,
//                    size:30,
//                  ),
//      flex: 1,),
//    Expanded(
//      child: Text('Store Name\n(9876567800)',
//                    style: TextStyle(color: Colors.black,
//                                     //                                                  fontSize: 22.0
//                                     ),
//                  ),
//      flex: 1,
//      )
//  ],
//  ),
//  alignment: Alignment.center,
//),
//                decoration: BoxDecoration(
//                  color: Color(0xff429585),
//                  ),
//                ),
//              ListTile(
//                title : Text('HOME'),
//                leading: Icon(Icons.add_shopping_cart),
//                onTap: (
//                    ){
//                  Navigator.pushNamed(context, '/');
//                },
//                ),
//              Divider(color:Color(0xff429585) , thickness: 2, height: 20,),
//              ListTile(
//                title : Text('ORDERS'),
//                leading: Icon(Icons.shopping_basket),
//                onTap: (){
//
////                OrdersName();
//                  print("\n\n ORDERS is clicked in menu bar\n\n");
//                  Navigator.pushNamed(context, '/orders');
//                },
//                ),
//              Divider(color:Color(0xff429585) , thickness: 2, height: 20,),
//              ListTile(
//                title : Text('CUSTOMERS'),
//                leading: Icon(Icons.account_box),
//                onTap: (){
//                  Navigator.pushNamed(context, '/customers');
//                },
//                ),
//              Divider(color:Color(0xff429585) , thickness: 2, height: 20,),
//              ListTile(
//                title : Text('REQUEST STOCKS'),
//                leading: Icon(Icons.near_me),
//                onTap: (){
//                  Navigator.pushNamed(context, '/requestStocks');
//                },
//                ),
//              Divider(color:Color(0xff429585) , thickness: 2, height: 20,),
//              Container(
//                height: 225,
//
//                ),
//              Divider(color:Color(0xff429585) , thickness: 2, height: 10,),
//              Container(
//                alignment: Alignment.topCenter,
//                height: 240,
////              color: Color(0xff429585),
//                child: ListTile(
//                  title : Text('LogOut'),
//
//                  leading: Icon(Icons.power_settings_new),
//                  onTap: (){
////                  getSyncAPI();
//                    Navigator.pushNamed(context, '/login');
//                  },
//                  ),
//                ),
//            ],
//            ),
//          ),
//
//        appBar: AppBar(
//          title: Text('Orders'),
//          backgroundColor: Color(0xff429585),
//          ),
//        body: OrderTiles()
//
//        );
//  }
//}
//



class OrderTiles extends StatefulWidget {

  @override
  _OrderTiles createState() => _OrderTiles ();
}

class _OrderTiles extends State<OrderTiles> {

  final formatter = NumberFormat.simpleCurrency(name: 'INR', decimalDigits: 0);
  List<Map> dummyRowItems = [{
    'name': 'product_name',
    'sp': '90',
    'mrp': '90',
    'qty': '9',
    'total' : '810'
  },
    {
      'name': 'product_name2',
      'sp': '90',
      'mrp': '90',
      'qty': '3',
      'total' : '810'
    }
  ];




  List<Container> _buildCustomerTiles(BuildContext context, List<Map> orderList, NewAppStateModel model ) {

    if (orderList == null || orderList.isEmpty) {
      return const <Container>[];
    }
    return List.generate(orderList.length, (index) {
      String paymentMethod = ((orderList[index]['${DatabaseHelper.payment_method}'].toString() != "null") ? orderList[index]['${DatabaseHelper.payment_method}'].toString() : "");
      return Container(
        child: ListTile (
          title: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right:10),
                  child: Row(
                    children: <Widget>[
                      Expanded (
                        child: Text(
                          (orderList[index]["${DatabaseHelper.invoice}"] != null) ? "Invoice: ${orderList[index]["${DatabaseHelper.invoice}"]}" : "",
                          ),
                        flex: 3,
                        ),
                      Expanded (
                        child: Text(
                          (orderList[index]["${DatabaseHelper.created_at}"] != null) ? "Date: ${orderList[index]["${DatabaseHelper.created_at}"]}" : "",
                          ),
                        flex: 2,
                        )


                    ],
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right:10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          (orderList[index]["${DatabaseHelper.cart_total}"] != null) ? "Total Amount: ${formatter.format(orderList[index]["${DatabaseHelper.cart_total}"])}" : "Total Amount: ${formatter.format(0)}",
                          ),
                        flex: 3,
                        ),
                      Expanded (
                        child: Text(
                          (orderList[index]["total_quantity"].toString() != 'null') ? "${orderList[index]["total_quantity"]} Items" : "Items",
                          ),
                        flex: 2,
                        ),


                    ],
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right:10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          (orderList[index]["${DatabaseHelper.amount}"].toString() != 'null') ? "CREDIT: ${formatter.format(orderList[index]["${DatabaseHelper.amount}"])}" : "CREDIT: ${formatter.format(0)}",
                          ),
                        flex: 3,
                        ),
                      Expanded (
                        child: Text(
                          (orderList[index]["${DatabaseHelper.cart_discount_total}"] != null) ? "Total Discount: ${formatter.format(orderList[index]["${DatabaseHelper.cart_discount_total}"])}" : "",
                          ),
                        flex: 2,
                        ),


                    ],
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right:10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child:Text(
                          (orderList[index]["${DatabaseHelper.paid_amount_total}"] != null) ? "Total Paid: ${formatter.format(orderList[index]["${DatabaseHelper.paid_amount_total}"])}" : "",
                          ),
                        flex: 10,
                        ),
                      Expanded (
                        child: Container(
                          color: Color(0xffe48181),
                          child: Text(orderList[index]['${DatabaseHelper.status}'][0].toUpperCase()+
                                          orderList[index]['${DatabaseHelper.status}'].substring(1),
                                        style: TextStyle(fontSize: 13),
                                      ),
                          ),
                        flex: 4,
                        ),
                      Text(' '),

                      Expanded (
                        child: Container(
                          color: Color(0xff81c784),
                          child: Text(paymentMethod.toUpperCase(),
                                        style: TextStyle(fontSize: 11),
                                      ),
                          ),
                        flex: 3,
                        ),
                      Text(' '),
                      (double.parse(orderList[index]["${DatabaseHelper.cgst}"].toString()) > 0 || double.parse(orderList[index][DatabaseHelper.sgst.toString()].toString()) > 0 ||
                          double.parse(orderList[index][DatabaseHelper.cess.toString()].toString()) > 0) ?
                      Expanded (
                        child: Container(
                          color: Colors.lightBlueAccent,
                          child: Text("GST",
                                        style: TextStyle(fontSize: 11),
                                      ),
                          ),
                        flex: 2,
                        ) : Text("")


                    ],
                    ),
                  ),
                Divider(color: Color(0xff429585),thickness: 1,height: 4,)

              ],
              ),
            ),
          onTap: () async {
            await model.selectOrder(int.parse(orderList[index]['id'].toString()));
            print("Exited Selected Order");
            await model.orderPageState(true, false);
          },
          ),
        );
    }).toList() ;
  }

  final List<String> paymentModes = ["Cash", "PayTM","BhimUPI","Other"];
  String _date = "Not set";
  String _selectedPaymentMode;
  String _selectedOrderStatus;
  String _selectedCreditStatus;


  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<NewAppStateModel> (

        builder: (context, child, model) {


          return Stack(children: <Widget>[
            Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child:Container(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: SizedBox(
                                height: 30,
                                width: 400,
                                child: new TextFormField(
                                  onChanged: (text) async{
                                    model.filterOrders(text,
                                                           model.finalDateForFilter, model.finalPaymentMethodForFilter,
                                                           model.finalStatusForFilter, model.finalCreditForFilter);
                                  },

                                  decoration: new InputDecoration(
                                    prefixIcon: Icon(Icons.search),
                                    hintText: "search customer name or number",
                                    ),


                                  ),
                                //
                                //
                                //
                                ),
                              )
                            ),
                        flex: 7,
                        ),
                      Expanded (
                        child: RaisedButton(
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.calendar_today,
                                       size:16,
                                     ),
                                Text("  ${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}"),

                              ],
                              ),
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                                            theme: DatePickerTheme(
                                                              containerHeight: 210.0,
                                                              ),
                                                            showTitleActions: true,
                                                            minTime: DateTime(2000, 1, 1),
                                                            maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                                    print('confirm $date');
                                    _date = '${date.year}-${date.month}-${date.day}';


                                    print("Date = $_date");
                                    model.filterOrders(model.finalSearchStringForFilter,
                                                           _date, model.finalPaymentMethodForFilter,
                                                           model.finalStatusForFilter, model.finalCreditForFilter);


                                    setState(() {});
                                  }, locale: LocaleType.en);

                            },
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                            ),
                        flex: 4,
                        ),
                    ],
                    ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child:Container(
                          child: Icon(Icons.filter_list,
                                        size:15,
                                      ),
                          ),
                        flex: 1,
                        ),
                      Expanded(
                        child:Container(
                          width:100,
                          child: DropdownButton<String>(
                            items: paymentModes.map((String value) {
                              //print("\n\n value dropdown = $value");
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value, style: TextStyle(fontSize: 13),),
                                );
                            }).toList(),
                            value: _selectedPaymentMode,
                            onChanged: (newValue) {
                              model.filterOrders(model.finalSearchStringForFilter,
                                                     model.finalDateForFilter, newValue,
                                                     model.finalStatusForFilter, model.finalCreditForFilter);
                              setState(() {
                                _selectedPaymentMode = newValue;
                              });
                            },
                            hint: Text('Payment Mode', style: TextStyle(fontSize: 13),),
                            ),
                          ),
                        flex: 2,
                        ),
                      Expanded(
                        child:Container(
                            width:100,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: DropdownButton<String>(
                                items: <String>["Credit", "All"].map((String value) {
                                  //print("\n\n value dropdown = $value");
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value, style: TextStyle(fontSize: 13),),
                                    );
                                }).toList(),
                                value: _selectedCreditStatus,
                                onChanged: (newValue) {
                                  model.filterOrders(model.finalSearchStringForFilter,
                                                         model.finalDateForFilter, model.finalPaymentMethodForFilter,
                                                         model.finalStatusForFilter, (newValue=='credit') ? true : false);
                                  setState(() {
                                    _selectedCreditStatus = newValue;
                                  });
                                },
                                hint: Text('All', style: TextStyle(fontSize: 13),),
                                ),
                              )
                            ),
                        flex: 2,
                        ),
                      Expanded (
                        child: Container(
                            width:100,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: DropdownButton<String>(
                                items: <String>["Completed", "Refunded", "Partially Refunded"].map((String value) {
                                  //print("\n\n value dropdown = $value");
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value, style: TextStyle(fontSize: 13),),
                                    );
                                }).toList(),
                                value: _selectedOrderStatus,
                                onChanged: (newValue) {
                                  model.filterOrders(model.finalSearchStringForFilter,
                                                         model.finalDateForFilter, model.finalPaymentMethodForFilter,
                                                         newValue, model.finalCreditForFilter);
                                  setState(() {
                                    _selectedOrderStatus = newValue;
                                  });
                                },
                                hint: Text('Status', style: TextStyle(fontSize: 13),),
                                ),
                              )
                            ),
                        flex: 2,
                        ),



                    ],
                    ),
                  Divider(color: Colors.black12, thickness: 3, height: 20,),
                  Text('Total Orders: ${model.finalOrdersToDisplay.length.toString()}'),
                  Divider(color: Colors.black12, thickness: 3, height: 20,),

                  Column(
                    children: _buildCustomerTiles(context, model.finalOrdersToDisplay, model),

                    )


                ],
                ),
              ),







            model.secondScreen?
            Align(
                alignment: Alignment.topCenter,
                child: OrderScreen2()
                )
                :
            new Container(),
            model.thirdScreen?
            Align(
                alignment: Alignment.topCenter,
                child: OrderScreen3()
                )
                :
            new Container(),

          ],);
        }
        );



  }
}

class OrderScreen2 extends StatefulWidget {
  _OrderScreen2 createState() => _OrderScreen2();
}



class _OrderScreen2 extends State<OrderScreen2> {

  List<Map> productList = [{
    'name': 'product_name',
    'sp': '90',
    'mrp': '90',
    'qty': '9',
    'total' : '810'
  },
    {
      'name': 'product_name2',
      'sp': '90',
      'mrp': '90',
      'qty': '3',
      'total' : '810'
    }
  ];

  static List<Map> refundedItems = [{
    'name': 'product_name',
    'sp': '90',
    'mrp': '90',
    'qty': '9',
    'total' : '810'
  },
    {
      'name': 'product_name2',
      'sp': '90',
      'mrp': '90',
      'qty': '3',
      'total' : '810'
    }
  ];

  static List<Map> refundedListDetails = [
    {
      'total_refunded_items' : 4,
      'refunded_amount' : 140,
      'payment_mode' : 'cash',
      'amount_credited' : 80,
      'amount_paid' : 60,
      'refunded_date' : '8:12:2019'
    },
    {
      'total_refunded_items' : 4,
      'refunded_amount' : 140,
      'payment_mode' : 'credit',
      'amount_credited' : 80,
      'amount_paid' : 60,
      'refunded_date' : '12:12:2019'
    },
    {
      'total_refunded_items' : 4,
      'refunded_amount' : 140,
      'payment_mode' : 'bhim',
      'amount_credited' : 80,
      'amount_paid' : 60,
      'refunded_date' : '12:12:2019'
    }
  ];

  List<List<Map>> refundedItemsList = [refundedItems,refundedItems, refundedItems];


  List<Container> buildProductList(BuildContext context, List<Map> productList) {
    return (productList.length > 0) ?
    List.generate(productList.length, (index){
      //print("\n\nproductList.length = ${productList.length}\n\n");
      return Container(
        child: OrderRow(product: productList[index]),
        );
    }).toList() :
    List.generate(productList.length, (index){
      //print("\n\nproductList.length = ${productList.length}\n\n");
      return Container(
      );
    }).toList();
  }


  List<Container> buildRefund(BuildContext context, List<List<Map>> refundedItemsList, List<Map> refundedListDetails) {
    return (refundedListDetails.length > 0) ?
    List.generate(refundedListDetails.length, (index){
      double refundAmountCredited = double.parse(refundedListDetails[index]['${DatabaseHelper.total_amount_refunded}'].toString()) -
          double.parse(refundedListDetails[index]['${DatabaseHelper.paid_amount_total}'].toString());
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 5),
              child: Row(
                children: <Widget>[
                  Text('Refunded Date: ${refundedListDetails[index]['${DatabaseHelper.created_at}']}'),
                ],
                ),
              ),
            Container(
                height: 40,
                color:
//          Color(0xffe48181),
                Color(0xff68d8c2),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(

                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Product',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        flex: 3,
                        ),
                      Expanded(
                        child: Text(
                          'MRP',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        flex: 3,
                        ),
                      Expanded(
                        child: Text(
                          'SP',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        flex: 3,
                        ),
                      Expanded(
                        child: Text(
                          'QTY',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        flex: 3,
                        ),
                      Expanded(
                        child: Text(
                          'Total',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w500),
                          ), flex: 3,
                        ),
                    ],
                    ),
                  )

                ),//list_heading
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[


                  Container(
                    child: Column(
                        children: buildProductList(context, refundedItemsList[index])
                        ),
                    ),

                  Row(
                    children: <Widget>[
                      Text('TOTAL REFUNDED ITEMS : '),
                      Spacer(),
                      Text(refundedListDetails[index]['${DatabaseHelper.total_quantity_refunded}'].toString()),
                    ],
                    ),
                  Row(
                    children: <Widget>[
                      Text('REFUNDED AMOUNT : ',),
                      Spacer(),
                      Text(refundedListDetails[index]['${DatabaseHelper.total_amount_refunded}'].toString()),
                    ],
                    ),


                  Row(
                    children: <Widget>[
                      Text('PAYMENT MODE : '),
                      Spacer(),
                      Text(refundedListDetails[index]['${DatabaseHelper.payment_method}'].toString()),
                    ],
                    ),
                  Row(
                    children: <Widget>[
                      Text('AMOUNT PAID: '),
                      Spacer(),
                      Text(refundedListDetails[index]['${DatabaseHelper.paid_amount_total}'].toString()),
                    ],
                    ),
                  Row(
                    children: <Widget>[
                      Text('AMOUNT CREDITED:'),
                      Spacer(),
                      Text(refundAmountCredited.toString()),
                    ],
                    ),




                ],
                ),
              ),//All_products
          ],
          ),
        );
    }).toList() :
    List.generate(1, (index){

      return Container(
      );
    }).toList();
  }





  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<NewAppStateModel> (

        builder: (context, child, model)
        {
          print ("\n\nEntered to line 798");
          double creditAmount = (model.finalSelectedOrder['amount'].toString() == 'null') ? 0.0 : double.parse(model.finalSelectedOrder['amount'].toString());
          double creditBalanceCustomer = (model.selectedCustomer[DatabaseHelper.credit_balance.toString()].toString() == 'null') ?
          0.0 : double.parse(model.selectedCustomer[DatabaseHelper.credit_balance.toString()].toString());
          print ("\n\nEntered to line 802");
          return Container(

            color: Colors.white,
//                width: 400,
//                height:500,
            child: ListView(
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                            icon:Icon(Icons.arrow_back),
                            onPressed: (){
                              model.orderPageState(false, false);
                            },
                            ),

                          Text('Order : ${model.finalSelectedOrder['invoice']}'),
                        ],),

                      Divider(color: Colors.black, thickness: 1, height: 10,),


                      Icon(Icons.account_circle),
                      (model.selectedCustomer.containsKey('id')) ? Text('Customer: ${model.selectedCustomer['name']} (${model.selectedCustomer['phone_number']})') : Text("Customer Not Selected !"),
                      Text('Order Time: ${model.finalSelectedOrder['created_at']}'),
                      Text('Invoice Number: ${model.finalSelectedOrder['invoice']}'),
                    ],
                    ),
                  ),
                Container(
                    height: 40,
                    color:
//          Color(0xffe48181),
                    Color(0xff68d8c2),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(

                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Product',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            flex: 3,
                            ),
                          Expanded(
                            child: Text(
                              'MRP',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            flex: 3,
                            ),
                          Expanded(
                            child: Text(
                              'SP',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            flex: 3,
                            ),
                          Expanded(
                            child: Text(
                              'QTY',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            flex: 3,
                            ),
                          Expanded(
                            child: Text(
                              'Total',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              ), flex: 3,
                            ),
                        ],
                        ),
                      )

                    ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Column(
                            children: buildProductList(context, model.readOnlyListOftemsSelectedOrder)
                            ),
                        ), //  ROWS OF THE PRODUCTS


//
//                      Row(
//                        children: <Widget>[
//                          Text('Discount : ',),
//                          Spacer(),
//                          Text('Rs, 78',),
//                        ],
//                      ),
//                      Row(
//                        children: <Widget>[
//                          Text('GST : '),
//                          Spacer(),
//                          Text('Rs, 78',),
//                        ],
//                      ),


                      Divider(color: Colors.black12, thickness: 1, height: 10,),

                      Row(
                        children: <Widget>[
                          Text('CREDIT: '),
                          Spacer(),
                          Text('${creditAmount.toString()}',),
                        ],
                        ),
                      Row(
                        children: <Widget>[
                          Text('AMOUNT PAID: '),
                          Spacer(),
                          Text('Rs, ${model.finalSelectedOrder['paid_amount_total']}',),
                        ],
                        ),
                      Row(
                        children: <Widget>[
                          Text('PAYMENT MODE: '),
                          Spacer(),
                          Text('${model.finalSelectedOrder['payment_method']}',),
                        ],
                        ),
                      Divider(color: Colors.black12, thickness: 1, height: 10,),



                    ],
                    ),
                  ),

                Container(
                  child: Column(
                      children:
                      buildRefund(context, model.listOfListOfRefundedOrderItems, model.finalRefundedOrders)
                      ),
                  ),//REFUNDED_CONTAINER
                Divider(color: Colors.black12, thickness: 1, height: 10,),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Total Credit of Customer ${model.selectedCustomer['name']} :',
                                 style: TextStyle(color: Colors.red),
                               ),
                          Spacer(),
                          Text('Rs, ${creditBalanceCustomer.toString()}',
                                 style: TextStyle(color: Colors.red),
                               ),
                        ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: RaisedButton(
                              color: Color(0xff64b5f6),
                              child: Text('PRINT RECEIPT '),
                              onPressed: () {
                                model.orderPageState(true, true);
                              },
                              ),
                            ),
                          Expanded(
                            flex: 1,
                            child: Container(width: 60,),
                            ),
                          Expanded(
                            flex: 5,
                            child: RaisedButton(
                              color: Color(0xff81c784),
                              child: Text('PAY CREDIT '),
                              onPressed: () {

//                                model.orderPageState(true, true);
                              },
                              ),
                            )
                        ],),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              color: Color(0xffe48181),
                              child: Text('REFUND '),
                              onPressed: () async {
                                await model.clearRefundItemList();
                                model.orderPageState(true, true);
                              },
                              ),
                            ),


                        ],
                        )

                    ],
                    ),
                  )




              ],
              ),
            );
        });
  }
}


class OrderScreen3 extends StatefulWidget {
  _OrderScreen3 createState() => _OrderScreen3();
}

class _OrderScreen3 extends State<OrderScreen3> {



  List<Container> buildProductList(BuildContext context, List<Map> productList) {
    return List.generate(productList.length, (index){
      return Container(
        child: OrderRowEditable(product: productList[index]),
        );
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NewAppStateModel> (

        builder: (context, child, model)
        {
          double creditBalanceCustomer = (model.selectedCustomer[DatabaseHelper.credit_balance.toString()].toString() == 'null') ?
          0.0 : double.parse(model.selectedCustomer[DatabaseHelper.credit_balance.toString()].toString());
          TextEditingController amountPaidController = TextEditingController(text: '0');

          double subtractableCredit =  creditBalanceCustomer + double.parse(amountPaidController.text) - double.parse(model.tempTotalAmountToBeRefunded.toString());
          double newCreditBalance = creditBalanceCustomer - subtractableCredit;
          return Container(

            color: Colors.white,
//                width: 400,
//                height:500,
            child:ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: (){
                        model.orderPageState(true, false);
                      },
                      ),
                  ],),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: <Widget>[

                        Text('Order : ${model.finalSelectedOrder['${DatabaseHelper.invoice}']}'),
                      ],),
                      Divider(color: Colors.black12, thickness: 1, height: 10,),
                      (model.selectedCustomer.containsKey('id')) ? Row(children: <Widget>[
                        Icon(Icons.account_circle),
                        Text('Customer: ${model.selectedCustomer[DatabaseHelper.name]} (${model.selectedCustomer[DatabaseHelper.phone_number]})'),
                      ],) : SizedBox(),

                      Text('Order Time : ${model.finalSelectedOrder[DatabaseHelper.created_at]}'),
                      Text('Invoice Number : ${model.finalSelectedOrder['${DatabaseHelper.invoice}']}'),
                    ],
                    ),
                  ),
                Container(
                    height: 40,
                    color:
//          Color(0xffe48181),
                    Color(0xff68d8c2),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(

                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Product',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            flex: 3,
                            ),
                          Expanded(
                            child: Text(
                              'MRP',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            flex: 3,
                            ),
                          Expanded(
                            child: Text(
                              'SP',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            flex: 3,
                            ),
                          Expanded(
                            child: Text(
                              'Refund QTY',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            flex: 3,
                            ),
                          Expanded(
                            child: Text(
                              'Total',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500),
                              ),flex: 3,
                            ),
                        ],
                        ),
                      )

                    ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child:  Column(
                    children: <Widget>[
                      Container(
                        child: Column(
                            children: buildProductList(context, model.finalOrderItemsList)
                            ),
                        ),//  ROWS OF THE PRODUCTS


                      Divider(color: Colors.black12, thickness: 1, height: 10,),
                      Row(
                        children: <Widget>[
                          Text('Total Refund Items : ',),
                          Spacer(),
                          Text(' ${model.tempTotalItemsToBeRefunded.toString()}',),
                        ],
                        ),
                      Row(
                        children: <Widget>[
                          Text('Refund Amount : '),
                          Spacer(),
                          Text('Rs, ${model.tempTotalAmountToBeRefunded}',),
                        ],
                        ),



                      Divider(color: Colors.black12, thickness: 1, height: 10,),
                      Text('Refund Payment Mode'),
                      Row(
                        children: <Widget>[
                          Text('Total Credit of Customer ${model.selectedCustomer['name']} :',
                                 style: TextStyle(color: Colors.red),
                               ),
                          Spacer(),
                          Text('Rs, ${model.selectedCustomer['${DatabaseHelper.credit_balance}']}',
                                 style: TextStyle(color: Colors.red),
                               ),
                        ],
                        ),
                      model.orderPagePayment == ''?
                      Container(
                        child: Column(children: <Widget>[

                          Row(
                            children: <Widget>[

                              Text('Add To Credits'),
                              Spacer(),
                              RaisedButton(
                                  child: Text('ADD CREDIT'),
                                  onPressed: () async {
                                    await model.submitRefundDetailsToDb('credit', '0');
                                    await model.orderPageState(true, false);

                                  },
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                                  ),

                            ],
                            ),
                          Container(
                              width: 20,
                              height: 15
                              ),

                          Row(
                            children: <Widget>[
                              RaisedButton(
                                  child: Text('CASH'),
                                  onPressed: () {
                                    model.setOrderPagePayment(mode: 'CASH');
                                  },
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                                  ),
                              Spacer(),
                              RaisedButton(
                                  child: Text('PAYTM'),
                                  onPressed: () {
                                    model.setOrderPagePayment(mode: 'PAYTM');

                                  },
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                                  ),
                              Spacer(),
                              RaisedButton(
                                  child: Text('BHIM UPI'),
                                  onPressed: () {
                                    model.setOrderPagePayment(mode: 'BHIM UPI');

                                  },
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                                  ),
                              Spacer(),
                              RaisedButton(
                                  child: Text('OTHER'),
                                  onPressed: () {
                                    model.setOrderPagePayment(mode: 'OTHER');

                                  },
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                                  ),

                            ],
                            ),
                        ],),
                        )
                          :
                      new Container(),

                      model.orderPagePayment != ''?
                      Container(
                        child: Column(children: <Widget>[
                          Row(children: <Widget>[
                            Text(model.orderPagePayment),
                            Spacer(),
                            SizedBox(
                              width: 60,
                              child: TextField(
                                controller: amountPaidController,


                                textAlign: TextAlign.center,
                                autofocus: false,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  ),
                                onChanged: (text) {
                                  setState(() {
                                    amountPaidController.text = text;
                                  });
                                },
                                ),
                              ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: (){
                                model.setOrderPagePayment(mode:'');
                              },
                              )
                          ],),
                          Row(children: <Widget>[
                            Text('Remaining Amount will be subtractd from Credits:')
                          ],),
                          Row(children: <Widget>[
                            Text('${creditBalanceCustomer.toString()}', style: TextStyle(color: Colors.red),),
                            Text('   -   '),
                            Text('${subtractableCredit.toString()}',style: TextStyle(color: Colors.green),),
                            Spacer(),
                            Text('${newCreditBalance.toString()}', style: TextStyle(color: Colors.red)),
                          ],),
                          Row(children: <Widget>[
                            Container(
                              width: 200,
                              child: RaisedButton(
                                color: Color(0xffe48181),
                                child: Text('REFUND '),
                                onPressed: () async {
                                  await model.submitRefundDetailsToDb(amountPaidController.text, model.orderPagePayment);
                                  model.orderPageState(true, true);
                                },
                                ),
                              )
                          ],)
                        ],),
                        )
                          :new Container(),
                    ],
                    ),
                  )

              ],
              ),
            );
        });
  }
}


class OrderRow extends StatefulWidget {
  OrderRow({@required this.product});
  final Map product;
  _OrderRow createState() => _OrderRow();
}

class _OrderRow extends State<OrderRow> {



  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(name: 'INR',
                                                    decimalDigits: 2,
                                                  //                                                      locale: Localizations.localeOf(context).toString()
                                                  );


    return ScopedModelDescendant<NewAppStateModel> (
        builder: (context, child, model) {

          double itemTotalAmount = double.parse("${widget.product['sp']}")*double.parse("${widget.product['quantity']}");
          return Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: <Widget>[
                      Text(widget.product['name'].toString()),
                    ],
                    ),
                  ),
                Row(

                  children: [
                    Expanded(
                      child: const SizedBox(width: 80.0),
                      flex: 4,
                      ),
                    Expanded(
                      child: Text(widget.product['mrp'].toString()),
                      flex: 3,
                      ),
                    Expanded(
                      child: new Text(widget.product['sp'].toString()),
                      flex: 3,
                      ),
                    Expanded(
                      flex: 3,
                      child: Text(widget.product['${DatabaseHelper.quantity}'].toString()),
                      ),
                    Expanded(
                      flex: 2,
                      child:
//                      Text('${formatter.format('??')}'),
                      Text(itemTotalAmount.toString()),
                      ),

                  ],
                  ),
                Container(
                  height: 10,
                  ),
                Divider(color: Color(0xff429585),thickness: 1)

              ],
              ),
            );
        });
  }
}

class OrderRowEditable extends StatefulWidget {
  OrderRowEditable({@required this.product});
  final Map product;
  _OrderRowEditable createState() => _OrderRowEditable();
}
class _OrderRowEditable extends State<OrderRowEditable> {

  TextEditingController quantityController = TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NewAppStateModel>(
        builder : (context, child, model)
        {
          double totalRefundOFItem = double.parse(widget.product['sp'].toString())*double.parse(quantityController.text.toString());
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right:10),
                  child: Row(
                    children: <Widget>[
                      Text(
                        widget.product['name'].toString(),

                        ),
                      Spacer(),
                      InkWell(
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.clear,
                              size: 13.0,
                              ),
                            height: 25,width:40),


                        onTap: () {

                        },
                        ),


                    ],
                    ),
                  ),
                Row(
                  key: ValueKey(widget.product['id'].toString()),
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [


                    const SizedBox(width: 30.0),
                    Expanded(
                      child: Container(

                      ),
                      flex: 2,
                      ),
                    Expanded(
                      child: TextFormField(

                        autofocus: false,
                        initialValue: widget.product['mrp'].toString(),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                          ),
                        onChanged: (text){

                        },

                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '${widget.product['mrp'].toString()}'
                            ),
                        ),
                      flex: 3,
                      ),
                    Expanded(
                      child: new TextFormField(
                        textAlign: TextAlign.center,
                        autofocus: false,
                        initialValue: widget.product['sp'].toString(),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                          ),
                        onChanged: (text){

                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          ),
                        ),
                      flex: 3,
                      ),
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 60.0,

                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: TextFormField(

                                  controller: quantityController,
//                                  focusNode: quantityFocusNode,
                                  autofocus: false,
                                  autovalidate: true,
                                  validator: (value) {
                                    print("\n\nwidget.product['quantity'] = ${widget.product['quantity']} :::: value = $value :::: widget.product = ${widget.product}"
                                              " :::: quantityController.text = ${quantityController.text}\n\n");

                                    int maxQuantity = model.validateRefundQuantity(int.parse(widget.product['id'].toString()));
                                    print("\n\nmaxQuantity = $maxQuantity\n\n");
                                    if (maxQuantity < int.parse(value)) {
                                      print("\n\nvalidation true\n\n");
                                      return 'Please enter some text';
                                    }
                                    else{
                                      print("\n\nvalidation false\n\n");
                                      return null;
                                    }

                                  },

//                                          initialValue: quantity.toString(),
//                                  controller: quantityController,
                                  keyboardType: TextInputType.number,

                                  onChanged: (text) async {
                                    setState(() {
                                      quantityController.text = text;
                                    });
                                    await model.updateRefundDetailsOnUi(int.parse(text), int.parse(widget.product['id'].toString()));
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '${widget.product['quantity'].toString()}'
                                      ),
                                  ),
                                ),
                              Container(
                                height: 48.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 0.5,
                                            ),
                                          ),
                                        ),
                                      child: InkWell(
                                        child: Icon(
                                          Icons.arrow_drop_up,
                                          size: 22.0,
                                          ),
                                        onTap: () async {
                                          setState(() {
                                            quantityController.text = (int.parse(quantityController.text) + 1).toString();
                                          });
                                          await model.updateRefundDetailsOnUi(int.parse(quantityController.text), int.parse(widget.product['id'].toString()));
                                        },
                                        ),
                                      ),
                                    InkWell(
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        size: 22.0,
                                        ),
                                      onTap: () async {setState(() {
                                        quantityController.text = (int.parse(quantityController.text) - 1).toString();
                                      });
                                      await model.updateRefundDetailsOnUi(int.parse(quantityController.text), int.parse(widget.product['id'].toString()));
                                      },
                                      ),
                                  ],
                                  ),
                                ),
                            ],
                            ),
                          ),
                        ),
                      flex: 4,
                      ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 10),
                        alignment: Alignment.centerRight,
                        child: Column(children: <Widget>[
                          Text(totalRefundOFItem.toString()),
                          SizedBox(
                            height: 17,
                            ),

                        ],),
                        ),
                      flex: 4,
                      ),
                  ],
                  ),
                Divider(color: Color(0xff429585),thickness: 1,height: 4,)

              ],
              ),
            );
        });
  }
}