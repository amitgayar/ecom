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
import 'model/product.dart';
//import 'supplemental/product_grid_view.dart';
import 'homeshrine.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Customer"),

          ),
        body: NewsListPage(),
//        MyCustomForm(),
        );
  }
}



// Define a Custom Form Widget
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
    return Scaffold(

        body:
        Con(_test, myController)
        );
  }
}

class Con extends StatelessWidget {
  Con(this.clickCallback, this.tc);
  final TextEditingController tc;
  final VoidCallback clickCallback;
  bool h = true;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (text) {
              print("First text field: $text");
            },
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
//                      tc.clear();
                      print('${tc.text}');
                    })),
            ),
          TextField(
            controller: tc,
            ),
          FlatButton(
            onPressed: () => clickCallback(),
            child: Text("click me"),
            ),

          const Divider(
              color: Colors.brown, height: 10, thickness: 5
              ),
          CategoryMenuPage(),
          const Divider(
              color: Colors.brown, height: 20, thickness: 5
              ),
          SizedBox(
            height: 400,child:  MyApp(),
            ),

        ],
        ),
      );
  }
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'Floating App Bar';

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
              flexibleSpace: Placeholder(),
              // Make the initial height of the SliverAppBar larger than normal.
              expandedHeight: 200,
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
//      MaterialApp(
//      title: title,
//      home: Scaffold(
//        // No appbar provided to the Scaffold, only a body with a
//        // CustomScrollView.
//        body: CustomScrollView(
//          slivers: <Widget>[
//            // Add the app bar to the CustomScrollView.
//            SliverAppBar(
//              // Provide a standard title.
//              title: Text(title),
//                // Allows the user to reveal the app bar if they begin scrolling
//                // back up the list of items.
//                floating: true,
//                // Display a placeholder widget to visualize the shrinking size.
//                flexibleSpace: Placeholder(),
//                // Make the initial height of the SliverAppBar larger than normal.
//                expandedHeight: 200,
//              ),
//            // Next, create a SliverList
//            SliverList(
//              // Use a delegate to build items as they're scrolled on screen.
//              delegate: SliverChildBuilderDelegate(
//                // The builder function returns a ListTile with a title that
//                // displays the index of the current item.
//                (context, index) => ListTile(title: Text('Item #$index')),
//                  // Builds 1000 ListTiles
//                  childCount: 1000,
//                ),
//              ),
//          ],
//          ),
//        ),
//      );
  }
}

class CategoryMenuPage extends StatelessWidget {
  final List<Category> _categories = Category.values;
  final VoidCallback onCategoryTap;

  const CategoryMenuPage({Key key, this.onCategoryTap,}) : super(key: key);

  Widget _buildCategory(Category category, BuildContext context) {
    final categoryString =
    category.toString().replaceAll('Category.', '').toUpperCase();

    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) => GestureDetector(
        onTap: () {
          model.setCategory(category);
          if (onCategoryTap != null)
          {
            onCategoryTap();
            print('category clicked');
          }
        },
        child: model.selectedCategory == category
            ? Column(
          children: <Widget>[
            SizedBox(height: 16.0),
            Text(
              categoryString,
              style: TextStyle(color: Colors.black, fontSize: 20),
              textAlign: TextAlign.center,
              ),
            SizedBox(height: 14.0),
            Container(
              width: 70.0,
              height: 2.0,
              color: Colors.brown,
              ),
          ],
          )
            : Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            categoryString,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            ),
          ),
        ),
      );
  }

  Widget _buildGrid(BuildContext context) {


    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) => GestureDetector(
        onTap: () {

          if (model.selectedCategory == _categories[0])
          {
            model.setCategory(_categories[1]);
            onCategoryTap();
            print('category clicked');
          }
        },
        child:
             SizedBox(
                 height: model.selectedCategory == _categories[0]?30:300,
                 child: ListView(
                          children: _categories.map((c) => _buildCategory(c, context)).toList(),
            ),
          ),

          ),
        );

  }

  @override
  Widget build(BuildContext context) {
    return _buildGrid(context);

  }
}