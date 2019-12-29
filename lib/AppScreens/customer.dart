import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../model/app_state_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:express_store/Databases/Database.dart';
import 'package:flutter/services.dart';

NewAppStateModel customerModel = new NewAppStateModel();


class Customer extends StatefulWidget {
  @override
  _Customer createState() => _Customer();
}

class _Customer extends State<Customer> {

  @override
  Widget build(BuildContext context) {

    customerModel.queryCustomerInDatabase('all', "");
    return Scaffold(
      body: SafeArea(

        child: ScopedModel<NewAppStateModel>(
          model: customerModel,
          child: CustomerDescendant(),
        ),
      ),
    );
  }

}



class CustomerDescendant extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    print('\n\n customer page check     ...... ');
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
          title: Text('Customers'),
          backgroundColor: Color(0xff429585),
          //          bottom: TabBar(
          //            // These are the widgets to put in each tab in the tab bar.
          //            tabs: _tabs.map((String name) => Tab(text: name)).toList(),
          //            ),
        ),
        body: SelectCustomer()

    );
  }
}






class SelectCustomer extends StatefulWidget {

  @override
  _SelectCustomer createState() => _SelectCustomer ();
}


class _SelectCustomer extends State<SelectCustomer> {


  String selectedType = 'customer';
  String selectedHistory = 'credit';//
  String selectedCustomer = '';
  int selectedCustomerID = 0 ;
  bool isCustomerSelected = false;
  bool payButtonClicked = false;
  bool successMessage = false;

  String paymentMode  = '';



  void pageState({String type:'',String customer :'', int customerID}){
    selectedType = type;
    selectedCustomer = customer;
    selectedCustomerID = customerID;
  }
  TextEditingController _paidAmountController = new TextEditingController(text: '0.0');

  @override
  Widget build(BuildContext context) {




    return ScopedModelDescendant<NewAppStateModel> (

        builder: (context, child, model) {

          final _amountValidator = RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

          List<Container> _buildCustomerTiles(BuildContext context) {

            List<Map> customerList = model.tempCustomersInDatabaseToDisplay;

            if (customerList == null || customerList.isEmpty) {
              print('build tiles : $customerList');
              return const <Container>[];
            }
            print('build tiles : ' + customerList.toString());
            return List.generate(customerList.length, (index) {
              double credit = (double.parse(customerList[index]['credit_balance'].toString()) >= 0)
                  ? double.parse(customerList[index]['credit_balance'].toString()) : -1*double.parse(customerList[index]['credit_balance'].toString());
              return Container(
                child: ListTile (
                  title: Text(customerList[index]['name']),
                  subtitle: Text(customerList[index]['phone_number']),
                  trailing:
//                  selectedType == 'credit'
//                      ?
                  (int.parse(customerList[index]['credit_balance'].toString()) >= 0) ?
                  Text('Rs. $credit', style: TextStyle(color: Colors.green, fontSize: 22),):
                  Text('Rs. $credit', style: TextStyle(color: Colors.red, fontSize: 22),),
//                  : new Container(),
                  onTap: ()  async {
                    await model.selectCustomerById(int.parse(customerList[index]['id'].toString()), "customer_section");
                    setState(() {

//                     int id = int.parse(customerList[index]['id'].toString());
//                     await model.selectCustomer(id, "cart");
//                     var selectedCustomer = await model.selectedCustomer;
//                     pageState(customer: 'amit');
                      isCustomerSelected = true;

                    });


                  },
                ),
              );
            }).toList() ;
          }

          List<Container> _buildOrderTiles(BuildContext context, List<Map> orderList ) {
            final formatter = NumberFormat.simpleCurrency(name: 'INR', decimalDigits: 2,
                locale: Localizations.localeOf(context).toString());
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

                    model.selectOrder(orderList[index]['id']);
//            model.setSelectCustomerForCartFlag(false);
                  },
                ),
              );
            }).toList() ;
          }

          return Stack(
            children: <Widget>[
              Container(
//                  height:440,
//            width: 5000,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
                      children: <Widget>[
                        Container(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: SizedBox(
                                height: 40,
                                width: 280,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'search',
                                    filled: false,
                                    prefixIcon: Icon(
                                      Icons.search,
                                      size: 18.0,
                                    ),
                                  ),
                                  onChanged: (text) async{
                                    model.queryCustomerInDatabase(selectedType, text);
                                    //_buildCustomerTiles(context);
                                  },

                                ),
                              ),
                            )
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
//                  color: Color(0xff429585),
                                child: FlatButton(
                                    child: selectedType == 'customer' ?
                                    Text('Customers (${model.tempCustomersInDatabaseToDisplay.length})')
                                        : Text('Customers'),
                                    color: selectedType == 'customer'
                                        ?
                                    Colors.greenAccent
                                        :
                                    Colors.white,
                                    onPressed:(){

                                      model.queryCustomerInDatabase("all", "");
                                      setState(() {
                                        selectedType = 'customer';
                                      });

                                    }
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: FlatButton(
                                  child: selectedType == 'credit' ?
                                  Text('Credit (${model.tempCustomersInDatabaseToDisplay.length})') :
                                  Text('Credit'),
                                  color: selectedType == 'credit'
                                      ?
                                  Colors.greenAccent
                                      :
                                  Colors.white,
                                  onPressed:(){
                                    model.queryCustomerInDatabase("credit", "");
                                    setState(() {
                                      selectedType = 'credit';
                                    });

                                  }
                              ),
                              flex: 1,
                            ),
                          ],
                        ),

                        Column(
                          children: [Container(
                            child: ListTile(
                              title: Text(
                                  "Total Credits: ${model.totalCreditsFinal}"
                              ),
                            ),
                          )]+_buildCustomerTiles(context),

                        )


                      ],
                    ),
                  )
              ),
              isCustomerSelected
                  ?
              Container(
                  alignment: Alignment.center,
                  height: 5000,
                  width: 5000,
                  color: Colors.white,
                  child: ListView(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: (){
                              setState(() {
                                isCustomerSelected = false;
                              });
                            },
                          ),
                          Text('Customer Name: ${model.selectedCustomer['name']}'),
                        ],
                      ),
                      Divider(thickness: 2,color: Colors.blueGrey,),
                      Row(
                        children: <Widget>[
                          Text('Phone Number: '),
                          Spacer(),
                          Text('${model.selectedCustomer['phone_number']}'),

                        ],
                      ),
                      Row(children: <Widget>[
                        Text('Pending Credits: Rs. ${model.selectedCustomer['credit_balance']}'),
                        Spacer(),
                        RaisedButton(
                          child: Text('PAY'),
                          color: Colors.green,
                          onPressed: (){
                            model.calculateCredit('0.0');
                            setState(() {
                              payButtonClicked = true;
                            });
                          },
                        )

                      ],
                      ),
                      Divider(thickness: 1, height: 5,color: Colors.blueGrey,),
                      Row(
                        children: <Widget>[
                          Text('Total Spent: Rs. ${model.selectedCustomer['total_spent']}'),
                          Spacer(),
                          Text('Avg Spent : Rs. ${model.selectedCustomer['average_spent']}'),

                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Total Discount : Rs. ${model.selectedCustomer['total_discount']}'),
                          Spacer(),
                          Text('Discount/Order : Rs. ${model.selectedCustomer['avg_discount_perorder']}'),

                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
//                  color: Color(0xff429585),
                              child: FlatButton(
                                  child: Text('Credit History'),
                                  color: selectedHistory == 'credit'
                                      ?
                                  Colors.greenAccent
                                      :
                                  Colors.white,
                                  onPressed:() async{

                                    await model.getOrdersFromDatabase(int.parse(model.selectedCustomer['id']), "customer_credit_history");
                                    setState(() {
                                      selectedHistory = 'credit';
                                    });

                                  }
                              ),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: FlatButton(
                                child: Text('Order History'),
                                color: selectedHistory == 'order'
                                    ?
                                Colors.greenAccent
                                    :
                                Colors.white,
                                onPressed:() async{
                                  await model.getOrdersFromDatabase(int.parse(model.selectedCustomer['id']), "all_orders_of_customer");
                                  setState(() {
                                    selectedHistory = 'order';
                                  });

                                }
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          selectedHistory == 'credit'?
                          Text('Total Orders On Credit: ${model.finalOrdersToDisplay.length}'):
                          Text('Totol Orders: ${model.finalOrdersToDisplay.length}'),

                        ],
                      ),
                      Divider(thickness: 2, color: Colors.blueGrey, height: 10,),
                      Column(
                        children: _buildOrderTiles(context, model.finalOrdersToDisplay),

                      )
                    ],
                  )

              ) //Selected Customer data

                  :new Container(),
              payButtonClicked?
              Container(
                  alignment: Alignment.center,
                  height: 5000,
                  width: 5000,
                  color: Colors.white,
                  child: ListView(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: (){
                              setState(() {
                                payButtonClicked = false;
                              });
                            },
                          ),
                          Text('Customer Name: ${model.selectedCustomer['name']}'),
                        ],
                      ),
                      Divider(thickness: 2,color: Colors.blueGrey,),
                      Row(
                        children: <Widget>[
                          Text('Phone Number: '),
                          Spacer(),
                          Text('${model.selectedCustomer['phone_number']}'),

                        ],
                      ),
                      Row(children: <Widget>[
                        Text('Pending Credits: Rs. ${model.selectedCustomer['credit_balance']}'),


                      ],
                      ),
                      Divider(thickness: 1, height: 5,color: Colors.blueGrey,),
                      Row(
                        children: <Widget>[
                          Expanded (
                            child: Text('Paid Amount:'),
                            flex: 2,
                          ),
                          Expanded (
                              child: Container(
                                child: TextField(
                                  controller: _paidAmountController,
                                  inputFormatters: [_amountValidator],
//
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: false,
                                  ),
                                  onChanged: (text) {
                                    model.calculateCredit(text);
                                  },
                                ),
                                width: 60,
                              ),
                            flex: 2,
                          )

                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Payment Mode'),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              color: paymentMode == 'PAYTM'? Color(0xff81c784) : Colors.white70,
                              child: Text('PAYTM'),
                              onPressed: (){
                                setState(() {
                                  paymentMode = 'PAYTM';
                                });
                              },// Need a payment mode in a variable to call a function
                            ),
                            flex: 1,
                          ),
                          Container(
                            width: 50,
                          ),
                          Expanded(
                            child: RaisedButton(
                              color: paymentMode == 'CASH'? Color(0xff81c784) : Colors.white70,
                              child: Text('CASH'), // Need a payment mode in a variable to call a function
                              onPressed: (){
                                setState(() {
                                  paymentMode = 'CASH';
                                });
                              },),
                            flex: 1,
                          ),



                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              color: paymentMode == 'BHIM UPI'? Color(0xff81c784) : Colors.white70,
                              child: Text('BHIM UPI'), // Need a payment mode in a variable to call a function
                              onPressed: (){
                                setState(() {
                                  paymentMode = 'BHIM UPI';
                                });
                              },
                            ),
                            flex: 1,
                          ),
                          Container(
                            width: 50,
                          ),
                          Expanded(
                            child: RaisedButton(
                              color: paymentMode == 'OTHER'? Color(0xff81c784) : Colors.white70,
                              child: Text('OTHER'), // Need a payment mode in a variable to call a function
                              onPressed: (){
                                setState(() {
                                  paymentMode = 'OTHER';
                                });
                              },
                            ),
                            flex: 1,
                          ),


                        ],
                      ),
                      Row(
                        children: <Widget>[

                          Text('Remaining Credits : ${model.finalRemainingCredit}'), // I will update this after getting above data

                        ],
                      ),
                      RaisedButton(
                        child: Text('Pay Credits'),
                        onPressed: (){

                          model.updateCustomerDatabase(paymentMode.toLowerCase());
                          successMessage = true;
                        },
                      )
                    ],
                  )

              )
                  :

              successMessage?
              Align(
                child: Stack(
                  children: <Widget>[
                    Opacity(
                        opacity: .8,
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              successMessage = false;
                            });
                          },
                          child: Container(
                            height: 5000,
                            width: 3000,
                            color: Colors.black,
                          ),
                        )
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Card(
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.all(15),
                          height: 170,
                          width: 1000,
                          child: Column(children: <Widget>[
                            Icon(Icons.attach_money),
                            Spacer(),
                            Text('Successfully Deducted Rs ${model.finalAmountPaid} from Credit !'),
                            Spacer(),
                            Text('Remaining Credit : Rs. ${model.finalRemainingCredit}',
                              style: TextStyle(color: Colors.red),)
                          ],),
                        ),
                      ),

                    )
                  ],
                ),
                alignment: Alignment.center,
              )
                  :
              new Container(),

            ],
          );

        }
    );



  }
}

class RegExInputFormatter implements TextInputFormatter {
  final RegExp _regExp;

  RegExInputFormatter._(this._regExp);

  factory RegExInputFormatter.withRegex(String regexString) {
    try {
      final regex = RegExp(regexString);
      return RegExInputFormatter._(regex);
    } catch (e) {
      // Something not right with regex string.
      assert(false, e.toString());
      return null;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final oldValueValid = _isValid(oldValue.text);
    final newValueValid = _isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }

  bool _isValid(String value) {
    try {
      final matches = _regExp.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}