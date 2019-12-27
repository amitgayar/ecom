//import 'package:express_store/model/app_state_model.dart';
//import 'package:intl/intl.dart';
//import 'package:flutter/material.dart';
//import '../model/manageOrders.dart';
//import '../model/queryForUI.dart';
//import 'package:scoped_model/scoped_model.dart';
//import 'package:express_store/Databases/Database.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
//
//
//class orderDetails extends StatelessWidget {
//  orderDetails({@required this.orderModel}
//      );
//  final NewAppStateModel orderModel;
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
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Expanded(
//                        child: Container(
//                          child: Image.asset('assets/images/logo.png',
//                            width: 120.0,
//                            height: 90.0,
//                            fit: BoxFit.fitWidth,
//                            color: Colors.black87,
//                          ),
//                        ),
//                        flex: 2,),
//                      Expanded(
//                        child: Icon(Icons.account_circle,
//                          size:30,
//                        ),
//                        flex: 1,),
//                      Expanded(
//                        child: Text('Store Name\n(9876567800)',
//                          style: TextStyle(color: Colors.black,
//                            //                                                  fontSize: 22.0
//                          ),
//                        ),
//                        flex: 1,
//                      )
//                    ],
//                  ),
//                  alignment: Alignment.center,
//                ),
//                decoration: BoxDecoration(
//                  color: Color(0xff429585),
//                ),
//              ),
//              ListTile(
//                title : Text('HOME'),
//                leading: Icon(Icons.add_shopping_cart),
//                onTap: (
//                    ){
//                  Navigator.pushNamed(context, '/');
//                },
//              ),
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
//              ),
//              Divider(color:Color(0xff429585) , thickness: 2, height: 20,),
//              ListTile(
//                title : Text('CUSTOMERS'),
//                leading: Icon(Icons.account_box),
//                onTap: (){
//                  Navigator.pushNamed(context, '/customers');
//                },
//              ),
//              Divider(color:Color(0xff429585) , thickness: 2, height: 20,),
//              ListTile(
//                title : Text('REQUEST STOCKS'),
//                leading: Icon(Icons.near_me),
//                onTap: (){
//                  Navigator.pushNamed(context, '/requestStocks');
//                },
//              ),
//              Divider(color:Color(0xff429585) , thickness: 2, height: 20,),
//              Container(
//                height: 225,
//
//              ),
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
//                ),
//              ),
//            ],
//          ),
//        ),
//
//        appBar: AppBar(
//          title: Text('Customers'),
//          backgroundColor: Color(0xff429585),
//          //          bottom: TabBar(
//          //            // These are the widgets to put in each tab in the tab bar.
//          //            tabs: _tabs.map((String name) => Tab(text: name)).toList(),
//          //            ),
//        ),
//        body: SelectOrder(orderModel: orderModel)
//
//    );
//  }
//}
//
//class SelectOrder extends StatefulWidget {
//  SelectOrder({@required this.orderModel}
//      );
//  final NewAppStateModel orderModel;
//
//  @override
//  _SelectOrder createState() => _SelectOrder ();
//}
//
//class _SelectOrder extends State<SelectOrder> {
//
//  List<Container> _buildCustomerTiles(BuildContext context, List<Map> orderList ) {
//    final formatter = NumberFormat.simpleCurrency(name: 'INR', decimalDigits: 2,
//        locale: Localizations.localeOf(context).toString());
//    if (orderList == null || orderList.isEmpty) {
//      return const <Container>[];
//    }
//    return List.generate(orderList.length, (index) {
//      return Container(
//        child: ListTile (
//          title: Container(
//            child: Column(
//              children: [
//                Padding(
//                  padding: EdgeInsets.only(top: 10, left: 10, right:10),
//                  child: Row(
//                    children: <Widget>[
//                      Expanded (
//                        child: Text(
//                          (orderList[index]["${DatabaseHelper.invoice}"] != null) ? "Invoice: ${orderList[index]["${DatabaseHelper.invoice}"]}" : "",
//                        ),
//                        flex: 3,
//                      ),
//                      Expanded (
//                        child: Text(
//                          (orderList[index]["${DatabaseHelper.created_at}"] != null) ? "Date: ${orderList[index]["${DatabaseHelper.created_at}"]}" : "",
//                        ),
//                        flex: 2,
//                      )
//
//
//                    ],
//                  ),
//                ),
//                Padding(
//                  padding: EdgeInsets.only(top: 10, left: 10, right:10),
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Text(
//                          (orderList[index]["${DatabaseHelper.cart_total}"] != null) ? "Total Amount: ${formatter.format(orderList[index]["${DatabaseHelper.cart_total}"])}" : "Total Amount: ${formatter.format(0)}",
//                        ),
//                        flex: 3,
//                      ),
//                      Expanded (
//                        child: Text(
//                          (orderList[index]["order_quantity"] != null) ? "${orderList[index]["order_quantity"]} Items" : "",
//                        ),
//                        flex: 2,
//                      ),
//
//
//                    ],
//                  ),
//                ),
//                Padding(
//                  padding: EdgeInsets.only(top: 10, left: 10, right:10),
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child: Text(
//                          (orderList[index]["${DatabaseHelper.amount}"] != null) ? "CREDIT: ${formatter.format(orderList[index]["${DatabaseHelper.amount}"])}" : "CREDIT: ${formatter.format(0)}",
//                        ),
//                        flex: 3,
//                      ),
//                      Expanded (
//                        child: Text(
//                          (orderList[index]["${DatabaseHelper.cart_discount_total}"] != null) ? "Total Discount: ${formatter.format(orderList[index]["${DatabaseHelper.cart_discount_total}"])}" : "",
//                        ),
//                        flex: 2,
//                      ),
//
//
//                    ],
//                  ),
//                ),
//                Padding(
//                  padding: EdgeInsets.only(top: 10, left: 10, right:10),
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        child:Text(
//                          (orderList[index]["${DatabaseHelper.paid_amount_total}"] != null) ? "Total Paid: ${formatter.format(orderList[index]["${DatabaseHelper.paid_amount_total}"])}" : "",
//                        ),
//                        flex: 2,
//                      ),
//                      Expanded (
//                        child: RaisedButton(
//                            child: Text(orderList[index]['${DatabaseHelper.status}']),
//                            onPressed: () {
//                            },
//                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
//                        ),
//                        flex: 2,
//                      ),
//                      (orderList[index]['${DatabaseHelper.payment_method}'] != "") ? Expanded (
//                        child: RaisedButton(
//                            child: Text(orderList[index]['${DatabaseHelper.payment_method}']),
//                            onPressed: () {
//                            },
//                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
//                        ),
//                        flex: 1,
//                      ) : Text(""),
//                      (double.parse(orderList[index]["${DatabaseHelper.cgst}"].toString()) > 0 || double.parse(orderList[index][DatabaseHelper.sgst.toString()].toString()) > 0 ||
//                          double.parse(orderList[index][DatabaseHelper.cess.toString()].toString()) > 0) ? Expanded (
//                        child: RaisedButton(
//                            child: Text("GST"),
//                            onPressed: () {
//                            },
//                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
//                        ),
//                        flex: 1,
//                      ) : Text("")
//
//
//                    ],
//                  ),
//                ),
//                Divider(color: Color(0xff429585),thickness: 1,height: 4,)
//
//              ],
//            ),
//          ),
//          onTap: () async {
//
//            int id = int.parse(orderList[index]['id'].toString());
////            model.setSelectCustomerForCartFlag(false);
//          },
//        ),
//      );
//    }).toList() ;
//  }
//
//
//
//
//  @override
//  Widget build(BuildContext context) {
//
//
//    String _date = "Not set";
//    String _selectedPaymentMode;
//    String _selectedOrderStatus;
//    String _selectedCreditStatus;
//
////    print('gayar in UI\n\n' + dummyCustomersList.toString());
//
//    return ScopedModelDescendant<NewAppStateModel> (
//
//        builder: (context, child, model) {
//
//
//          return Container(
////                  height:440,
////            width: 5000,
//              color: Colors.white,
//              child: Padding(
//                padding: EdgeInsets.symmetric(horizontal: 0),
//                child: ListView(
//                  children: <Widget>[
//                    Row(
//                      children: <Widget>[
//                        Expanded(
//                          child:Container(
//                              child: Padding(
//                                padding: EdgeInsets.all(20),
//                                child: SizedBox(
//                                  child: TextField(
//                                    decoration: InputDecoration(
//                                      hintText: 'search',
//                                      filled: false,
//                                      prefixIcon: Icon(
//                                        Icons.search,
//                                        size: 18.0,
//                                      ),
//                                    ),
//                                    onChanged: (text) async{
//                                      widget.orderModel.filterOrders(text,
//                                          widget.orderModel.finalDateForFilter, widget.orderModel.finalPaymentMethodForFilter,
//                                          widget.orderModel.finalStatusForFilter, widget.orderModel.finalCreditForFilter);
//                                    },
//
//                                  ),
//                                ),
//                              )
//                          ),
//                          flex: 7,
//                        ),
////                        Expanded (
////                          child: RaisedButton(
////                              child: Row(
////                                children: <Widget>[
////                                  Icon(Icons.calendar_today,
////                                    size:16,
////                                  ),
////                                  Text("  ${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}"),
////
////                                ],
////                              ),
////                              onPressed: () {
////                                DatePicker.showDatePicker(context,
////                                    theme: DatePickerTheme(
////                                      containerHeight: 210.0,
////                                    ),
////                                    showTitleActions: true,
////                                    minTime: DateTime(2000, 1, 1),
////                                    maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
////                                      print('confirm $date');
////                                      _date = '${date.year}-${date.month}-${date.day}';
////
////
////                                      print("Date = $_date");
//////                                      widget.orderModel.filterOrders(widget.orderModel.finalSearchStringForFilter,
//////                                          _date, widget.orderModel.finalPaymentMethodForFilter,
//////                                          widget.orderModel.finalStatusForFilter, widget.orderModel.finalCreditForFilter);
////
////
//////                                      setState(() {});
//////                                    }, locale: LocaleType.en);
////
////                              },
//////                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
////                          ),
////                          flex: 4,
////                        ),
////
////
////
////                      ],
////                    ),
//                    Row(
//                      children: <Widget>[
//                        Expanded(
//                          child:Container(
//                            child: Icon(Icons.filter_list,
//                              size:25,
//                            ),
//                          ),
//                          flex: 1,
//                        ),
//                        Expanded(
//                          child:Container(
//                            width: 150,
//                            child: DropdownButton<String>(
//                              items: <String>["name", "value"].map((String value) {
//                                //print("\n\n value dropdown = $value");
//                                return new DropdownMenuItem<String>(
//                                  value: value,
//                                  child: new Text(value),
//                                );
//                              }).toList(),
//                              value: _selectedPaymentMode,
//                              onChanged: (newValue) {
//                                setState(() {
//                                  _selectedPaymentMode = newValue;
//                                });
//                              },
//                              hint: Text('Payment Mode'),
//                            ),
//                          ),
//                          flex: 3,
//                        ),
//                        Expanded(
//                          child:Container(
//                              child: Padding(
//                                padding: EdgeInsets.all(10),
//                                child: DropdownButton<String>(
//                                  items: <String>["Credit", "All"].map((String value) {
//                                    //print("\n\n value dropdown = $value");
//                                    return new DropdownMenuItem<String>(
//                                      value: value,
//                                      child: new Text(value),
//                                    );
//                                  }).toList(),
//                                  value: _selectedCreditStatus,
//                                  onChanged: (newValue) {
//                                    setState(() {
//                                      _selectedCreditStatus = newValue;
//                                    });
//                                  },
//                                  hint: Text('All'),
//                                ),
//                              )
//                          ),
//                          flex: 2,
//                        ),
//                        Expanded (
//                          child: Container(
//                              child: Padding(
//                                padding: EdgeInsets.all(10),
//                                child: DropdownButton<String>(
//                                  items: <String>["Completed", "Refunded", "Partially refunded"].map((String value) {
//                                    //print("\n\n value dropdown = $value");
//                                    return new DropdownMenuItem<String>(
//                                      value: value,
//                                      child: new Text(value),
//                                    );
//                                  }).toList(),
//                                  value: _selectedOrderStatus,
//                                  onChanged: (newValue) {
//                                    setState(() {
//                                      _selectedOrderStatus = newValue;
//                                    });
//                                  },
//                                  hint: Text('Status'),
//                                ),
//                              )
//                          ),
//                          flex: 2,
//                        ),
//
//
//
//                      ],
//                    ),
//                    Divider(color: Colors.black12, thickness: 3, height: 20,),
//                    Text('Total Orders: ${widget.orderModel.finalOrdersToDisplay.length.toString()}'),
//                    Divider(color: Colors.black12, thickness: 3, height: 20,),
//
//                    Column(
//                      children: _buildCustomerTiles(context, widget.orderModel.finalOrdersToDisplay),
//
//                    )
//
//
//                  ],
//                ),
//              )
//          );
//        }
//    );
//
//
//
//  }
//}
//
//
//
//
//
//
//
