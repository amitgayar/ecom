

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
          children: [Cart2(),Cart2(),Cart3()],
          ),
        ),

//      Scaffold(
//      body: HomeSection(),

    );
  }
}








//..............................................from Manav home file
class NewsListPage extends StatefulWidget {

  @override
  _NewsListPageState createState() => _NewsListPageState();
}



class _NewsListPageState extends State<NewsListPage> {
  final dbHelper = DatabaseHelper.instance;

  Future<List<categories>> getData() async {
    List<categories> list;
    String json_test = await rootBundle.loadString('assets/PostRequestFormat.json');
    print("loaded json: ${json_test}");

    var data = json.decode(json_test);
    var rest = data as List;
    print("print data list: $rest");
    list = rest.map<categories>((json) => categories.fromJson(json)).toList();
    print("List Size: ${list.length}");
    print("List : ${list[0]}");
    return list;
  }




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

            List<categories> data = await getSyncAPI();
            //InsertDataToTable new_inset = new InsertDataToTable();
            //insert_productCategories(data);


            //List<Map<String, dynamic>> queryResult = await dbHelper.queryRowCount("productCategories", "16");
            //print('queryResult: $queryResult');

          }
          ),
      );
  }
}
//...................................................from Manav home file