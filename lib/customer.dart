import 'package:flutter/material.dart';
//import 'package:flutter/foundation.dart.dart';
//import 'app.dart';
import 'model/app_state_model.dart';
//import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
//import 'shopping_cart.dart';
//import 'backdrop.dart';
////import 'expanding_bottom_sheet.dart';
//import 'model/app_state_model.dart';
import 'supplemental/product_grid_view.dart';
import 'dart:io';
import 'services/syncData.dart';

import 'model/queryForUI.dart';
//import 'supplemental/product_grid_view.dart';
//import 'homeshrine.dart';

List<String> customerList = [
  'Ivan',
  'Peter',
  'Vladimir',
  'Fyodor',
  'Nikolai'
];

List<Widget> _createCustomerCardList(List<String> customerList) {
  return customerList
      .map(
        (c) => CustomerRow(customerName:c),
        ).toList();
}

class CustomerRow extends StatelessWidget {
  CustomerRow(
      {@required this.customerName}
      );

  final String customerName;
//final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
//      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
       height: 40,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(customerName, style: TextStyle(),),
          ),
        ],
      ),
    );
  }
}


class Customer extends StatefulWidget {
  @override
  _CustomerState createState() => _CustomerState();
}

class _CustomerState extends State<Customer>{
//   bool isSelected = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer"),

      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            Row(

              children: <Widget>[
                Expanded(
                  child: new Container(
//                height: 30,
                      child: TextField(
//                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search),

                        ),
                      ),
                      ),
                  ),
//                  SizedBox(height: 30, width: 40,),
                IconButton(icon: Icon(Icons.person_add), onPressed:(){
                  print('Add Customer - icon clicked on customer page!!!!');
                  Navigator.pushNamed(context, '/addCustomer');
                }),
              ],
              ),
            Column(
              children: _createCustomerCardList(customerList),
            ),
          ],
        ),

//
        )
    );
  }
}

class AddCustomer extends StatefulWidget {
  @override
  _AddCustomer createState() => _AddCustomer();
}

class _AddCustomer extends State<AddCustomer> {




  NewAppStateModel newModel = NewAppStateModel();




  Widget quickLinkSection = Text('  Quick Links     ');
  Widget _buildPanel() {

    return ExpansionPanelList(
      expansionCallback: (int index,bool isExpanded) {
        setState(() {
          //          getSyncAPI();
//          print('database synced!!!!!');
//          queryForUI('products', 'id', '=', '21');
//          print('is printed!!!!');
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
              MyCustomForm(),
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
    return Scaffold(
        appBar: AppBar(
          title: Text("Testing Arena"),

          ),
        body:   ScopedModel<NewAppStateModel>(
          model: newModel,
          child: ListView(
              children: <Widget>[
                _buildPanel(),
              ]
              ),
          ),



        );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    myController.addListener(_printLatestValue);
  }

  _printLatestValue() {
    print("Second text field: ${myController.text}");
  }

  _test() {
    print("hi there");
  }

  @override
  Widget build(BuildContext context) {
    return Con(_test, myController);
  }
}


class Con extends StatelessWidget {
  Con(this.clickCallback, this.tc);
  final TextEditingController tc;
  final VoidCallback clickCallback;
  bool h = true;

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<NewAppStateModel>(
        builder: (context, child, model)
    {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: 300,
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () async{
                  clickCallback();
                  var allProducts = await model.queryForUI('products', '', '', '');
//                  model.loadProducts(allProducts);
                  print(model.getProducts());
//                  print(allProducts);
//                  List<Map<String, dynamic>>  allProducts = model.dbProducts;
//                Future<List<Map<String, dynamic>>> allCategories =  queryForUI('productCategories', '', '', '');
//                Future<List<Map<String, dynamic>>> allCustomProducts =  queryForUI('customProducts', '', '', '');


                  print('success');
//                print(allCategories);
//                print(allCustomProducts);
                },
                child: Text("Load All Data"),
                ),
              TextField(
                controller: tc,
//                onChanged: (text) async{
//                  //          getSyncAPI();
//                  if (text.length < 30) {
//                    queryForUI('productCategories', 'id', '<', text);
//                    print("First text field: ${text.length}");
//                    var allProducts = await model.queryForUI('products', '', '', '');
//
//                    print(allProducts);
//                  }
//                },
                decoration: InputDecoration(
                    hintText: 'search',
                    filled: true,
//                prefixIcon: Icon(
//                  Icons.account_box,
//                  size: 18.0,
//                  ),
                    suffixIcon: IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          tc.clear();
                        })),
                ),


            ],
            ),
          ),
        );
    });
  }
}

class _SliverAppBar extends StatelessWidget {
  _SliverAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = '';

    return Scaffold(
      // No appbar provided to the Scaffold, only a body with a
      // CustomScrollView.
      body: CustomScrollView(
        slivers: <Widget>[
          // Add the app bar to the CustomScrollView.
          SliverAppBar(
            // Provide a standard title.
            title: Text(title),
              // Allows the user to reveal the app bar if they begin scrolling
              // back up the list of items.
              floating: true,
              // Display a placeholder widget to visualize the shrinking size.
              flexibleSpace: Placeholder(
                color: Colors.brown,
              ),
              // Make the initial height of the SliverAppBar larger than normal.
              expandedHeight: 250,
            ),
          // Next, create a SliverList
          SliverList(
            // Use a delegate to build items as they're scrolled on screen.
            delegate: SliverChildBuilderDelegate(
              // The builder function returns a ListTile with a title that
              // displays the index of the current item.
              (context, index) => ListTile(title: Text('Item #$index')),
                // Builds 1000 ListTiles
                childCount: 1000,
              ),
            ),
        ],
        ),
      );
  }
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

// ...

List<Item> _data = generateItems(1);



