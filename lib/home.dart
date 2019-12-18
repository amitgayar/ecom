

//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'category_menu_page.dart';
import 'model/app_state_model.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'model/Database_Models.dart';
import 'Databases/Database.dart';
import 'dart:convert';
import 'services/syncData.dart';
import 'cart2.dart';
import 'cart3.dart';
import 'cart1.dart';










List<String> _tabs = ['Cart 1', 'Cart 2', 'Cart 3'];
class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
      child: Scaffold(
        appBar: AppBar(
          title: Text('home section'),
                  backgroundColor: Colors.blueGrey,

          bottom: TabBar(
            // These are the widgets to put in each tab in the tab bar.
            tabs: _tabs.map((String name) => Tab(text: name)).toList(),
            ),
          ),
        body: TabBarView(
          // These are the contents of the tab views, below the tabs.
          children: [Cart1(),Cart2(),Cart3()],
          ),
        ),

//      Scaffold(
//      body: HomeSection(),

    );
  }
}

