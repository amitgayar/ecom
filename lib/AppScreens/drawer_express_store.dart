import 'package:flutter/material.dart';

class DrawerExpress extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

  return Drawer(
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
      child: Text('Store Named\n(9876567800)',
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
            if(Navigator.canPop(context)){
//              Navigator.popAndPushNamed(context, '/');
//              Navigator.of(context).pushNamedAndRemoveUntil('/', ModalRoute.withName('/login'));
            }
            Navigator.of(context).pushNamedAndRemoveUntil('/', ModalRoute.withName('/login'));
          },
          ),
        Divider(color:Color(0xff429585) , thickness: 2, height: 20,),
        ListTile(
          title : Text('ORDERS'),
          leading: Icon(Icons.shopping_basket),
          onTap: (){

//                OrdersName();
            print("\n\n ORDERS is clicked in menu bar\n\n");
//            Navigator.popAndPushNamed(context, '/orders');
            Navigator.of(context).pushNamedAndRemoveUntil('/orders', ModalRoute.withName('/'));
          },

          ),
        Divider(color:Color(0xff429585) , thickness: 2, height: 20,),
        ListTile(
          title : Text('CUSTOMERS'),
          leading: Icon(Icons.account_box),
          onTap: (){
//            Navigator.popAndPushNamed(context, '/customers');
            Navigator.of(context).pushNamedAndRemoveUntil('/customers', ModalRoute.withName('/'));
          },
          ),
        Divider(color:Color(0xff429585) , thickness: 2, height: 20,),
        ListTile(
          title : Text('REQUEST STOCKS'),
          leading: Icon(Icons.near_me),
          onTap: (){
//            Navigator.popAndPushNamed(context, '/requestStocks');
            Navigator.of(context).pushNamedAndRemoveUntil('/requestStocks', ModalRoute.withName('/'));
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
//              Navigator.pushNamed(context, '/login');
              Navigator.popUntil(context, ModalRoute.withName('/login'));
            },
            ),
          ),
      ],
      ),
    );
  }
}