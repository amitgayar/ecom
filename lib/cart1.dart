
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/services.dart';

import 'model/app_state_model.dart';
//import 'model/product.dart';
import 'model/queryForUI.dart';
import 'services/syncData.dart';




NewAppStateModel newModel = NewAppStateModel();

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

class Cart1 extends StatefulWidget {
  @override
  _Cart1 createState() => _Cart1();
}

class _Cart1 extends State<Cart1> {

  bool bottomBarHide = false;
  void setBottomBarHide(){
    setState(() {
      bottomBarHide = !bottomBarHide;
    });
  }

  bool cashPaymentFlag = false;
  bool creditPaymentFlag = false;
  void cartState(String state){
    setState(() {
      if (state == 'cash'){cashPaymentFlag = !cashPaymentFlag;}
      if (state == 'credit'){creditPaymentFlag = !creditPaymentFlag;}
      print('cartState changed');
    });
  }

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
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      model.clearCart();
                    },
                    ),
                  Spacer(),
                  Card(
//                    width: 189,
                    child: Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      elevation: 18.0,
                      color: Colors.orangeAccent,
                      clipBehavior: Clip.antiAlias, // Add This
                      child: MaterialButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        height: 30.0,
                        child: new Text(formatter.format(model.totalCost),
                                          style: TextStyle(color:Colors.black, fontWeight: FontWeight.bold),),
                        onPressed: () {
                          setBottomBarHide();
                        },
                        ),
                      ),
                    ),

                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.person_add
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
      child: ScopedModelDescendant<NewAppStateModel>(
        builder: (context, child, model) {
          return Column (
            children: _createShoppingCartRows(model),
            );
        },
        ),
      );

    Widget _productDetailHeadingSection = Container(
        height: 50,
        color: Color(0xff429585),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(

            children: <Widget>[
              Text(
                'Product :',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500),
                ),
              Spacer(),
              Text(
                'MRP',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500),
                ),
              Spacer(),
              Text(
                'SP',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500),
                ),
              Spacer(),
              Text(
                'QTY',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500),
                ),
              Spacer(),
              Text(
                'Total',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500),
                ),
            ],
            ),
          )

        );


    return Scaffold(
      body: SafeArea(

        child: ScopedModel<NewAppStateModel>(
          model: newModel,
          child: ScopedModelDescendant<NewAppStateModel>(
              builder: (context, child, model) {
                return  Stack(
                  children: <Widget>[
                    ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
                      children: <Widget>[
                        //
                        const Divider(
                            color: Colors.deepOrangeAccent, height: 5
                            ),

                        //              quickLinkSection,
                        _buildPanel(model),
                        Container(
                          child: Column(
                            children: <Widget>[
                              _productDetailHeadingSection,

//                        const Divider(
//                            color: Colors.deepOrangeAccent, height: 5
//                            ),

                              //              .....................................................Shopping Cart Rows!!!!
                              shoppingCartRowSection,

                              NewShoppingCartSummary(model: model),

                              bottomBarHide != true
                                  ?SizedBox(
                                height: 90,
                                )
                                  :
                              SizedBox(
                                height: cashPaymentFlag
                                ?
                                200
                                :
                                280,
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Divider(color: Colors.grey, height: 10,thickness: 1,),
                                      Container(
                                        color: Colors.deepOrangeAccent,
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.person_add,color: Colors.black,),
                                              onPressed: (){
                                                Navigator.pushNamed(context, '/customers');
                                              },
                                              ),
                                            Text('Select User' ),
                                            Spacer(),
                                            Icon(Icons.report_problem,color: Colors.black,),

                                          ],
                                          ),
                                      ),
                                      Divider(color: Colors.grey, height: 1,thickness: 1,),




                                      !cashPaymentFlag && !creditPaymentFlag
                                      ?
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[

                                                Text('Payment Mode'),
                                                Spacer(),
                                                IconButton(
                                                  icon: Icon(Icons.clear),
                                                  onPressed: (){
                                                    setBottomBarHide();
                                                  },
                                                  )
                                              ],
                                              ),
                                            Row(
                                              children: <Widget>[
                                                RaisedButton(
                                                  child: Text('CASH'),
                                                  onPressed: () {
                                                    cartState('cash');
                                                  },
                                                  ),
                                                Spacer(),
                                                RaisedButton(
                                                  child: Text('CREDIT'),
                                                  onPressed: () {
                                                    setState(() {
                                                cartState('credit');
                                                    });
                                                  },
                                                  ),
                                                Spacer(),
                                                RaisedButton(
                                                  child: Text('DEBIT/CREDIT'),
                                                  onPressed: () {
                                                    setState(() {
//                                                cartState('cash');
                                                      //        Navigator.pushNamed(context, '/cart');
                                                    });
                                                  },
                                                  ),

                                              ],
                                              ),
                                            Row(
                                              children: <Widget>[
                                                RaisedButton(
                                                  child: Text('PAYTM'),
                                                  onPressed: () {
                                                    setState(() {
//                                                cartState('cash');
                                                      //        Navigator.pushNamed(context, '/cart');
                                                    });
                                                  },
                                                  ),
                                                Spacer(),
                                                RaisedButton(
                                                  child: Text('BHIM UPI'),
                                                  onPressed: () {
                                                    setState(() {
//                                                cartState('cash');
                                                      //        Navigator.pushNamed(context, '/cart');
                                                    });
                                                  },
                                                  ),
                                                Spacer(),
                                                RaisedButton(
                                                  child: Text('OTHER'),
                                                  onPressed: () {
                                                    setState(() {
//                                                cartState('cash');
                                                      //        Navigator.pushNamed(context, '/cart');
                                                    });
                                                  },
                                                  ),

                                              ],
                                              ),
                                          ],
                                        ),
                                      )
                                      :
                                      cashPaymentFlag
                                      ?
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[

                                                Text('Cash Mode'),
                                                Spacer(),
                                                IconButton(
                                                  icon: Icon(Icons.clear),
                                                  onPressed: (){
                                                    cartState('cash');
                                                  },
                                                  )
                                              ],
                                              ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.center,

                                                children: <Widget>[
                                                  Text('Cash      =     '+formatter.format(model.totalCost),

                                                       style:TextStyle(fontSize: 20)
                                                       ),

                                                ],
                                                ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                RaisedButton(
                                                  child: Text('PRINT RECEIPT'),
                                                  onPressed: () {
                                                    setState(() {
//                                                cartState('cash');
                                                      //        Navigator.pushNamed(context, '/cart');
                                                    });
                                                  },
                                                  ),
                                                SizedBox(width: 40,),
                                                RaisedButton(
                                                  child: Text('DONE'),
                                                  onPressed: () {
                                                    setState(() {
//                                                cartState('cash');
                                                      //        Navigator.pushNamed(context, '/cart');
                                                    });
                                                  },
                                                  ),


                                              ],
                                              ),
                                          ],
                                          ),
                                        )
                                      :creditPaymentFlag
                                      ?
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[

                                                Text('Credit Mode'),
                                                Spacer(),
                                                IconButton(
                                                  icon: Icon(Icons.clear),
                                                  onPressed: (){
                                                   cartState('credit');
                                                    },
                                                  )
                                              ],
                                              ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text('Amount Paid    ', style:TextStyle(fontSize: 18)),
                                                Spacer(),
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  height: 33,
                                                  width: 100,
                                                  child: TextField(),
                                                )
                                              ],

                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text('Credit     ', style:TextStyle(fontSize: 18)),
                                                Spacer(),
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  height: 33,
                                                  width: 100,
                                                  child: TextField(),
                                                  )
                                              ],

                                              ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                RaisedButton(
                                                  child: Text('PRINT RECEIPT'),
                                                  onPressed: () {
                                                    setState(() {
//                                                cartState('cash');
                                                      //        Navigator.pushNamed(context, '/cart');
                                                    });
                                                  },
                                                  ),
                                                SizedBox(width: 40,),
                                                RaisedButton(
                                                  child: Text('DONE'),
                                                  onPressed: () {
                                                    setState(() {
//                                                cartState('cash');
                                                      //        Navigator.pushNamed(context, '/cart');
                                                    });
                                                  },
                                                  ),


                                              ],
                                              ),
                                          ],
                                          ),
                                        )
                                      :
                                      new Container(),










                                    ],
                                    ),
                                  ),
                                ),

                            ],
                          ),
                        )
                      ],
                      ),

                    bottomBarHide != true
                        ?
                    Align(
                      child: Container(
                        color: Colors.white,
                        child: lastBarSection,
                        ),
                      alignment: Alignment.bottomCenter,)
                        :
                    new Container(),
                  ],
                  );
              }),
          ),
        ),
      );
  }

  List<Widget> _createShoppingCartRows(NewAppStateModel model) {
//    return model.productsInCart.keys
//        .map(
//            (id) => NewShoppingCartRow(id: id)
//            ).toList();


    List<NewShoppingCartRow> newCartListtype2 = [];
    if (model.editableListOfProductsInCart.length > 0) {
      for (var i = 0; i < model.editableListOfProductsInCart.length; i++) {
        newCartListtype2.add(NewShoppingCartRow(id: model.editableListOfProductsInCart[i]['id']));
      }
    }


    //print("Checking what is returned from _createShoppingCartRows : ${newCartListtype2[0].id}");
    return newCartListtype2;


  }
  TextEditingController tc;
  bool _searchBox = true;
  void stoggle(context){
    setState(() {
      _searchBox = !_searchBox;
    });
  }

  Widget _queryBox(NewAppStateModel model) {



    return Container(
      alignment: Alignment.centerLeft,
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                model.selectedCategory != ''
                    ? Row(
                  children: <Widget>[
                    IconButton(

                        icon: Icon(Icons.navigate_before,
                                     size: 15,
                                   ),
                        onPressed: () {
                          goToParentCategory(model);
                        }
                        ),
                    Text(model.selectedCategory+'   ',
                           style: TextStyle(fontSize: 15),
                         ),


                  ],
                  )
                    : new Container(),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      child: SizedBox(
                        height: 40,
                        width: 280,
                        child: TextField(
                          controller: tc,
                          onChanged: (text) async{
                            searchCatalogue(model, text);
                          },
                          decoration: InputDecoration(
                            hintText: 'search',
                            filled: false,
                            prefixIcon: Icon(
                              Icons.search,
                              size: 18.0,
                              ),
                            ),

                          ),
                        ),
                      ),
                    InkWell(
                      // When the user taps the button, show a snackbar.
                      onTap: () {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('add custom item'),
                          ));
                        print('add custom item');
                      },
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          child: Text('+Custom Item'),
                          ),
                      )
                  ],
                  )
              ],
              ),

      ],
        )
        );
  }



  Widget _buildPanel(NewAppStateModel model) {
    return ExpansionPanelList(
      expansionCallback: (int index,bool isExpanded) async{
        model.emptyStack();
        await queryForAll(model, 'initStack', '', '');
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.cloud_download),
                    tooltip: 'getSync',
                    onPressed: () async{
                      getSyncAPI();
                    }
                    ),
                Text(' Quick Links'),
              ],
              );
            },
          body: Column(
            children:  <Widget>[

              _queryBox(newModel),

              NewProductPage(),

            ],
            ),
          isExpanded: item.isExpanded,
          );
      }).toList(),
      );
  }


}


class NewShoppingCartRow extends StatefulWidget {
  NewShoppingCartRow({@required this.id}
      );
  final String id;
  @override
  _NewShoppingCartRow createState() => _NewShoppingCartRow();
}
class _NewShoppingCartRow extends State<NewShoppingCartRow> {



  final myController = TextEditingController();
  @override
  void initState() {
    super.initState();

    myController.addListener(_printTest);
  }
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  _printTest() {
    print("textField of products SP : ${myController.text}");
  }




  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(name: 'INR',
                                                      decimalDigits: 2, locale: Localizations.localeOf(context).toString());
    final localTheme = Theme.of(context);


    return ScopedModelDescendant<NewAppStateModel> (
        builder: (context, child, model) {
          final Map<String, dynamic> product =  model.getProductById(widget.id);
          final int quantity =  model.productsInCart[widget.id];
//          myController.text = '${product['sp'].toString()}';
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              key: ValueKey(product['id'].toString()),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 1.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            Text(
                              product['name'].toString(),
                              style: localTheme.textTheme.subhead
                                  .copyWith(fontWeight: FontWeight.w600),
                              ),
                            Spacer(),
                            Text('${formatter.format(product['sp']*quantity)}'.toString()),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(width: 90.0),

                            Container(
                              width: 40,
                              child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '${product['mrp'].toString()}'
                                    ),
                                ),
                              ),
//                                const SizedBox(width: 30.0),
                            Spacer(),
                            SizedBox(
                              width: 30,
                            ),
                            Container(
                              width: 40,
                              child: new TextField(
                                controller: myController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                onChanged: (text){
//                                            model.changeSP(23.3, 1);
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '${product['sp'].toString()}'
                                    ),
                                ),
                              ),
//                            Spacer(),


//

                            Container(

                              child: Row(
                                children: <Widget>[

                                    IconButton(
                                        iconSize: 15,
                                        icon: const Icon(Icons.remove),
                                        onPressed: ()
                                        {removeItemFromCart(model, product);}
                                        //                        widget.onPressedDelete,
                                        ),
                                  Container(
                                    width: 30,
                                    child: TextField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '$quantity'.toString(),

                                          ),
                                      ),
                                    ),
                                    IconButton(
                                        iconSize: 15,
                                        icon: const Icon(Icons.add),
                                        onPressed: ()
                                        {model.addProductToCart(product['id']);}
                                        ),
                                  ],

                              )
                            ),
                            SizedBox(
                              width: 40,
                            ),


                          ],
                          ),
                        Divider(color: Color(0xff429585),thickness: 1,height: 4,)

                      ],
                      ),
                    ),
                  ),


              ],
              ),
            );
        });
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
              products: model.getProducts(),
              categories: model.getCategories(),
              customProducts: model.getCustomProducts(),


              );
        });
  }
}

class ProductGridView extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> customProducts;

  const ProductGridView({Key key, this.products, this.categories, this.customProducts});

  List<Container> _buildProductCards(BuildContext context) {
    if (products == null || products.isEmpty) {
      return const <Container>[];
    }
    return List.generate(products.length, (index) {
      return Container(
        child: ProductCard(product: products[index]),
        );
    }).toList() ;
  }

  List<Container> _buildCategoryCards(BuildContext context) {
    if (categories == null || categories.isEmpty) {
      return const <Container>[];
    }
    return List.generate(categories.length, (index) {
      return Container(
        child: CategoryCard(category: categories[index]),
        );
    }).toList() ;
  }

  List<Container> _buildCustomProductsCards(BuildContext context) {
    if (customProducts == null || customProducts.isEmpty) {
      print(customProducts);
      return const <Container>[];
    }
    return List.generate(customProducts.length, (index) {
      return Container(
        child: ProductCard(product: customProducts[index]),
        );
    }).toList() ;
  }


  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 160.0,
            child: new GridView.count(
              scrollDirection: Axis.horizontal,
              primary: false,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children:
                  _buildCustomProductsCards(context)
                +
                   _buildCategoryCards(context)
                +
                 _buildProductCards(context) ,

              ),
            ),
          ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      );



  }
}

class ProductCard extends StatelessWidget {
  ProductCard({this.imageAspectRatio = 33 / 49, this.product})
      : assert(imageAspectRatio == null || imageAspectRatio > 0);

  final double imageAspectRatio;
  final Map<String, dynamic> product;


  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(name: 'INR',
                                                                   decimalDigits: 2, locale: Localizations.localeOf(context).toString());
    final ThemeData theme = Theme.of(context);
    return ScopedModelDescendant<NewAppStateModel>(
        builder: (context, child, model) => GestureDetector(
          onTap: () {
            addProductToCart(model, product);
          },
          child: child,
          ),
        child:
        Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: 50.0,
                  width: 221.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        product == null ? '' : product['name'].toString(),
                        style: TextStyle(fontSize: 13),
//                        theme.textTheme.button,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
//                        style: TextStyle(
//                          fontWeight: FontWeight.w800,
//                          fontSize: 15
//
//                        ),
                        ),
//                Spacer(),
                      Text(
                        product == null ? '' : formatter.format(product['sp']),
                        style:
                        theme.textTheme.caption,

                        ),
                    ],
                    ),
                  ),),
            ],
            ),
          color: Color(0xff429585),
          )

        );
  }
}

class CategoryCard extends StatelessWidget {
  CategoryCard({this.imageAspectRatio = 33 / 49, this.category})
      : assert(imageAspectRatio == null || imageAspectRatio > 0);

  final double imageAspectRatio;
  final Map<String, dynamic> category;


  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(name: 'INR',
                                                                   decimalDigits: 2, locale: Localizations.localeOf(context).toString());
    final ThemeData theme = Theme.of(context);

    return ScopedModelDescendant<NewAppStateModel>(
        builder: (context, child, model) => GestureDetector(
          onTap: () {
             onTapCategoryEntry(model, category);
             model.setCategory(category['name']);
          },
          child: child,
          ),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: 50.0,
                  width: 221.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        category == null ? '' : category['name'].toString(),
                        style: theme.textTheme.button,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        ),

                    ],
                    ),
                  ),),
            ],
            ),
          color: Color(0xff429582),
          )
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
//            SizedBox(width: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Switch(
                          value: isGST,
                          onChanged: (bool value) {
                            setState(() {
                              isGST = value;
                              model.setGST(value);
                            });
                          },
                           activeColor: Colors.white,
                          activeTrackColor: Colors.green,

                        ),

//
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
//                    const SizedBox(height: 4.0),

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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Text('TOTAL'),
                          ),
                        Text(
                          formatter.format(model.totalCost),
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