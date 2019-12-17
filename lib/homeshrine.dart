

//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'shopping_cart.dart';
import 'category_menu_page.dart';
import 'model/app_state_model.dart';
import 'model/product.dart';
import 'supplemental/product_grid_view.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'model/Database_Models.dart';
import 'Databases/Database.dart';
import 'services/addDataToTable.dart';
import 'dart:convert';
import 'services/syncData.dart';
import 'cart2.dart';

//import 'customer.dart';

//import 'package:intl/intl.dart';




class HomeSection extends StatefulWidget {
  @override
  _HomeSection createState() => _HomeSection();
}

class Item {
  Item({
//    this.expandedValue,
//    this.headerValue,
    this.isExpanded = false,
  });

//  String expandedValue;
//  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
//      headerValue: 'Panel 1',
//      expandedValue: 'sdsd',
);
  });
}

List<Item> _data = generateItems(1);

class _HomeSection extends State<HomeSection> {
  List<Widget> _createShoppingCartRows(AppStateModel model) {
    return model.productsInCart.keys
        .map(
          (id) => ShoppingCartRow(
        product: model.getProductById(id),
        quantity: model.productsInCart[id],
        onPressed: () {
          model.removeItemFromCart(id);
        },
      ),
    )
        .toList();
  }
  String _totalAmount(AppStateModel model) {
    return model.totalCost.toString();
  }



  Widget quickLinkSection = Text('  Quick Links     ');
  Widget productDetailHeadingSection = SizedBox(
    height: 30,
    child: Text(
      'Product :             MRP             SP             QTY             Total',
      textAlign: TextAlign.left,
      ),
    );
  Widget _buildPanel() {

    return ExpansionPanelList(
      expansionCallback: (int index,bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return
              quickLinkSection
            ;},
          body: Column(
            children: <Widget>[
              SizedBox(
                width: 300,
                height: 30,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),

                    ),
                  ),
                ),
              ProductPage(),
            ],
          ),
//          ProductPage(),
          isExpanded: item.isExpanded,
          );
      }).toList(),
      );
  }

  @override
  Widget build(BuildContext context) {
    var lastBarSection = Container(
        height: 60,
        width: 500,
        child: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    color: Colors.brown,
                    splashColor: Colors.brown,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.delete,),
                      ),
                    onPressed: () {
                      model.clearCart();

                    },
                    ),
                  SizedBox(width: 50,),
                  RaisedButton(
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    color: Colors.deepOrange,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(_totalAmount(model),
                                    style: TextStyle(color:Colors.black, fontWeight: FontWeight.bold),),
                      ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                    ),


                  SizedBox(width: 50,),
                  RaisedButton(
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    color: Colors.brown,
                    splashColor: Colors.brown,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.person_add,),
                      ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/customer');

                    },
                    ),
                ],
                );
            })

        );
    var shoppingCartRowSection = Container(
      child: SizedBox(
        height: 300,
        child: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            return ListView (
              children: _createShoppingCartRows(model),
              );
          },
          ),
        ),
      );
    return Scaffold(

      drawer: Drawer(
        child: CategoryMenuPage(),

      ),
      body: SafeArea(

        child: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          return  Stack(
            children: <Widget>[
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                children: <Widget>[
//              carts,
//              const Divider(
//                  color: Colors.brown, height: 10, thickness: 5
//              ),

//              quickLinkSection,
                  _buildPanel(),
//              ProductSection(),

                  const Divider(
                      color: Colors.brown, height: 20, thickness: 5
                      ),

                  productDetailHeadingSection,
                  const Divider(
                      color: Colors.brown, height: 10, thickness: 5
                      ),

//              .....................................................Shopping Cart Rows!!!!
                  shoppingCartRowSection,
                  ShoppingCartSummary(model: model),

//


                ],
                ),
              Align(child: SizedBox(
                height: 70,
                width: 500,
                child: Column(
                  children: <Widget>[
                    const Divider(
                        color: Colors.brown, height: 10, thickness: 5
                        ),
//              .....................................................Last Bar Section!!!
                    lastBarSection,
                  ],
                  ),
              ),
                        alignment: Alignment.bottomCenter,),
            ],
          );
        }),

      ),
    );
  }
}



List<String> _tabs = ['Cart 1', 'Cart 2', 'Cart 3'];
class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
      child: Scaffold(
        appBar: AppBar(
          title: Text('home section'),
          //        backgroundColor: Colors.brown,

          bottom: TabBar(
            // These are the widgets to put in each tab in the tab bar.
            tabs: _tabs.map((String name) => Tab(text: name)).toList(),
            ),
          ),
        body: TabBarView(
          // These are the contents of the tab views, below the tabs.
          children: [HomeSection(),Cart2(),HomeSection()],
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