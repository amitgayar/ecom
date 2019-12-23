// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/app_state_model.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'model/Database_Models.dart';
import 'Databases/Database.dart';
import 'dart:convert';
import 'services/syncData.dart';
import 'AppScreens/cart1.dart';
import 'AppScreens/cart2.dart';
import 'AppScreens/cart3.dart';



//NewAppStateModel newModel = NewAppStateModel();
//NewAppStateModel model2 = NewAppStateModel();
//NewAppStateModel model3 = NewAppStateModel();





class HomePage extends StatefulWidget {
  const HomePage({ Key key }) : super(key: key);

@override
  _HomePage createState() => _HomePage();
}
class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin {

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController( vsync: this,length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//     final int cartQ = ScopedModel.of<NewAppStateModel>(context).totalCartQuantity;


    return Scaffold(
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
                getSyncAPI();
//                  Navigator.pushNamed(context, '/login');
              },
              ),
            ListTile(
              title : Text('Load DB'),
              leading: Icon(Icons.file_download),
              onTap: (){
                getSyncAPI();
//                  Navigator.pushNamed(context, '/login');
              },
              ),
          ],
          ),
        ),
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color(0xff429585),
        bottom: TabBar(
          onTap: (index){
            setState((){
//              head[_tabController.index] = !head[_tabController.index];
//              print(_tabController.index);
            });
          },
            controller: _tabController,

            isScrollable: false,
            indicatorColor: Color(0xff81c784),
            indicatorPadding: EdgeInsets.all(2.0),
            indicatorWeight: 3,
            labelStyle: TextStyle(color: Colors.black),
            tabs: <Widget>[
              HeadingOfCart1(head: _tabController.index),
              HeadingOfCart2(head: _tabController.index),
              HeadingOfCart3(head: _tabController.index),
            ]
            ),
        ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [Cart1(),Cart2(),Cart3(),
        ],
        ),
      );




  }
}

//
//Blue color : #64b5f6 , #90caf9 ... function
//Similarly for green : #81c784, #a5d6a7... done
//For teal : #4db6ac , #80cbc4 ... selection
// for toast : Colors.black87, text.color.white, center

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

            await PostSyncAPI();
            //InsertDataToTable new_inset = new InsertDataToTable();
            //insert_productCategories(data);


            //List<Map<String, dynamic>> queryResult = await dbHelper.queryRowCount("productCategories", "16");
            //print('queryResult: $queryResult');

          }
          ),
      );
  }
}













