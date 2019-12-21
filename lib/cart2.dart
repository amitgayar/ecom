
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/services.dart';

import 'model/app_state_model.dart';
//import 'model/product.dart';
import 'model/queryForUI.dart';
import 'services/syncData.dart';




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

//
//
//  List<Widget> _createShoppingCartRows(NewAppStateModel model) {
//    return model.productsInCart.keys
//        .map(
//          (id) => NewShoppingCartRow(id: id)
//          ).toList();
//  }

//  TextEditingController tc;
//  Widget _queryBox(NewAppStateModel model) {
//    return TextField(
//      controller: tc,
//      onChanged: (text) async{
//        if (text.length > 3) {
////          var allProducts = await q('initSearch', '', text);
//          var allProducts = await q('secondSearch', '5', 'cold drink');
//          print(allProducts);
//          model.loadProducts(allProducts);
//
//        }
//      },
//      decoration: InputDecoration(
//        hintText: 'search',
//        filled: true,
////                prefixIcon: Icon(
////                  Icons.account_box,
////                  size: 18.0,
////                  ),
//        suffixIcon: IconButton(
//          icon: Icon(Icons.add),
//          onPressed: () async{
////                    getSyncAPI();
////          clickCallback();
//            var allProducts = await q('initStack', '', '');
//            print(allProducts);
//            model.loadProducts(allProducts);
//          },
//          ),
//        ),
//      );
//  }
//
//
//
//  Widget quickLinkSection = Text('  Quick Links     ');
//  Widget productDetailHeadingSection = SizedBox(
//    height: 30,
//    child: Text(
//      'Product :      MRP             SP             QTY             Total',
//      textAlign: TextAlign.left,
//      style: TextStyle(fontWeight: FontWeight.w500),
//      ),
//    );
//
//  Widget _buildPanel(NewAppStateModel model) {
//    return ExpansionPanelList(
//      expansionCallback: (int index,bool isExpanded) {
//        setState(() {
//          _data[index].isExpanded = !isExpanded;
//        });
//      },
//      children: _data.map<ExpansionPanel>((Item item) {
//        return ExpansionPanel(
//          headerBuilder: (BuildContext context, bool isExpanded) {
//            return
//              quickLinkSection
//            ;},
//          body: Column(
//            children: <Widget>[
//              _queryBox(newModel),
//              NewProductPage(),
//
//            ],
//            ),
//          isExpanded: item.isExpanded,
//          );
//      }).toList(),
//      );
//  }
//



  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(name: 'INR', decimalDigits: 2,
                                                      locale: Localizations.localeOf(context).toString());
    var lastBarSection = Container(
        height: 70,
        width: 400,
        child: ScopedModelDescendant<NewAppStateModel>(
            builder: (context, child, model) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      model.clearCart();


                    },
                  ),
                  SizedBox(width: 40,),
                  RaisedButton(
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(1.0)),
                      ),
                    color: Colors.deepOrange,
                    child: Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Text(formatter.format(model.totalCost),
                                    style: TextStyle(color:Colors.black, fontWeight: FontWeight.bold),),
                      ),
                    onPressed: () {
//                      Navigator.pushNamed(context, '/cart');
                    },
                    ),


                  SizedBox(width: 40,),
                  IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () {
                      Navigator.pushNamed(context, '/customer');

                    },
                  ),
                ],
                );
            })

        );

//
//    var shoppingCartRowSection = Container(
//      child: ScopedModelDescendant<NewAppStateModel>(
//        builder: (context, child, model) {
//          return Column (
//            children: _createShoppingCartRows(model),
//            );
//        },
//        ),
//      );
//



    return new Container();
//      Scaffold(
//
//      drawer: Drawer(
//        child: CategoryMenuPage(),
//
//        ),
//      body: SafeArea(
//
//        child: ScopedModel<NewAppStateModel>(
//          model: newModel,
//          child: ScopedModelDescendant<NewAppStateModel>(
//              builder: (context, child, model) {
//                return  Stack(
//                  children: <Widget>[
//                    ListView(
////                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                      children: <Widget>[
////
//                          const Divider(
//                  color: Colors.deepOrangeAccent, height: 5
//              ),
//
////              quickLinkSection,
//                        _buildPanel(model),
//
//                        const Divider(
//                            color: Colors.deepOrangeAccent, height: 5
//                            ),
//
//                        productDetailHeadingSection,
//                        const Divider(
//                            color: Colors.deepOrangeAccent, height: 5
//                            ),
//
////              .....................................................Shopping Cart Rows!!!!
//                        shoppingCartRowSection,
//                        NewShoppingCartSummary(model: model),
//
//
////
//
//
//                      ],
//                      ),
//                    Align(child: SizedBox(
//                      height: 70,
//                      width: 400,
//                      child: Card(
//                        child: lastBarSection,
//                        ),
//                      ),
//                            alignment: Alignment.bottomCenter,),
//                  ],
//                  );
//              }),
//          ),
//
//
//
//        ),
//      );
  }
}

//
//class NewShoppingCartRow extends StatefulWidget {
//  NewShoppingCartRow({@required this.id}
//      );
//
//  final int id;
//
//  @override
//  _NewShoppingCartRow createState() => _NewShoppingCartRow();
//}
//class _NewShoppingCartRow extends State<NewShoppingCartRow> {
//
//
//
//  final myController = TextEditingController();
//  @override
//  void initState() {
//    super.initState();
//
//    myController.addListener(_printTest);
//  }
//  @override
//  void dispose() {
//    myController.dispose();
//    super.dispose();
//  }
//
//  _printTest() {
//    print("textField of products SP : ${myController.text}");
//  }
//
//
//
//
//  @override
//  Widget build(BuildContext context) {
//    final formatter = NumberFormat.simpleCurrency(name: 'INR',
//        decimalDigits: 2, locale: Localizations.localeOf(context).toString());
//    final localTheme = Theme.of(context);
//
//
//    return ScopedModelDescendant<NewAppStateModel> (
//        builder: (context, child, model) {
//          final Map<String, dynamic> product =  model.getProductById(widget.id);
//          final int quantity =  model.productsInCart[widget.id];
////          myController.text = '${product['sp'].toString()}';
//          return Padding(
//            padding: const EdgeInsets.only(bottom: 6.0),
//            child: Row(
//              key: ValueKey(product['id'].toString()),
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: [
//                Expanded(
//                  child: Padding(
//                    padding: const EdgeInsets.only(right: 16.0),
//                    child: Column(
//                      children: [
//                        Row(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: [
//
//                      const SizedBox(width: 16.0),
//                            Expanded(
//                              child: Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: [
//                                  Text(
//                                    product['name'].toString(),
//                                    style: localTheme.textTheme.subhead
//                                        .copyWith(fontWeight: FontWeight.w600),
//                                    ),
//                                  Row(
//                                    crossAxisAlignment: CrossAxisAlignment.start,
//                                    children: [
//                                      const SizedBox(width: 40.0),
//
//                                      Container(
//                                        width: 60,
//                                        child: TextField(
//                                          decoration: InputDecoration(
//                                              border: InputBorder.none,
//                                              hintText: '${product['mrp'].toString()}'
//                                              ),
//                                          ),
//                                        ),
////                                const SizedBox(width: 30.0),
//                                      Spacer(),
//                                      Container(
//                                        width: 50,
//                                        child: new TextField(
//                                          controller: myController,
//                                          keyboardType: TextInputType.number,
//                                          inputFormatters: <TextInputFormatter>[
//                                            WhitelistingTextInputFormatter.digitsOnly
//                                          ],
//                                          onChanged: (text){
////                                            model.changeSP(23.3, 1);
//                                          },
//                                          decoration: InputDecoration(
//                                              border: InputBorder.none,
//                                              hintText: '${product['sp'].toString()}'
//                                              ),
//                                          ),
//                                        ),
//                                      Spacer(),
//                                      Container(
//                                        width: 35,
//                                        child: Text('$quantity'.toString()),
//                                        ),
//                                      Spacer(),
//                                      Text('${formatter.format(product['sp']*quantity)}'.toString()),
//                                    ],
//                                    ),
//
//                                ],
//                                ),
//                              ),
//                          ],
//                          ),
//                        const SizedBox(height: 16.0),
//                        const Divider(
//                            color: Colors.deepOrangeAccent, height: 5
//                            ),
//                      ],
//                      ),
//                    ),
//                  ),
//                Padding(
//                  padding: const EdgeInsets.symmetric(vertical: 1),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//
//                    children: <Widget>[
//                      IconButton(
//                        iconSize: 15,
//                        icon: const Icon(Icons.remove_circle_outline),
//                        onPressed: ()
//                      {removeItemFromCart(model, product);}
////                        widget.onPressedDelete,
//                        ),
//                      IconButton(
//                        iconSize: 15,
//                        icon: const Icon(Icons.add_circle_outline),
//                        onPressed: ()
//                        {addProductToCart(model, product);}
//                        ),
//                    ],
//                    ),
//                  ),
//
//              ],
//              ),
//            );
//        });
//  }
//}
//
//class NewProductPage extends StatelessWidget {
////  final Category category;
////  const ProductPage({this.category = Category.all});
//  @override
//  Widget build(BuildContext context) {
////    _print(category, msg:'category in product_grid_view.dart');
//    return ScopedModelDescendant<NewAppStateModel> (
//        builder: (context, child, model) {
//
//          return ProductGridView(
//              products: getProducts(model)
//
//              );
//        });
//  }
//}
//
//class ProductGridView extends StatelessWidget {
//  final List<Map<String, dynamic>> products;
//
//  const ProductGridView({Key key, this.products});
//
//  List<Container> _buildRows(BuildContext context) {
//    if (products == null || products.isEmpty) {
//      return const <Container>[];
//    }
//    return List.generate(products.length, (index) {
//      return Container(
//                      child: ProductCard(product: products[index]),
//                      );
//                          }).toList();
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    return new Row(
//      children: <Widget>[
//        Expanded(
//          child: SizedBox(
//            height: 150.0,
//            child: new GridView.count(
//              scrollDirection: Axis.horizontal,
//              primary: false,
////              padding: const EdgeInsets.all(10),
//              crossAxisSpacing: 10,
//              mainAxisSpacing: 10,
//              crossAxisCount: 2,
//              children: _buildRows(context),
//              ),
//            ),
//          ),
//      ],
//      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//      );
//
//
//
//  }
//}
//
//class ProductCard extends StatelessWidget {
//  ProductCard({this.imageAspectRatio = 33 / 49, this.product})
//      : assert(imageAspectRatio == null || imageAspectRatio > 0);
//
//  final double imageAspectRatio;
//  final Map<String, dynamic> product;
//
//  static final kTextBoxHeight = 65.0;
//
//  @override
//  Widget build(BuildContext context) {
//    final NumberFormat formatter = NumberFormat.simpleCurrency(name: 'INR',
//        decimalDigits: 2, locale: Localizations.localeOf(context).toString());
//    final ThemeData theme = Theme.of(context);
//    return ScopedModelDescendant<NewAppStateModel>(
//      builder: (context, child, model) => GestureDetector(
//        onTap: () {
//          addProductToCart(model, product);
//        },
//        child: child,
//        ),
//      child:
//      Card(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            Expanded(
//              child: SizedBox(
//                height: 50.0,
//                width: 221.0,
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Text(
//                      product == null ? '' : product['name'].toString(),
//                      style: theme.textTheme.button,
//                      softWrap: false,
//                      overflow: TextOverflow.ellipsis,
//                      maxLines: 2,
//                      ),
////                Spacer(),
//                    Text(
//                      product == null ? '' : formatter.format(product['sp']),
//                      style: theme.textTheme.caption,
//                      ),
//                  ],
//                  ),
//                ),),
//          ],
//          ),
//          color: Colors.blueGrey,
//      )
//
//      );
//  }
//}
//
//class CategoryCard extends StatelessWidget {
//  CategoryCard({this.imageAspectRatio = 33 / 49, this.category})
//      : assert(imageAspectRatio == null || imageAspectRatio > 0);
//
//  final double imageAspectRatio;
//  final Map<String, dynamic> category;
//
//  static final kTextBoxHeight = 65.0;
//
//  @override
//  Widget build(BuildContext context) {
//    final NumberFormat formatter = NumberFormat.simpleCurrency(name: 'INR',
//                                                                   decimalDigits: 2, locale: Localizations.localeOf(context).toString());
//    final ThemeData theme = Theme.of(context);
//
//    return ScopedModelDescendant<NewAppStateModel>(
//        builder: (context, child, model) => GestureDetector(
//          onTap: () {
//
//          },
//          child: child,
//          ),
//        child: Card(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              Expanded(
//                child: SizedBox(
//                  height: 50.0,
//                  width: 221.0,
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: <Widget>[
//                      Text(
//                        category == null ? '' : category['name'].toString(),
//                        style: theme.textTheme.button,
//                        softWrap: false,
//                        overflow: TextOverflow.ellipsis,
//                        maxLines: 2,
//                        ),
//
//                    ],
//                    ),
//                  ),),
//            ],
//            ),
//          color: Colors.blueGrey,
//          )
//        );
//  }
//}
//
//
//class NewShoppingCartSummary extends StatefulWidget {
//  NewShoppingCartSummary({this.model});
//  final NewAppStateModel model;
//
//  @override
//  _ShoppingCartSummary createState() => _ShoppingCartSummary();
//}
//
//class _ShoppingCartSummary extends State<NewShoppingCartSummary> {
////   AppStateModel model;
////   _ShoppingCartSummary({this.model});
//
//  bool isGST = false;
//  @override
//  Widget build(BuildContext context) {
//    final smallAmountStyle =
//    Theme.of(context).textTheme.body1.copyWith(color: Colors.black);
//    final largeAmountStyle = Theme.of(context).textTheme.display1;
//    final formatter = NumberFormat.simpleCurrency(name: 'INR',
//        decimalDigits: 2, locale: Localizations.localeOf(context).toString());
//
//    return ScopedModelDescendant<NewAppStateModel>(
//      builder: (context, child, model) {
//        return Row(
//          children: [
//            SizedBox(width: 30),
//            Expanded(
//              child: Padding(
//                padding: const EdgeInsets.only(right: 16.0),
//                child: Column(
//                  children: [
//                    Row(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: [
//
//                        new Checkbox(
//                          value: isGST,
//                          onChanged: (bool value) {
//                            setState(() {
//                              isGST = value;
//
//                              model.setGST(value);
//
//                            });
//                          },
//                          activeColor: Colors.black,
//                          ),
//                        const Expanded(
//                            child: Text('GST')
//                            //                          SizedBox(height: 1,),
//                            ),
//                        Text(
//                          model.gst.toString(),
//                          style: smallAmountStyle,
//                          ),
//                      ],
//                      ),
//                    const SizedBox(height: 2.0),
//                    Row(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: [
//                        const Expanded(
//                          child: Text('TOTAL'),
//                          ),
//                        Text(
//                          formatter.format(model.totalCost),
//                          style: smallAmountStyle,
//                          ),
//                      ],
//                      ),
//                    const SizedBox(height: 6.0),
//                    Row(
//                      children: [
//                        const Expanded(
//                          child: Text('Subtotal:'),
//                          ),
//                        Text(
//                          formatter.format(model.subtotalCost),
//                          style: smallAmountStyle,
//                          ),
//                      ],
//                      ),
//                    const SizedBox(height: 4.0),
//                    Row(
//                      children: [
//                        const Expanded(
//                          child: Text('Shipping:'),
//                          ),
//                        Text(
//                          formatter.format(model.shippingCost),
//                          style: smallAmountStyle,
//                          ),
//                      ],
//                      ),
//                    const SizedBox(height: 4.0),
//                    Row(
//                      children: [
//                        const Expanded(
//                          child: Text('Tax:'),
//                          ),
//                        Text(
//                          formatter.format(model.tax),
//                          style: smallAmountStyle,
//                          ),
//                      ],
//                      ),
//                  ],
//                  ),
//                ),
//              ),
//          ],
//          );
//      },
//      );
//  }
//}