

//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/app_state_model.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'model/Database_Models.dart';
import 'Databases/Database.dart';
import 'dart:convert';
import 'services/syncData.dart';
//import 'cart2.dart';
import 'cart3.dart';
import 'cart1.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'model/Database_Models.dart';
import 'Databases/Database.dart';
import 'dart:convert';
import 'services/syncData.dart';
//import 'AppScreens/cart1.dart';
import 'AppScreens/cart2.dart';
//import 'AppScreens/cart3.dart';











List<String> _tabs = ['Cart 1', 'Cart 2', 'Cart 3'];
class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
      child: Scaffold(
        drawer: Drawer(
            child: ListView(

      padding: EdgeInsets.zero,
        children: <Widget>[
              DrawerHeader(
                child: Container(
                  color: Color(0xff429585),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Express Store',
                             style: TextStyle(color: Colors.white70,
                                                  fontSize: 22.0
                                              ),
                           ),
                      Icon(Icons.account_circle,
                           size:30,
                           ),
                      Text('Store Name\n(9876567800)',
                             style: TextStyle(color: Colors.white70,
//                                                  fontSize: 22.0
                                              ),
                           ),
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
                onTap: (){
                  Navigator.pushNamed(context, '/');
                },
                ),
              ListTile(
                title : Text('ORDERS'),
                leading: Icon(Icons.shopping_basket),
                onTap: (){
                  Navigator.pushNamed(context, '/orders');
                },
                ),
              ListTile(
                title : Text('CUSTOMERS'),
                leading: Icon(Icons.account_box),
                onTap: (){
                  Navigator.pushNamed(context, '/customers');
                },
                ),
              ListTile(
                title : Text('REQUEST STOCKS'),
                leading: Icon(Icons.near_me),
                onTap: (){
                  Navigator.pushNamed(context, '/requestStocks');
                },
            ),
              ListTile(
                title : Text('LogOut'),
                leading: Icon(Icons.power_settings_new),
                onTap: (){
                  Navigator.pushNamed(context, '/login');
                },
                ),
        ],
        ),
      ),
        appBar: AppBar(
          title: Text('HOME'),
                  backgroundColor: Color(0xff429585),
          bottom: TabBar(
            // These are the widgets to put in each tab in the tab bar.
            tabs: _tabs.map((String name) => Tab(text: name)).toList(),
            ),
          ),
        body: TabBarView(
          // These are the contents of the tab views, below the tabs.
          children: [Cart1(),Cart2(),Cart2()],
          ),
        ),

//      Scaffold(
//      body: HomeSection(),

    );
  }
}


class NewsListPage extends StatefulWidget {

  @override
  _NewsListPageState createState() => _NewsListPageState();
}



class _NewsListPageState extends State<NewsListPage> {
  final dbHelper = DatabaseHelper.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("test"),
        ),
      body: RaisedButton(
          child: const Text('Login'),
          elevation: 8.0,
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),
          onPressed: () async {

//            await PostSyncAPI();
            //InsertDataToTable new_inset = new InsertDataToTable();
            //insert_productCategories(data);


            //List<Map<String, dynamic>> queryResult = await dbHelper.queryRowCount("productCategories", "16");
            //print('queryResult: $queryResult');

          }
          ),
      );
  }
}
