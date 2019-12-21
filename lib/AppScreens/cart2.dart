
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/services.dart';
//import '../testBarcodeScanner.dart';
import '../model/app_state_model.dart';
//import 'model/product.dart';
import '../model/queryForUI.dart';
import '../services/syncData.dart';




NewAppStateModel newModelCart2 = NewAppStateModel();
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



  List<Widget> _createShoppingCartRows(NewAppStateModel model) {
//    print("Entered into _createShoppingCartRows :::: value of productsInCart.keys = ${model.productsInCart.keys.runtimeType}");
//    var newCartListtype = model.productsInCart.keys
//        .map(
//            (id) => NewShoppingCartRow(id: id)
//    ).toList();
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
  Widget _queryBox(NewAppStateModel model) {
    return TextField(
      controller: tc,
      onChanged: (text) async{
        if (text.length > 3) {
//          var allProducts = await q('initSearch', '', text);
//          var allProducts = await queryForUI('secondSearch', '5', 'cold drink');
//          print(allProducts);
//          model.loadProducts(allProducts);

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
          icon: Icon(Icons.add),
          onPressed: () async{
//                    getSyncAPI();
//          clickCallback();
//            var allProducts = await q('initStack', '', '');
//            print(allProducts);
//            model.loadProducts(allProducts);
          },
          ),
        ),
      );

  }



  Widget quickLinkSection = Text('  Quick Links     ');
  Widget productDetailHeadingSection = SizedBox(
    height: 30,
    child: Text(
      'Product :      MRP             SP             QTY             Total',
      textAlign: TextAlign.left,
      style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );

  Widget _buildPanel(NewAppStateModel model) {
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
              _queryBox(newModelCart2),
              NewProductPage(),

            ],
            ),
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
        height: 70,
        width: 400,
        child: ScopedModelDescendant<NewAppStateModel>(
            builder: (context, child, model) {
              Map product = {"id": 1, "name": "custom dal"};
              final double subTotal =  (model.subTotal == null) ? 0.0 : model.subTotal;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      model.removeEditableItemFromCart(product,"clear_cart");
                      model.calculateCartTotalValue(model.Discount.toString());


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
                      child: Text(formatter.format(subTotal),
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


    var shoppingCartRowSection = Container(
      child: ScopedModelDescendant<NewAppStateModel>(
        builder: (context, child, model) {
          return Column (
            children: _createShoppingCartRows(model),
            );
        },
        ),
      );



    return Scaffold(

//      drawer: Drawer(
//        child: CategoryMenuPage(),
//
//        ),
      body: SafeArea(

        child: ScopedModel<NewAppStateModel>(
          model: newModelCart2,
          child: ScopedModelDescendant<NewAppStateModel>(
              builder: (context, child, model) {
                return  Stack(
                  children: <Widget>[
                    SizedBox(
                      height: 380,
                      child: ListView(
//                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        children: <Widget>[
//
                          KeyboardListener(),
                          const Divider(
                              color: Colors.deepOrangeAccent, height: 5
                          ),

                          //              quickLinkSection,
                          _buildPanel(model),

                          const Divider(
                              color: Colors.deepOrangeAccent, height: 5
                          ),

                          productDetailHeadingSection,
                          const Divider(
                              color: Colors.deepOrangeAccent, height: 5
                          ),

//              .....................................................Shopping Cart Rows!!!!
                          shoppingCartRowSection,
                          NewShoppingCartSummary(model: model),




//


                        ],
                      ),
                    ),
                    Align(child: SizedBox(
                      height: 70,
                      width: 400,
                      child: Card(
                        child: lastBarSection,
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

          final Map product =  model.getProductById(widget.id);

          //print("wdq :: ${model.quantityOfCurrentProductRow[model.quantityOfCurrentProductRow.indexWhere((p) => int.parse(p['id']) == widget.id)]['sp']}");
          final int quantity =  (model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['quantity'].runtimeType.toString() == 'String') ? double.parse(model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['quantity']) : model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['quantity'];
          final double sellingPrice =  (model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['sp'].runtimeType.toString() == 'String') ? double.parse(model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['sp']) : model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['sp'];
          final double MRP =  (model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['mrp'].runtimeType.toString() == 'String') ? double.parse(model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['mrp']) : model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['mrp'];




//          myController.text = '${product['sp'].toString()}';

          TextEditingController mrpController = TextEditingController(text: '${product['mrp']}');
          TextEditingController spController = TextEditingController(text: '${product['sp']}');
          TextEditingController quantityController = TextEditingController(text: '${quantity.toString()}');
          final _amountValidator = RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');
          //print("wdq :: ${(model.quantityOfCurrentProductRow[model.quantityOfCurrentProductRow.indexWhere((p) => int.parse(p['id']) == widget.id)]['sp'].runtimeType.toString() == 'String') ? 'string' : 'double'}");

          FocusNode mrpFocusNode, spFocusNode, quantityFocusNode;

          @override
          void initState() {
            super.initState();

            mrpFocusNode = FocusNode();
            spFocusNode = FocusNode();
            quantityFocusNode = FocusNode();
          }

          @override
          void dispose() {
            // Clean up the focus node when the Form is disposed.
            mrpFocusNode.dispose();
            spFocusNode.dispose();
            quantityFocusNode.dispose();

            super.dispose();
          }

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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 40.0),

                                      Container(
                                        width: 50,
                                        child: new TextFormField(
                                          focusNode: mrpFocusNode,
                                          autofocus: false,
                                          initialValue: MRP.toString(),
                                          inputFormatters: [_amountValidator],
                                          keyboardType: TextInputType.numberWithOptions(
                                            decimal: true,
                                            signed: false,
                                          ),
                                          onChanged: (text){
                                            model.changeProductValue(text, product, 'mrp');

                                          },
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '${product['mrp'].toString()}'
                                          ),
                                        ),
                                      ),
//                                const SizedBox(width: 30.0),
                                      Spacer(),
                                      Container(
                                        width: 50,
                                        child: new TextFormField(
                                          focusNode: spFocusNode,
                                          autofocus: false,
                                          initialValue: sellingPrice.toString(),
                                          inputFormatters: [_amountValidator],
                                          keyboardType: TextInputType.numberWithOptions(
                                            decimal: true,
                                            signed: false,
                                          ),
                                          onChanged: (text){
                                            model.changeProductValue(text, product, 'sp');
                                            model.calculateCartTotalValue(model.Discount.toString());
                                          },
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '${product['sp'].toString()}'
                                              ),
                                          ),
                                        ),
                                      Spacer(),
//                                      Container(
//                                        width: 35,
//                                        child: Text('$quantity'.toString()),
//                                        ),
                                      Spacer(),
                                      Container(
                                        width: 50,
                                        child: new TextFormField(
                                          focusNode: quantityFocusNode,
                                          autofocus: false,
//                                          initialValue: quantity.toString(),
                                          controller: quantityController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            WhitelistingTextInputFormatter.digitsOnly
                                          ],
                                          onChanged: (text){
                                            model.changeProductValue(text, product, 'quantity');
                                            model.calculateCartTotalValue(model.Discount.toString());
                                          },
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '${product['quantity'].toString()}'
                                          ),
                                        ),
                                      ),
                                      Text('${formatter.format(sellingPrice*quantity)}'.toString()),
                                    ],
                                    ),

                                ],
                                ),
                              ),
                          ],
                          ),
                        const SizedBox(height: 16.0),
                        const Divider(
                            color: Colors.deepOrangeAccent, height: 5
                            ),
                      ],
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[
                      IconButton(
                        iconSize: 15,
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: ()
                      {
                      //removeItemFromCart(model, product);
                      model.removeEditableItemFromCart(product, "reduce_quantity");
                      model.calculateCartTotalValue(model.Discount.toString());
                      }
//                        widget.onPressedDelete,
                        ),
                      IconButton(
                        iconSize: 15,
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: ()
                        {
//                          print("Calling addProductToCart\n\n passing items : $model : $product \n\n");
//                          addProductToCart(model, product);
                          print("Calling addEditableProductToCart\n\n passing items : $product \n\n");
                          model.addEditableProductToCart(product);
                          model.calculateCartTotalValue(model.Discount.toString());
                        }

                        ),
                    ],
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
              products: getProducts(model)

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
    return List.generate(products.length, (index) {
      return Container(
                      child: ProductCard(product: products[index]),
                      );
                          }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 150.0,
            child: new GridView.count(
              scrollDirection: Axis.horizontal,
              primary: false,
//              padding: const EdgeInsets.all(10),
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
    final NumberFormat formatter = NumberFormat.simpleCurrency(name: 'INR',
        decimalDigits: 2, locale: Localizations.localeOf(context).toString());
    final ThemeData theme = Theme.of(context);
    return ScopedModelDescendant<NewAppStateModel>(
      builder: (context, child, model) => GestureDetector(

        onTap: () {
          final discount = (model.Discount == null) ? 0.0 : model.Discount;
//          print("entering add product to cart from quicklinks\n\n");
//          addProductToCart(model, product);
          print("entering add addEditableProductToCart to cart from quicklinks\n\n");
          model.addEditableProductToCart(product);
          model.calculateCartTotalValue(discount.toString());
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
                      style: theme.textTheme.button,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      ),
//                Spacer(),
                    Text(
                      product == null ? '' : formatter.format(product['sp']),
                      style: theme.textTheme.caption,
                      ),
                  ],
                  ),
                ),),
          ],
          ),
          color: Colors.blueGrey,
      )

      );
  }
}

class CategoryCard extends StatelessWidget {
  CategoryCard({this.imageAspectRatio = 33 / 49, this.category})
      : assert(imageAspectRatio == null || imageAspectRatio > 0);

  final double imageAspectRatio;
  final Map<String, dynamic> category;

  static final kTextBoxHeight = 65.0;

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(name: 'INR',
                                                                   decimalDigits: 2, locale: Localizations.localeOf(context).toString());
    final ThemeData theme = Theme.of(context);

    return ScopedModelDescendant<NewAppStateModel>(
        builder: (context, child, model) => GestureDetector(
          onTap: () {

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
                        maxLines: 2,
                        ),

                    ],
                    ),
                  ),),
            ],
            ),
          color: Colors.blueGrey,
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
    final _amountValidator = RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

    return ScopedModelDescendant<NewAppStateModel>(
      builder: (context, child, model) {
        final double TotalCartValue =  (model.cartTotal == null) ? 0.0 : model.cartTotal;
        final double cgst =  (model.sgst == null) ? 0.0 : model.sgst;
        final double sgst =  (model.cgst == null) ? 0.0 : model.cgst;
        final double cess =  (model.cess == null) ? 0.0 : model.cess;
        final double subTotal =  (model.subTotal == null) ? 0.0 : model.subTotal;
        final double discount =  (model.Discount != null) ? model.Discount : 0.0;
        TextEditingController discountController = TextEditingController(text: '${discount.toString()}');
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
                              model.calculateCartTotalValue(model.Discount.toString());

                            });
                          },
                          activeColor: Colors.black,
                          ),
                        const Expanded(
                            child: Text('GST')
                            //                          SizedBox(height: 1,),
                            ),

                      ],
                      ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('SGST:'),
                        ),
                        Text(
                          formatter.format(sgst),
                          style: smallAmountStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('CGST:'),
                        ),
                        Text(
                          formatter.format(cgst),
                          style: smallAmountStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('CESS:'),
                        ),
                        Text(
                          formatter.format(cess),
                          style: smallAmountStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Text('Subtotal'),
                          ),
                        Text(
                          formatter.format(subTotal),
                          style: smallAmountStyle,
                          ),
                      ],
                      ),
                    const SizedBox(height: 6.0),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Discount:'),
                          ),
                        Container(
                          width: 50,
                          child: new TextFormField(
                            controller: discountController,
                            inputFormatters: [_amountValidator],
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                            onChanged: (text){
                              model.calculateCartTotalValue(text);
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                      ),

                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Total Amount:'),
                        ),
                        Text(
                            (TotalCartValue >= 0) ? formatter.format(TotalCartValue) : "Discount exceeds cart value",
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






class RegExInputFormatter implements TextInputFormatter {
  final RegExp _regExp;

  RegExInputFormatter._(this._regExp);

  factory RegExInputFormatter.withRegex(String regexString) {
    try {
      final regex = RegExp(regexString);
      return RegExInputFormatter._(regex);
    } catch (e) {
      // Something not right with regex string.
      assert(false, e.toString());
      return null;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final oldValueValid = _isValid(oldValue.text);
    final newValueValid = _isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }

  bool _isValid(String value) {
    try {
      final matches = _regExp.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}



class KeyboardListener extends StatefulWidget {

  KeyboardListener();

  @override
  _RawKeyboardListenerState createState() => new _RawKeyboardListenerState();
}

class _RawKeyboardListenerState extends State<KeyboardListener> {

  TextEditingController _controller = new TextEditingController();
  FocusNode _textNode = new FocusNode();


  @override
  initState() {
    super.initState();
  }

  //Handle when submitting
  void _handleSubmitted(String finalinput) {

    setState(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide'); //hide keyboard again
      _controller.clear();
    });
  }

  String barcode = "";
  handleKey(RawKeyEvent key) {
    //print("Event runtimeType is ${key.runtimeType}");
    if(key.runtimeType.toString() == 'RawKeyDownEvent'){
      RawKeyEventDataAndroid data = key.data as RawKeyEventDataAndroid;
      String _keyCode;
      _keyCode = data.keyCode.toString(); //keycode of key event (66 is return)

      barcode = barcode + key.data.keyLabel;

      print("\n\nwhy does this run twice ${newModelCart2.subTotal}");
    }

    print("\n\n${barcode}");
  }

  _buildTextComposer() {


    FocusScope.of(context).requestFocus(_textNode);

    return new RawKeyboardListener(
        focusNode: _textNode,
        autofocus: false,
        onKey: (key) => newModelCart2.processBarcode(key),
        child: Text("")
    );
  }


  @override
  Widget build(BuildContext context) {
    return _buildTextComposer();
  }
}




