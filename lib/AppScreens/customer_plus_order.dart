import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../model/app_state_model.dart';
import 'package:express_store/service_locator.dart';
import 'customer.dart';
import 'orders.dart';

NewAppStateModel customerPlusOrderModel = new NewAppStateModel();


class CustomerPlusOrder extends StatefulWidget {
  CustomerPlusOrder({this.page});
  String page;
  @override
  _CustomerPlusOrder createState() => _CustomerPlusOrder();
}

class _CustomerPlusOrder extends State<CustomerPlusOrder> {

  @override
  Widget build(BuildContext context) {

//    customerModel.queryCustomerInDatabase('all', "");
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
        title: Text(widget.page),
        backgroundColor: Color(0xff429585),
        ),

      body: SafeArea(

        child: ScopedModel<NewAppStateModel>(
          model: customerPlusOrderModel,
          child: widget.page == 'customer'?
          SelectCustomer()
              :
              OrderTiles(),
          ),
        ),
      );
  }

}
