
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'category_menu_page.dart';
import 'model/app_state_model.dart';
//import 'model/product.dart';
import 'model/queryForUI.dart';




NewAppStateModel newModel = NewAppStateModel();
class Cart2 extends StatefulWidget {
  @override
  _Cart2 createState() => _Cart2();
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

class _Cart2 extends State<Cart2> {

  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    myController.addListener(_printLatestValue);
  }

  _printLatestValue() {
    print("entered text in sp: ${myController.text}");
  }

  List<Widget> _createShoppingCartRows(NewAppStateModel model) {
    return model.productsInCart.keys
        .map(
          (id) => NewShoppingCartRow(
        product: model.getProductById(id),
        quantity: model.productsInCart[id],
        onPressedDelete: () {
          model.removeItemFromCart(id);
        },
        onPressedAdd:  () {
          model.addItemToCart(id);
        },
        onChangeSP: (){
            model.changeSP(1.0, id)  ;
        },

        ),
          )
        .toList();
  }

  TextEditingController tc;
  Widget _queryBox(NewAppStateModel model) {
    return Column(
      children: <Widget>[

        TextField(
          controller: tc,
          onChanged: (text) async{
            //          getSyncAPI();
            if (text.length < 30) {
              queryForUI('productCategories', 'id', '<', text);
              print("First text field: ${text.length}");
              var allProducts = await model.queryForUI('products', '', '', '');

              print(allProducts);
            }
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
                  onPressed: () async{
//          clickCallback();
                      var allProducts = await model.queryForUI('products', '', '', '');
                      model.loadProducts(allProducts);
                      print(model.getProducts());
                      print(allProducts);
//                  List<Map<String, dynamic>>  allProducts = model.dbProducts;
//                Future<List<Map<String, dynamic>>> allCategories =  queryForUI('productCategories', '', '', '');
//                Future<List<Map<String, dynamic>>> allCustomProducts =  queryForUI('customProducts', '', '', '');


                 print('success');
//                print(allCategories);
//                print(allCustomProducts);
              },
                  ),
              ),
          ),


      ],
      );
  }



  Widget quickLinkSection = Text('  Quick Links     ');
  Widget productDetailHeadingSection = SizedBox(
    height: 30,
    child: Text(
      'Product :             MRP             SP             QTY             Total',
      textAlign: TextAlign.left,
      ),
    );

  Widget _buildPanel(NewAppStateModel model) {

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
              _queryBox(newModel),
              NewProductPage(),
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
    final formatter = NumberFormat.simpleCurrency(name: 'INR', decimalDigits: 2,
                                                      locale: Localizations.localeOf(context).toString());
    var lastBarSection = Container(
        height: 60,
        width: 500,
        child: ScopedModelDescendant<NewAppStateModel>(
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
                      child: Text(formatter.format(model.totalCost),
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
        child: ScopedModelDescendant<NewAppStateModel>(
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

        child: ScopedModel<NewAppStateModel>(
          model: newModel,
          child: ScopedModelDescendant<NewAppStateModel>(
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
                        _buildPanel(model),

                        const Divider(
                            color: Colors.brown, height: 20, thickness: 5
                            ),

                        productDetailHeadingSection,
                        const Divider(
                            color: Colors.brown, height: 10, thickness: 5
                            ),

//              .....................................................Shopping Cart Rows!!!!
                        shoppingCartRowSection,
                        NewShoppingCartSummary(model: model),


//


                      ],
                      ),
                    Align(child: SizedBox(
                      height: 70,
                      width: 500,
                      child: Column(
                        children: <Widget>[

//              .....................................................Last Bar Section!!!
                        Card(
                          child: lastBarSection,
                        ),

                        ],
                        ),
                      ),
                            alignment: Alignment.bottomCenter,),
                  ],
                  );
              }),
          ),



        ),
      );
  }
}



class NewShoppingCartRow extends StatelessWidget {
  NewShoppingCartRow({@required this.product, @required this.quantity, this.onPressedDelete,
    this.onPressedAdd, this.onChangeSP,
      this.tc}
      );

  final Map<String, dynamic> product;
  final int quantity;
  final VoidCallback onPressedDelete;
  final VoidCallback onPressedAdd;
  final VoidCallback onChangeSP;
  final TextEditingController tc;


  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(
        decimalDigits: 0, locale: Localizations.localeOf(context).toString());
    final localTheme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        key: ValueKey(product['id'].toString()),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'].toString(),
                              style: localTheme.textTheme.subhead
                                  .copyWith(fontWeight: FontWeight.w600),
                              ),
                            Row(
                              children: [
                                const SizedBox(width: 80.0),
                                Container(
                                  width: 30,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '${product['mrp'].toString()}'
                                        ),
                                    ),
                                  ),
                                const SizedBox(width: 40.0),
                                Container(
                                  width: 30,
                                  child: TextField(
                                    controller: tc,
                                    onChanged: (text){
                                      newModel.changeSP(23.3, 1);
                                    },
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '${product['sp'].toString()}'
                                        ),
                                    ),
                                  ),
                                const SizedBox(width: 50.0),
                                Container(
                                  width: 30,
                                  child: Text('$quantity'.toString()),
                                  ),
                                const SizedBox(width: 30.0),
                                Text('${formatter.format(product['sp']*quantity)}'.toString()),
                              ],
                              ),

                          ],
                          ),
                        ),
                    ],
                    ),
                  const SizedBox(height: 16.0),
                  const Divider(
                    color: Colors.brown,
                    height: 10.0,
                    ),
                ],
                ),
              ),
            ),
          Column(
            children: <Widget>[
              IconButton(
                iconSize: 15,
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: onPressedDelete,
                ),
              IconButton(
                iconSize: 15,
                icon: const Icon(Icons.add_circle_outline),
                onPressed: onPressedAdd,
                ),
            ],
          ),
        ],
        ),
      );
  }
}

class NewProductPage extends StatelessWidget {
//  final Category category;
//  const ProductPage({this.category = Category.all});
  @override
  Widget build(BuildContext context) {
//    _print(category, msg:'category in product_grid_view.dart');
    return ScopedModelDescendant<NewAppStateModel> (
        builder: (context, child, model) {

          return ProductGridView(
              products: model.getProducts()

              );
        });
  }
}

class ProductGridView extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const ProductGridView({Key key, this.products});

  List<Container> _buildRows(BuildContext context) {
    if (products == null || products.isEmpty) {
      return const <Container>[];

    }
    else{
      print(products[0]["id"]);
    }


    return List.generate(products.length, (index) {

      return Container(
//        width: 100,
                      child:
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: ProductCard(product: products[index]),
                        ),
                      );
                          }).toList();
                        }


  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 200.0,
            child: new GridView.count(
              scrollDirection: Axis.horizontal,
              primary: false,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: _buildRows(context),
              ),
            ),
          ),

      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      );



  }
}

class ProductCard extends StatelessWidget {
  ProductCard({this.imageAspectRatio = 33 / 49, this.product})
      : assert(imageAspectRatio == null || imageAspectRatio > 0);

  final double imageAspectRatio;
  final Map<String, dynamic> product;

  static final kTextBoxHeight = 65.0;

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        decimalDigits: 0, locale: Localizations.localeOf(context).toString());
    final ThemeData theme = Theme.of(context);

    return ScopedModelDescendant<NewAppStateModel>(
      builder: (context, child, model) => GestureDetector(
        onTap: () {
          model.addProductToCart(product['id']);
        },
        child: child,
        ),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50.0,
                width: 121.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      product == null ? '' : product['name'].toString(),
                      style: theme.textTheme.button,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      ),
                    SizedBox(height: 4.0),
                    Text(
                        product == null ? '' : product['sp'].toString(),
                      //style: theme.textTheme.caption,
                      ),
                  ],
                  ),
                ),
            ],
            ),

        ],
        ),
      );
  }
}


class NewShoppingCartSummary extends StatefulWidget {
  NewShoppingCartSummary({this.model});
  final NewAppStateModel model;

  @override
  _ShoppingCartSummary createState() => _ShoppingCartSummary();
}

class _ShoppingCartSummary extends State<NewShoppingCartSummary> {
//   AppStateModel model;
//   _ShoppingCartSummary({this.model});

  bool isGST = false;
  @override
  Widget build(BuildContext context) {
    final smallAmountStyle =
    Theme.of(context).textTheme.body1.copyWith(color: Colors.black);
    final largeAmountStyle = Theme.of(context).textTheme.display1;
    final formatter = NumberFormat.simpleCurrency(name: 'INR',
        decimalDigits: 2, locale: Localizations.localeOf(context).toString());

    return ScopedModelDescendant<NewAppStateModel>(
      builder: (context, child, model) {
        return Row(
          children: [
            SizedBox(width: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        new Checkbox(
                          value: isGST,
                          onChanged: (bool value) {
                            setState(() {
                              isGST = value;

                              model.setGST(value);

                            });
                          },
                          activeColor: Colors.black,
                          ),
                        const Expanded(
                            child: Text('GST')
                            //                          SizedBox(height: 1,),
                            ),
                        Text(
                          model.gst.toString(),
                          style: smallAmountStyle,
                          ),
                      ],
                      ),
                    const SizedBox(height: 2.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Text('TOTAL'),
                          ),
                        Text(
                          formatter.format(model.totalCost),
                          style: largeAmountStyle,
                          ),
                      ],
                      ),
                    const SizedBox(height: 6.0),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Subtotal:'),
                          ),
                        Text(
                          formatter.format(model.subtotalCost),
                          style: smallAmountStyle,
                          ),
                      ],
                      ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Shipping:'),
                          ),
                        Text(
                          formatter.format(model.shippingCost),
                          style: smallAmountStyle,
                          ),
                      ],
                      ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Tax:'),
                          ),
                        Text(
                          formatter.format(model.tax),
                          style: smallAmountStyle,
                          ),
                      ],
                      ),
                  ],
                  ),
                ),
              ),
          ],
          );
      },
      );
  }
}