

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

//import 'customer.dart';

//import 'package:intl/intl.dart';


class ProductPage extends StatelessWidget {
  final Category category;

  const ProductPage({this.category = Category.all});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          return ProductGridView(
              products: model.getProducts()

          );
        });
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

class HomeSection extends StatefulWidget {
  @override
  _HomeSection createState() => _HomeSection();
}

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
//  _HomeSection(this.clickCallback, this.tc);
//  final TextEditingController tc;
//  final VoidCallback clickCallback;
//  final TextEditingController _searchController = TextEditingController();




  Widget carts = Padding(
    padding: EdgeInsets.symmetric(vertical: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Card(
          color: Colors.green,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Cart!'),
            ),
          ),
        const SizedBox(width: 45,),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No Item!'),
            ),
          ),
        const SizedBox(width: 45,),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No Item'),
            ),
          )
      ],
      ),
  );
  Widget quickLinkSection = Row(
    children: <Widget>[
      Text('Quick Links     '),
      Expanded(
        child:  Container(
          height: 30,
          child: TextField(
//              controller: grid,
            decoration: const InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),

              ),
            ),
          ),
        ),
      //                  SizedBox(height: 30, width: 40,),
      IconButton(icon: Icon(Icons.keyboard_arrow_up), onPressed:null),
    ],
    );
//  Widget productSection = ProductSection();
  Widget productDetailHeadingSection = SizedBox(
    height: 30,
    child: Text(
      'Product :             MRP             SP             QTY             Total',
      textAlign: TextAlign.left,
      ),
    );

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
      appBar: AppBar(
        title: Text('home section'),
//        backgroundColor: Colors.brown,
      ),
      drawer: Drawer(
        child: CategoryMenuPage(),

      ),
      body: SafeArea(

        child: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          return  ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            children: <Widget>[
              carts,
              const Divider(
                  color: Colors.brown, height: 10, thickness: 5
              ),

              quickLinkSection,
              ProductSection(),
              const Divider(
                  color: Colors.brown, height: 20, thickness: 5
              ),

              productDetailHeadingSection,
              const Divider(
                  color: Colors.brown, height: 10, thickness: 5
              ),

//              .....................................................Shopping Cart Rows!!!!
              shoppingCartRowSection,
              const Divider(
                  color: Colors.brown, height: 10, thickness: 5
              ),
//              .....................................................Last Bar Section!!!
              lastBarSection,


            ],
          );
        }),

      ),
    );
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeSection(),

    );
  }
}


//class CategoryMenuPage extends StatelessWidget {
//  final List<Category> _categories = Category.values;
//  final VoidCallback onCategoryTap;
//
//  const CategoryMenuPage({Key key, this.onCategoryTap,}) : super(key: key);
//
//  Widget _buildCategory(Category category, BuildContext context) {
//    final categoryString =
//    category.toString().replaceAll('Category.', '').toUpperCase();
//
//    return ScopedModelDescendant<AppStateModel>(
//      builder: (context, child, model) => GestureDetector(
//        onTap: () {
//          model.setCategory(category);
//          if (onCategoryTap != null)
//          {
//            onCategoryTap();
//            print('category clicked');
//          }
//        },
//        child: model.selectedCategory == category
//            ? Column(
//          children: <Widget>[
//            SizedBox(height: 16.0),
//            Text(
//              categoryString,
//              style: TextStyle(color: Colors.black, fontSize: 20),
//              textAlign: TextAlign.center,
//              ),
//            SizedBox(height: 14.0),
//            Container(
//              width: 70.0,
//              height: 2.0,
//              color: Colors.brown,
//              ),
//          ],
//          )
//            : Padding(
//          padding: EdgeInsets.symmetric(vertical: 16.0),
//          child: Text(
//            categoryString,
//            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//            textAlign: TextAlign.center,
//            ),
//          ),
//        ),
//      );
//  }
//
//  Widget _buildGrid(BuildContext context) {
//
//
//    return ScopedModelDescendant<AppStateModel>(
//      builder: (context, child, model) => GestureDetector(
//        onTap: () {
//
//          if (model.selectedCategory == _categories[0])
//          {
//            model.setCategory(_categories[1]);
//            onCategoryTap();
//            print('category clicked');
//          }
//        },
//        child:
//        SizedBox(
//          height: model.selectedCategory == _categories[0]?30:300,
//          child: ListView(
//            children: _categories.map((c) => _buildCategory(c, context)).toList(),
//            ),
//          ),
//
//        ),
//      );
//
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return _buildGrid(context);
//
//  }
//}


class ProductSection extends StatelessWidget {
  final List<Category> _categories = Category.values;
  final VoidCallback onCategoryTap;

  const ProductSection({Key key, this.onCategoryTap,}) : super(key: key);


  Widget _buildGrid(BuildContext context) {


    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) => GestureDetector(
        onTap: () {
              model.setToggle();
              print('${model.toggle}');
//          if (model.selectedCategory == _categories[0])
//          {
//            model.setCategory(_categories[1]);
//            onCategoryTap();
//            print('category clicked');
//          }
//          else
//            {
//              model.setCategory(_categories[0]);
//            }
        },
        child: model.toggle
//        model.selectedCategory == _categories[0]
        ?SizedBox(
          height: 30.0,
          )
        :SizedBox(
          height: 280,
          child: Text('grid view testing')
//          ProductPage(),
        )

        ),
      );

  }

  @override
  Widget build(BuildContext context) {
    return _buildGrid(context);

  }
}