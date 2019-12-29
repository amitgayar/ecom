import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:express_store/model/app_state_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/services.dart';
//import '../model/app_state_model.dart';
import '../model/queryForUI.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';



NewAppStateModel requestStocksModel = new NewAppStateModel();




class RequestStocks extends StatefulWidget {
  @override
  _RequestStocks createState() => _RequestStocks();
}

class _RequestStocks extends State<RequestStocks> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(

        child: ScopedModel<NewAppStateModel>(
          model: requestStocksModel,
          child: RequestStocksDescendant(),
          ),
        ),
      );
  }

}



class RequestStocksDescendant extends StatefulWidget {

  @override
  _RequestStocksDescendant createState() => _RequestStocksDescendant ();
}


class _RequestStocksDescendant extends State<RequestStocksDescendant> {

//class RequestStocksDescendant extends StatelessWidget {

bool barSelection = false;
bool acceptStocks = false;
bool acceptRequestTile = false;
bool requestHistoryTile = false;
bool requestNewStocks = false;
bool requestSent = false;

final List<Map<String, dynamic >> productList = [{
  'name': 'product_name',
  'sp': '30',
  'mrp': '90',
  'qty': '9',
  'total' : '810'
},
  {
    'name': 'product_name2',
    'sp': '90',
    'mrp': '90',
    'qty': '3',
    'total' : '810'
  }
];

final List<Map<String, dynamic >> productListSentPage = [{
  'name': 'product_name',
  'sp': '30',
  'mrp': '90',
  'qty': '9',
  'total' : '810'
},
  {
    'name': 'product_name2',
    'sp': '90',
    'mrp': '90',
    'qty': '3',
    'total' : '810'
  }
];
final List<Map<String, dynamic >> productListRequestNewStockPage = [{
  'name': 'product_name',
  'sp': '30',
  'mrp': '90',
  'qty': '9',
  'total' : '810'
},
  {
    'name': 'product_name2',
    'sp': '90',
    'mrp': '90',
    'qty': '3',
    'total' : '810'
  }
];


List<Container> buildRows(BuildContext context, List<Map<String, dynamic >> productList) {
  return List.generate(productList.length, (index){
    return Container(
      child: StockRow(product: productList[index]),
      );
  }).toList();
}

List<Container> buildEditableRows(BuildContext context, List<Map<String, dynamic >> productList) {
  return List.generate(productList.length, (index){
    return Container(
      child: StockRowEditable(product: productList[index]),
      );
  }).toList();
}

List<Container> buildRowsSentPage(BuildContext context, List<Map<String, dynamic >> productList) {
  return List.generate(productList.length, (index){
    return Container(
      child: StockRowSentPage(product: productList[index]),
      );
  }).toList();
}

List<Container> buildRowsNewStockPage(BuildContext context, List<Map<String, dynamic >> productList) {
  return List.generate(productList.length, (index){
    return Container(
      child: StockRowNewStockEditable(product: productList[index]),
      );
  }).toList();
}

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NewAppStateModel> (
        builder: (context, child, model) {

          return SafeArea(
            child: Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Container(
                      height: 40,
                    ),

                    Container(
                        color: Colors.green,
                        child: RaisedButton(
                          child: Text('Request New Stocks'),
                          onPressed: (){
                            setState(() {
                              requestNewStocks = true;
                            });
                          },
                          )

                        ),
                    Divider(color: Colors.black,thickness: 1,),
                    Row(
                      children: <Widget>[
                        RaisedButton(
                          color: !barSelection?Colors.green:Colors.black12,
                          child: Text('Accept Request'),
                          onPressed: (){
                            setState(() {
                              barSelection = false;
                            });
                          },
                        ),
                        Spacer(),
                        RaisedButton(
                          color: barSelection?Colors.green:Colors.black12,
                          child: Text('Request History'),
                          onPressed: (){
                           setState(() {
                             barSelection = true;
                           });
                          },
                          ),
                      ],
                    ),

                    Divider(color: Colors.black,thickness: 1,),
                    !barSelection?
                    ListTile(
                      onTap: (){
                        setState(() {
                          acceptRequestTile = true;
                        });
                      },
                      title: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('Request Time : <DAte??>'),
                              Spacer(),
                              Text('Status : <???>'),

                            ],
                            ),
                          Row(
                            children: <Widget>[
                              Text('?? Items'),
                              Spacer(),
                              Text('Total Amount : ???'),
                            ],
                            ),
                        ],
                      ),
                    )
                    :
                    ListTile(
                      onTap: (){
                        setState(() {
                          requestSent = true;
                        });
                      },
                      title: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('History Request Time : <DAte??>'),
                              Spacer(),
                              Text('Status : <???>'),

                            ],
                            ),
                          Row(
                            children: <Widget>[
                              Text('?? Items'),
                              Spacer(),
                              Text('Total Amount : ???'),
                            ],
                            ),
                        ],
                        ),
                      ),
                    Divider(color: Colors.black,thickness: 1,),


                  ],
                  ),
                acceptRequestTile?
                Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: ListView(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: (){
                                setState(() {
                                  acceptRequestTile = false;
                                });
                              },
                            ),
                            Text('Accept Stocks'),
                            Container(
                              height: 40,
                              ),
                            Container(
                                height: 40,
                                color:
//          Color(0xffe48181),
                                Color(0xff68d8c2),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(

                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          'Product',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                        flex: 6,
                                        ),
                                      Expanded(
                                        child: Text(
                                          'QTY',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                        flex: 3,
                                        ),
                                      Expanded(
                                        child: Text(
                                          'Unit Price',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                        flex: 3,
                                        ),

                                    ],
                                    ),
                                  )

                                ),

                            Column(
                                children:
                                buildEditableRows(context, productList)

                                ),
                            Divider(color: Colors.black,thickness: 1,),
                            Text('Total Amount  :  <amount in accept stocks>'),
                            RaisedButton(
                              child: Text('Accept Stocks'),
                              onPressed: (){
                                setState(() {
                                  acceptStocks = true;
                                });
                              },
                              )
                          ],
                          ),
                        ),

                      acceptStocks?
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          color: Colors.white,
                          child: Container(
                            child: ListView(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: (){
                                    setState(() {
                                      acceptStocks = false;
                                      acceptRequestTile = false;
                                    });
                                  },
                                ),
                                Text('Stocks Accepted'),
                                Text('Stocks Added to your inventory!'),
                                Container(
                                  height: 40,
                                  ),
                                Container(
                                    height: 40,
                                    color:
//          Color(0xffe48181),
                                    Color(0xff68d8c2),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(

                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              'Product',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontWeight: FontWeight.w500),
                                              ),
                                            flex: 6,
                                            ),
                                          Expanded(
                                            child: Text(
                                              'QTY',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontWeight: FontWeight.w500),
                                              ),
                                            flex: 3,
                                            ),
                                          Expanded(
                                            child: Text(
                                              'Unit Price',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontWeight: FontWeight.w500),
                                              ),
                                            flex: 3,
                                            ),

                                        ],
                                        ),
                                      )

                                    ),

                                Column(
                                  children:
                                    buildRows(context, productList)

                                ),
                                ListTile(
                                  title: Column(
                                    children: <Widget>[
                                      Text("Total : <total in stocks added page>"),
                                      Text("Order Time : <order time in stocks added page>"),
                                      Text("Accepted Time : <time in stocks added page>>"),
                                    ],
                                  ),
                                )

                              ],
                            ),
                          ),

                        ),
                      )
                          :
                          new Container(),
                    ],
                  )
                )
                    :
                    new Container(),

                requestNewStocks?
                    Container(
                      color:Colors.white,
                      child: ListView(
                        children: <Widget>[
                          QuickLinks(),
                          Container(
                              height: 40,
                              color:
//          Color(0xffe48181),
                              Color(0xff68d8c2),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(

                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        'Product',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      flex: 6,
                                      ),
                                    Expanded(
                                      child: Text(
                                        'QTY',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      flex: 3,
                                      ),

                                  ],
                                  ),
                                )

                              ),
                         Container(
                           child: Column(
                             children:  buildRowsNewStockPage(context, productListRequestNewStockPage)
                           ),
                         ),
                          RaisedButton(
                            color: Colors.green,
                            child: Text('Request Stocks'),
                            onPressed: (){
                              setState(() {
                                requestSent = true;
                              });
                            },
                          )

                        ],
                      ),
                    )
                    :
                new Container(),
                requestSent?
                Container(
                  color: Colors.white,
                  child: ListView(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: (){
                          setState(() {
                            requestSent = false;
                            requestNewStocks = false;
                          });
                        },
                        ),
                      Text('Request Stocks'),
                      Text('<DATE TIME kokok>'),
                      Divider(color: Colors.black,thickness: 1,),
                      Column(
                        children: buildRowsSentPage(context, productListSentPage),
                      ),

                      Divider(color: Colors.black,thickness: 1,),
                      RaisedButton(
                        child: Text('Cancel Request'),
                        color: Colors.red,
                        onPressed: (){
                          setState(() {
                            requestSent = false;
                            requestNewStocks = false;
                          });
                        },
                      )
                    ],
                  ),
                )
                    :
                new Container(),



              ],
              ),
          );
        }
    );




  }
}





class Item {
  Item({
    this.isExpanded = false,
  });
  bool isExpanded;
}
List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
);
  });
}
List<Item> _data = generateItems(1);
class QuickLinks extends StatefulWidget {
  _QuickLinks createState() => _QuickLinks();
}

class _QuickLinks extends State<QuickLinks> {
  TextEditingController tc;
  @override
  Widget build(BuildContext context) {


    Widget _queryBox(NewAppStateModel model) {

      return Container(
          color: Colors.white,
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
                      SizedBox(
                        width: 1,
                        ),
                      OutlineButton(
                          color: Colors.white,
                          child: Container(
                            child: Row(children: <Widget>[
                              Icon(Icons.add,
                                       size: 14),
                              Text('Custom Item'),
                            ],
                                       ),
                            ),
                          onPressed: (){
                            model.getListOfCategories();
                            model.getListOfBrands();
                            setState(() {
                              model.updateFlagOfAddCustomItem(true);
                            });

                          },
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
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
              return Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('Quick Links',
                                style: TextStyle(
//                                      fontWeight: FontWeight.bold,
fontSize: 16,color: Colors.black
)
                            ),
                );
            },
            body: Container(
//            height: 300,
//            width: 100,
child:Column(
  children:  <Widget>[
    _queryBox(model),
    NewProductPage(),
  ],
  )
),
            isExpanded: item.isExpanded,
            );
        }).toList(),
        );
    }
  return ScopedModelDescendant<NewAppStateModel>(
      builder: (context, child, model)
      {
        return Container(
          child: _buildPanel(model),
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
            height: 180.0,
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
                  _buildProductCards(context)
              ,

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
                                                                   decimalDigits: 0, locale: Localizations.localeOf(context).toString());
    final ThemeData theme = Theme.of(context);



    return ScopedModelDescendant<NewAppStateModel>(
        builder: (context, child, model) => GestureDetector(
          onTap: () {
            final discount = (model.Discount == null) ? 0.0 : model.Discount;
//          addProductToCart(model, product);
//            model.addEditableProductToCart(product);
//            model.calculateCartTotalValue(discount.toString());


            Fluttertoast.showToast(
                msg: "Product Added",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0
                );

          },
          child: child,
          ),
        child:
        Container(
          padding: EdgeInsets.all(7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                product == null ? '  ' : product['name'].toString(),
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
//                        theme.textTheme.button,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                ),
              Spacer(),
              Text(
                product == null || product['sp'] == "" ? '' : formatter.format(product['sp']),
                //                          style:
                //                          theme.textTheme.caption,

                ),
            ],
            ),
          color: Color(0xff68d8c2),
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



class StockRow extends StatelessWidget {
  StockRow({@required this.product});
  final Map<String, dynamic > product;


  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(name: 'INR',
                                                    decimalDigits: 2,
                                                  //                                                      locale: Localizations.localeOf(context).toString()
                                                  );


    return ScopedModelDescendant<NewAppStateModel> (
        builder: (context, child, model) {

          return Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [

                Row(

                  children: [


                    Expanded(
                      child: Text(product['name']),
                      flex: 6,
                      ),

                    Expanded(
                      flex: 3,
                      child: Text(product['qty']),
                      ),
                    Expanded(
                      child: new Text(product['sp']),
                      flex: 3,
                      ),


                  ],
                  ),
                Container(
                  height: 10,
                  ),
                Divider(color: Color(0xff429585),thickness: 1)

              ],
              ),
            );
        });
  }
}

class StockRowEditable extends StatelessWidget {
  StockRowEditable({@required this.product});
  final Map<String, dynamic > product;
  @override

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NewAppStateModel> (
        builder: (context, child, model) {
          return Container(
            child: Column(
              children: [

                Row(
                  key: ValueKey(product['id'].toString()),
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [


                    const SizedBox(width: 30.0),
                    Expanded(
                      child: Container(

                      ),
                      flex: 2,
                      ),
                    Expanded(
                      child: Text(product['name']),
                      flex: 6,
                      ),

                    Expanded(
                      child: Center(
                        child: Container(
                          width: 60.0,

                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: TextFormField(


//                                  focusNode: quantityFocusNode,
autofocus: false,
//                                          initialValue: quantity.toString(),
//                                  controller: quantityController,
                                  keyboardType: TextInputType.number,

                                  onChanged: (text){

                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '${product['qty'].toString()}'
                                      ),
),
                                ),
                              Container(
                                height: 48.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 0.5,
                                            ),
                                          ),
                                        ),
                                      child: InkWell(
                                        child: Icon(
                                          Icons.arrow_drop_up,
                                          size: 22.0,
                                          ),
                                        onTap: () {

                                        },
                                        ),
                                      ),
                                    InkWell(
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        size: 22.0,
                                        ),
                                      onTap: () {

                                      },
                                      ),
                                  ],
                                  ),
                                ),
                            ],
                            ),
                          ),
                        ),
                      flex: 4,
                      ),
                    Expanded(
                      child: new TextFormField(
                        textAlign: TextAlign.center,
                        autofocus: false,
                        initialValue: product['sp'],
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                          ),
                        onChanged: (text){

                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          ),
                        ),
                      flex: 3,
                      ),

                  ],
                  ),
                Divider(color: Color(0xff429585),thickness: 1,height: 4,)

              ],
              ),
            );
        }
        );
  }

}

class StockRowNewStockEditable extends StatelessWidget {
  StockRowNewStockEditable({@required this.product});
  final Map<String, dynamic > product;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<NewAppStateModel> (
      builder: (context, child, model) {
        return Container(
          child: Column(
            children: [

              Row(
                key: ValueKey(product['id'].toString()),
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [


                  const SizedBox(width: 30.0),
                  Expanded(
                    child: Container(

                    ),
                    flex: 2,
                    ),
                  Expanded(
                    child: Text(product['name']),
                    flex: 6,
                    ),

                  Expanded(
                    child: Center(
                      child: Container(
                        width: 60.0,

                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: TextFormField(


//                                  focusNode: quantityFocusNode,
autofocus: false,
//                                          initialValue: quantity.toString(),
//                                  controller: quantityController,
                                keyboardType: TextInputType.number,

                                onChanged: (text){

                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '${product['qty'].toString()}'
                                    ),
),
                              ),
                            Container(
                              height: 48.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 0.5,
                                          ),
                                        ),
                                      ),
                                    child: InkWell(
                                      child: Icon(
                                        Icons.arrow_drop_up,
                                        size: 22.0,
                                        ),
                                      onTap: () {

                                      },
                                      ),
                                    ),
                                  InkWell(
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      size: 22.0,
                                      ),
                                    onTap: () {

                                    },
                                    ),
                                ],
                                ),
                              ),
                          ],
                          ),
                        ),
                      ),
                    flex: 4,
                    ),

                ],
                ),
              Divider(color: Color(0xff429585),thickness: 1,height: 4,)

            ],
            ),
          );
      }
      );
  }
}


class StockRowSentPage extends StatelessWidget {
  StockRowSentPage({@required this.product});
  final Map<String, dynamic > product;


  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(name: 'INR',
                                                    decimalDigits: 2,
                                                  //                                                      locale: Localizations.localeOf(context).toString()
                                                  );


    return ScopedModelDescendant<NewAppStateModel> (
        builder: (context, child, model) {

          return Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [

                Row(

                  children: [
                    Expanded(
                      child: Text(product['name']),
                      flex: 6,
                      ),

                    Expanded(
                      flex: 3,
                      child: Text(product['qty']),
                      ),

                  ],
                  ),
                Container(
                  height: 10,
                  ),
                Divider(color: Color(0xff429585),thickness: 1)

              ],
              ),
            );
        });
  }
}