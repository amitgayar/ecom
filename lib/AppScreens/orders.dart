import 'package:express_store/model/app_state_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:express_store/Databases/Database.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';



List<Map<String, dynamic >> productList = [{
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


class OrderDescendant extends StatelessWidget {
  OrderDescendant({@required this.orderModel});
  final NewAppStateModel orderModel;

  @override
  Widget build(BuildContext context) {
    print('\n\n order page check     ...... ');
    return Scaffold(
        drawer: Drawer(
          child: ListView(

            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Container(
//                color: Color(0xff429585),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Image.asset('assets/images/logo.png',
                            width: 120.0,
                            height: 90.0,
                            fit: BoxFit.fitWidth,
                            color: Colors.black87,
                          ),
                        ),
                        flex: 2,),
                      Expanded(
                        child: Icon(Icons.account_circle,
                          size:30,
                        ),
                        flex: 1,),
                      Expanded(
                        child: Text('Store Name\n(9876567800)',
                          style: TextStyle(color: Colors.black,
                            //                                                  fontSize: 22.0
                          ),
                        ),
                        flex: 1,
                      )
                    ],
                  ),
                  alignment: Alignment.center,
                ),
                decoration: BoxDecoration(
                  color: Color(0xff429585),
                ),
              ),
              ListTile(
                title : Text('HOME'),
                leading: Icon(Icons.add_shopping_cart),
                onTap: (
                    ){
                  Navigator.pushNamed(context, '/');
                },
              ),
              Divider(color:Color(0xff429585) , thickness: 2, height: 20,),
              ListTile(
                title : Text('ORDERS'),
                leading: Icon(Icons.shopping_basket),
                onTap: (){

//                OrdersName();
                  print("\n\n ORDERS is clicked in menu bar\n\n");
                  Navigator.pushNamed(context, '/orders');
                },
              ),
              Divider(color:Color(0xff429585) , thickness: 2, height: 20,),
              ListTile(
                title : Text('CUSTOMERS'),
                leading: Icon(Icons.account_box),
                onTap: (){
                  Navigator.pushNamed(context, '/customers');
                },
              ),
              Divider(color:Color(0xff429585) , thickness: 2, height: 20,),
              ListTile(
                title : Text('REQUEST STOCKS'),
                leading: Icon(Icons.near_me),
                onTap: (){
                  Navigator.pushNamed(context, '/requestStocks');
                },
              ),
              Divider(color:Color(0xff429585) , thickness: 2, height: 20,),
              Container(
                height: 225,

              ),
              Divider(color:Color(0xff429585) , thickness: 2, height: 10,),
              Container(
                alignment: Alignment.topCenter,
                height: 240,
//              color: Color(0xff429585),
                child: ListTile(
                  title : Text('LogOut'),

                  leading: Icon(Icons.power_settings_new),
                  onTap: (){
//                  getSyncAPI();
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ),
            ],
          ),
        ),

        appBar: AppBar(
          title: Text('Orders'),
          backgroundColor: Color(0xff429585),
        ),
        body: OrderTiles(orderModel: orderModel)

    );
  }
}












class OrderTiles extends StatefulWidget {
  OrderTiles({@required this.orderModel});
  final NewAppStateModel orderModel;

  @override
  _OrderTiles createState() => _OrderTiles ();
}

class _OrderTiles extends State<OrderTiles> {

  final formatter = NumberFormat.simpleCurrency(name: 'INR', decimalDigits: 0);
  List<Map<String, dynamic >> dummyRowItems = [{
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




  List<Container> _buildCustomerTiles(BuildContext context, List<Map> orderList ) {

    if (orderList == null || orderList.isEmpty) {
      return const <Container>[];
    }
    return List.generate(orderList.length, (index) {
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
                          (orderList[index]["order_quantity"] != null) ? "${orderList[index]["order_quantity"]} Items" : "",
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
                          (orderList[index]["${DatabaseHelper.amount}"] != null) ? "CREDIT: ${formatter.format(orderList[index]["${DatabaseHelper.amount}"])}" : "CREDIT: ${formatter.format(0)}",
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
                        flex: 2,
                      ),
                      Expanded (
                        child: RaisedButton(
                            child: Text(orderList[index]['${DatabaseHelper.status}']),
                            onPressed: () {
                            },
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                        ),
                        flex: 2,
                      ),
                      (orderList[index]['${DatabaseHelper.payment_method}'] != "") ? Expanded (
                        child: RaisedButton(
                            child: Text(orderList[index]['${DatabaseHelper.payment_method}']),
                            onPressed: () {
                            },
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                        ),
                        flex: 1,
                      ) : Text(""),
                      (double.parse(orderList[index]["${DatabaseHelper.cgst}"].toString()) > 0 || double.parse(orderList[index][DatabaseHelper.sgst.toString()].toString()) > 0 ||
                          double.parse(orderList[index][DatabaseHelper.cess.toString()].toString()) > 0) ? Expanded (
                        child: RaisedButton(
                            child: Text("GST"),
                            onPressed: () {
                            },
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                        ),
                        flex: 1,
                      ) : Text("")


                    ],
                  ),
                ),
                Divider(color: Color(0xff429585),thickness: 1,height: 4,)

              ],
            ),
          ),
          onTap: () async {

//            model.setSelectCustomerForCartFlag(false);
          },
        ),
      );
    }).toList() ;
  }


  @override
  Widget build(BuildContext context) {


    String _date = "Not set";
    String _selectedPaymentMode;
    String _selectedOrderStatus;
    String _selectedCreditStatus;


    return ScopedModelDescendant<NewAppStateModel> (

        builder: (context, child, model) {


          return Stack(children: <Widget>[
            Container(
//                  height:440,
//            width: 5000,
                  color: Colors.white,
                      child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
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
                                              widget.orderModel.filterOrders(text,
                                                                                 widget.orderModel.finalDateForFilter, widget.orderModel.finalPaymentMethodForFilter,
                                                                                 widget.orderModel.finalStatusForFilter, widget.orderModel.finalCreditForFilter);
                                            },

                                            decoration: new InputDecoration(
                                              prefixIcon: Icon(Icons.search),
                                              hintText: "search customer name or number",
                                              fillColor: Colors.green,
                                              border: new OutlineInputBorder(
                                                borderRadius: new BorderRadius.circular(25.0),
                                                borderSide: new BorderSide(
                                                    color: Colors.red
                                                    ),
                                                ),
                                              ),
                                            validator: (val) {
                                              if(val.length==0) {
                                                return "Email cannot be empty";
                                              }else{
                                                return null;
                                              }
                                            },
                                            //                                    keyboardType: TextInputType.emailAddress,
                                            //                                    style: new TextStyle(
                                            //                                      fontFamily: "Poppins",
                                            //                                      ),
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
                  //                                      widget.orderModel.filterOrders(widget.orderModel.finalSearchStringForFilter,
                  //                                          _date, widget.orderModel.finalPaymentMethodForFilter,
                  //                                          widget.orderModel.finalStatusForFilter, widget.orderModel.finalCreditForFilter);


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
                                                  size:25,
                                                ),
                                    ),
                                  flex: 1,
                                  ),
                                Expanded(
                                  child:Container(
                                    width: 150,
                                    child: DropdownButton<String>(
                                      items: <String>["name", "value"].map((String value) {
                                        //print("\n\n value dropdown = $value");
                                        return new DropdownMenuItem<String>(
                                          value: value,
                                          child: new Text(value),
                                          );
                                      }).toList(),
                                      value: _selectedPaymentMode,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedPaymentMode = newValue;
                                        });
                                      },
                                      hint: Text('Payment Mode'),
                                      ),
                                    ),
                                  flex: 3,
                                  ),
                                Expanded(
                                  child:Container(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: DropdownButton<String>(
                                          items: <String>["Credit", "All"].map((String value) {
                                            //print("\n\n value dropdown = $value");
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(value),
                                              );
                                          }).toList(),
                                          value: _selectedCreditStatus,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _selectedCreditStatus = newValue;
                                            });
                                          },
                                          hint: Text('All'),
                                          ),
                                        )
                                      ),
                                  flex: 2,
                                  ),
                                Expanded (
                                  child: Container(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: DropdownButton<String>(
                                          items: <String>["Completed", "Refunded", "Partially refunded"].map((String value) {
                                            //print("\n\n value dropdown = $value");
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(value),
                                              );
                                          }).toList(),
                                          value: _selectedOrderStatus,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _selectedOrderStatus = newValue;
                                            });
                                          },
                                          hint: Text('Status'),
                                          ),
                                        )
                                      ),
                                  flex: 2,
                                  ),



                              ],
                              ),
                            Divider(color: Colors.black12, thickness: 3, height: 20,),
                            Text('Total Orders: ${widget.orderModel.finalOrdersToDisplay.length.toString()}'),
                            Divider(color: Colors.black12, thickness: 3, height: 20,),

                            Column(
            children: _buildCustomerTiles(context, widget.orderModel.finalOrdersToDisplay),

            )


        ],
        ),
                              )
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





class OrderScreen2 extends StatelessWidget {

  List<Map<String, dynamic >> productList = [{
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

  static List<Map<String, dynamic >> refundedItems = [{
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

  static List<Map<String, dynamic >> refundedListDetails = [
    {
      'total_refunded_items' : 4,
      'refunded_amount' : 140,
      'payment_mode' : 'cash',
      'amount_credited' : 80,
      'amount_paid' : 60,
      'refunded_date' : '2:12:2019'
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

  List<List<Map<String, dynamic >>> refundedList = [refundedItems,refundedItems, refundedItems];


  List<Container> buildProductList(BuildContext context, List<Map<String, dynamic >> productList) {
    return List.generate(productList.length, (index){
      return Container(
        child: OrderRow(product: productList[index]),
        );
    }).toList();
  }


  List<Container> buildRefund(BuildContext context, List<List<Map<String, dynamic >>> refundedList, List<Map<String, dynamic >> refundedListDetails) {
    return List.generate(refundedList.length, (index){
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 5),
              child: Row(
                children: <Widget>[
                  Text(refundedListDetails[index]['refunded_date']),
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
                        children: buildProductList(context, refundedList[index])
                        ),
                    ),

                  Row(
                    children: <Widget>[
                      Text('TOTAL REFUNDED ITEMS : '),
                      Spacer(),
                      Text(refundedListDetails[index]['total_refunded_items'].toString()),
                    ],
                    ),
                  Row(
                    children: <Widget>[
                      Text('REFUNDED AMOUNT : ',),
                      Spacer(),
                      Text(refundedListDetails[index]['refunded_amount'].toString()),
                    ],
                    ),


                  Row(
                    children: <Widget>[
                      Text('PAYMENT MODE : '),
                      Spacer(),
                      Text(refundedListDetails[index]['payment_mode'].toString()),
                    ],
                    ),
                  Row(
                    children: <Widget>[
                      Text('AMOUNT PAID: '),
                      Spacer(),
                      Text(refundedListDetails[index]['amount_paid'].toString()),
                    ],
                    ),
                  Row(
                    children: <Widget>[
                      Text('AMOUNT CREDITED:'),
                      Spacer(),
                      Text(refundedListDetails[index]['amount_credited'].toString()),
                    ],
                    ),




                ],
                ),
              ),//All_products
          ],
          ),
        );
    }).toList();
  }





  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<NewAppStateModel> (

        builder: (context, child, model)
    {
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
                      Icon(Icons.arrow_back),

                      Text('Order : <Number>'),
                    ],),

                  Divider(color: Colors.black, thickness: 1, height: 10,),


                  Icon(Icons.account_circle),
                  Text('Customer ABC : <Mobile>'),
                  Text('Order Time : <Date>'),
                  Text('Invoice Number : <Number>'),
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
                        children: buildProductList(context, productList)
                        ),
                    ), //  ROWS OF THE PRODUCTS



                  Row(
                    children: <Widget>[
                      Text('Discount : ',),
                      Spacer(),
                      Text('Rs, 78',),
                    ],
                    ),
                  Row(
                    children: <Widget>[
                      Text('GST : '),
                      Spacer(),
                      Text('Rs, 78',),
                    ],
                    ),


                  Divider(color: Colors.black12, thickness: 1, height: 10,),

                  Row(
                    children: <Widget>[
                      Text('CREDIT : '),
                      Spacer(),
                      Text('Rs, 78',),
                    ],
                    ),
                  Row(
                    children: <Widget>[
                      Text('AMOUNT PAID: '),
                      Spacer(),
                      Text('Rs, 78',),
                    ],
                    ),
                  Row(
                    children: <Widget>[
                      Text('PAYMENT MODE: '),
                      Spacer(),
                      Text('CREDIT',),
                    ],
                    ),
                  Divider(color: Colors.black12, thickness: 1, height: 10,),



                ],
                ),
              ),

            Container(
              child: Column(
                children:
                  buildRefund(context, refundedList, refundedListDetails)
              ),
            ),//REFUNDED_CONTAINER
            Divider(color: Colors.black12, thickness: 1, height: 10,),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('Total Credit of Customer ABC :',
                             style: TextStyle(color: Colors.red),
                           ),
                      Spacer(),
                      Text('Rs, 78',
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

                            model.orderPageState(true, true);
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
                          onPressed: () {
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



//class OrderScreen3 extends StatefulWidget {
//  _OrderScreen3 createState() => _OrderScreen3();
//}
//
//class _OrderScreen3 extends State<OrderScreen3> {
class OrderScreen3 extends StatelessWidget {
  final List<Map<String, dynamic >> productList = [{
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


  List<Container> v(BuildContext context, List<Map<String, dynamic >> productList) {
    return List.generate(productList.length, (index){
      return Container(
        child: OrderRow(product: productList[index]),
        );
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NewAppStateModel> (

        builder: (context, child, model)
    {
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

                    Text('Order : <Number> .... Screen3'),
                  ],),
                  Divider(color: Colors.black12, thickness: 1, height: 10,),
                  Row(children: <Widget>[
                    Icon(Icons.account_circle),
                    Text('Customer ABC : <Mobile>'),
                  ],),

                  Text('Order Time : <Date>'),
                  Text('Invoice Number : <Number>'),
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
                        children: v(context, productList)
                        ),
                    ),//  ROWS OF THE PRODUCTS


                  Divider(color: Colors.black12, thickness: 1, height: 10,),
                  Row(
                    children: <Widget>[
                      Text('Total Refund Items : ',),
                      Spacer(),
                      Text(' 78',),
                    ],
                    ),
                  Row(
                    children: <Widget>[
                      Text('Refund Amount : '),
                      Spacer(),
                      Text('Rs, 78',),
                    ],
                    ),



                  Divider(color: Colors.black12, thickness: 1, height: 10,),
                  Text('Refund Payment Mode'),
                  Row(
                    children: <Widget>[
                      Text('Total Credit of Customer ABC :',
                             style: TextStyle(color: Colors.red),
                           ),
                      Spacer(),
                      Text('Rs, 78',
                             style: TextStyle(color: Colors.red),
                           ),
                    ],
                    ),
                  Row(
                    children: <Widget>[

                      Text('Add To Credits'),
                      Spacer(),
                      RaisedButton(
                          child: Text('ADD CREDIT'),
                          onPressed: () {

                            model.orderPageState(true, false);
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
                 model.orderPagePayment != ''?
                 Container(
                   child: Column(children: <Widget>[
                     Row(children: <Widget>[
                       Text(model.orderPagePayment),
                       Spacer(),
                       SizedBox(
                         width: 60,
                         child: TextField(),
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
                       Text('1560', style: TextStyle(color: Colors.red),),
                       Text('   -   '),
                       Text('60',style: TextStyle(color: Colors.green),),
                       Spacer(),
                       Text('1480', style: TextStyle(color: Colors.red)),
                     ],),
                     Row(children: <Widget>[
                       Container(
                         width: 200,
                         child: RaisedButton(
                           color: Color(0xffe48181),
                           child: Text('REFUND '),
                           onPressed: () {
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




class OrderRow extends StatelessWidget {
  OrderRow({@required this.product});
  final Map<String, dynamic > product;


  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(name: 'INR',
                                                    decimalDigits: 2,
                                                  //                                                      locale: Localizations.localeOf(context).toString()
                                                  );


    return ScopedModelDescendant<NewAppStateModel> (
        builder: (context, child, model) {

          return Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: <Widget>[
                      Text(product['name']),
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
                      child: Text(product['mrp']),
                      flex: 3,
                      ),
                    Expanded(
                      child: new Text(product['sp']),
                      flex: 3,
                      ),
                    Expanded(
                      flex: 3,
                      child: Text(product['qty']),
                      ),
                    Expanded(
                      flex: 2,
                      child:
//                      Text('${formatter.format('??')}'),
                      Text(product['total']),
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





