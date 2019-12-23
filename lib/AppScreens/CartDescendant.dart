import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/services.dart';
import '../model/app_state_model.dart';
import '../model/queryForUI.dart';
import 'package:fluttertoast/fluttertoast.dart';





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


class CartDescendant extends StatefulWidget {
  @override
  _CartDescendant createState() => _CartDescendant();
}

class _CartDescendant extends State<CartDescendant> {


  bool bottomBarHide = false;
  bool creditModeFlag = false;
  String creditMode = '';
  void setBottomBarHide(){
    setState(() {
      bottomBarHide = !bottomBarHide;
    });
  }
  bool otherPaymentFlag = false;
  bool creditPaymentFlag = false;
  String paymentMode = 'Payment Mode';
  bool customItem = false;

  void creditModeFunc(String mode){
    creditModeFlag = true;
    creditMode = mode;
  }

  void cartState(String state){
    setState(() {
      if (state == 'CREDIT'){
        creditPaymentFlag = !creditPaymentFlag;
      }
      else{{otherPaymentFlag = !otherPaymentFlag;}}
      paymentMode = state;
      print('.......cart2State changed.........');
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(name: 'INR', decimalDigits: 2,
                                                      locale: Localizations.localeOf(context).toString());

    var lastBarSection = Container(
        height: 56,
        width: 400,
        child: ScopedModelDescendant<NewAppStateModel>(
            builder: (context, child, model) {

              final double cartTotal =  (model.cartTotalValue == null) ? 0.0 : model.cartTotalValue;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      model.removeEditableItemFromCart(productDummy,"clear_cart");
                      model.calculateCartTotalValue(model.Discount.toString());
                    },
                    ),
                  Spacer(),
                  Card(
//                    width: 189,
child: Material(
  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22.0)),
  elevation: 18.0,
  color: Color(0xff429585),
  clipBehavior: Clip.antiAlias, // Add This
  child: MaterialButton(
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    height: 40.0,
    child: new Text(formatter.format(cartTotal),
                      style: TextStyle(color:Colors.black, fontWeight: FontWeight.bold
                                       ),),
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
                      // Select customer from bottom bar - Add function to load all customers
                      Navigator.pushNamed(context, '/customer');
                    },
                    ),
                ],
                );
            })

        );



    Widget _productDetailsHeadingSection = Container(
        height: 40,
        color: Color(0xff68d8c2),
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
                flex: 2,
                ),
              Expanded(
                child: Text(
                  'MRP',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                flex: 3,
                ),
              Expanded(
                child: Text(
                  'SP',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                flex: 3,
                ),
              Expanded(
                child: Text(
                  'QTY',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                flex: 4,
                ),
              Expanded(
                child: Text(
                  'Total',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  ),flex: 3,
                ),
            ],
            ),
          )

        );

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

    var shoppingCartRowSection = Container(
      child: ScopedModelDescendant<NewAppStateModel>(
        builder: (context, child, model) {
          return Column (
            children: _createShoppingCartRows(model),
            );
        },
        ),
      );


    TextEditingController tc;

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
                          setState(() {
                            customItem = !customItem;
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
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('Quick Links',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16
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


    return Scaffold(
      body: SafeArea(

        child: ScopedModelDescendant<NewAppStateModel>(

            builder: (context, child, model) {
              return  Stack(
                children: <Widget>[
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 0.1),
                    children: <Widget>[
                      //
                      bottomBarHide?
                      KeyboardListener()
                          :new Container(),
                      const Divider(
                          color: Colors.deepOrangeAccent, height: 5
                          ),

                      //              quickLinkSection,
                      _buildPanel(model),
                      Container(
                        child: Column(
                          children: <Widget>[
                            _productDetailsHeadingSection,
                            shoppingCartRowSection,
                            model.totalCartQuantity == null || model.totalCartQuantity == 0
                                ?
                            SizedBox(
                              height: _data[0].isExpanded
                                  ?
                              120:350,
                              )
                                :
                            new Container(),

                            NewShoppingCartSummary(model: model),

                            model.totalCartQuantity == null || !bottomBarHide
                                ?SizedBox(
                              height: 50,
                              )
                                :
                            SizedBox(
                              height:  450,
                              child: Container(
                                child: Column(
//                                    mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 4.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child:  Row(
                            children: [
                              const Expanded(
                                child: Text('Total Amount:'),
                                ),
                              Text(
                                ((model.cartTotalValue == null ? 0 : model.cartTotalValue) >= 0) ? formatter.format((model.cartTotalValue == null ? 0 : model.cartTotalValue))+"   " : "Discount exceeds cart value",

                                ),
                            ],
                            ),
                        ),

                        Divider(color: Colors.red, height: 10,thickness: 1,),
                        InkWell(
    // When the user taps the button, show a snackbar.
    onTap: () {
      // add custom item in quick links - add function to show bar of custom items
      Navigator.pushNamed(context, '/customers');
    },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: Color(0xffe48181),
        child: Row(
          children: <Widget>[
            Icon(Icons.person_add,color: Colors.black,),
            Text('      Select User' ),
            Spacer(),
            Icon(Icons.report_problem,color: Colors.black,),

          ],
          ),
        ),
    ),


  Divider(color: Colors.grey, height: 1,thickness: 1,),




  !otherPaymentFlag && !creditPaymentFlag
      ?
  Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  setBottomBarHide();
                });

              },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Icon(Icons.navigate_before),
                  ),
              ),


            Text('Select Payment Mode'),


          ],
          ),
        Row(
          children: <Widget>[
            RaisedButton(
              child: Text('CASH'),
              onPressed: () {
                setState(() {
                  cartState('CASH');
                });
              },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
              ),
            Spacer(),
            RaisedButton(
              child: Text('CREDIT'),
              onPressed: () {model.analyzeCredit(0.0, "credit");
              setState(() {
                cartState('CREDIT');
              });
              },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
              ),
            Spacer(),
            RaisedButton(
              child: Text('DEBIT/CREDIT CARD'),
              onPressed: () {
                setState(() {
                  cartState('DEBIT/CREDIT CARD');
//
                });
              },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
              ),

          ],
          ),
        Container(
          width: 20,
          height: 15
        ),

        Row(
          children: <Widget>[
            RaisedButton(
              child: Text('PAYTM'),
              onPressed: () {
                setState(() {
                  cartState('PAYTM');
                });
              },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
              ),
            Spacer(),
            RaisedButton(
              child: Text('BHIM UPI'),
              onPressed: () {
                setState(() {
                  cartState('BHIM UPI');
                });
              },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
              ),
            Spacer(),
            RaisedButton(
              child: Text('OTHER'),
              onPressed: () {
               setState(() {
                 cartState('OTHER');
               });
              },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
              ),

          ],
          ),
      ],
      ),
    )
      :
  otherPaymentFlag
      ?
  Container(
    padding: EdgeInsets.symmetric(horizontal: 7),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  cartState(paymentMode);
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Icon(Icons.navigate_before),
                ),
              ),

            Text(paymentMode),

            Spacer(),

            OutlineButton(child: Text('Clear Cart'),
                           onPressed: (){
                             setState(() {
                               cartState(paymentMode);
                               setBottomBarHide();
                               model.removeEditableItemFromCart(productDummy,"clear_cart");
                             });
                           },
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                       ),

          ],
          ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical:20),
          child: Row(
//            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              Text('Total Amount to be Paid  :  ',style:TextStyle(fontSize: 17)),
              Spacer(),
              Text(formatter.format((model.cartTotalValue == null) ? 0.0 : model.cartTotalValue),

                       style:TextStyle(fontSize: 20)
                   ),

            ],
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child:RaisedButton(
                color: Color(0xff64b5f6),
                  child: Text('PRINT RECEIPT'),
                  onPressed: () {
                    setState(() {
                      cartState(paymentMode);
                      setBottomBarHide();
                      model.generateInvoice(true);
                      model.removeEditableItemFromCart(productDummy, 'clear_cart');
                    }
                    );
                  },
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                  ),
              flex:6
            ),
           Expanded(
             child:  SizedBox(width: 40,),
             flex:1
           ),
            Expanded(child: RaisedButton(
            color: Color(0xff81c784),
                child: Text('DONE'),
                onPressed: () {
                  setState(() {
                    model.removeEditableItemFromCart(productDummy, 'clear_cart');
                    model.generateInvoice(false);

                    cartState(paymentMode);
                    setBottomBarHide();
                  });

                },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                ),
                     flex:6)


          ],
          ),
      ],
      ),
    )
      :creditPaymentFlag
      ?
  Container(
    padding: EdgeInsets.symmetric(horizontal: 13),
    child: Column(
      children: <Widget>[
        Row(children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                cartState(paymentMode);
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Icon(Icons.navigate_before),
              ),
            ),

          Text(paymentMode,style:TextStyle(fontSize: 15)),
          Spacer(),
          OutlineButton(child: Text('Clear Cart'),
                            onPressed: (){
                              setState(() {
                                cartState(paymentMode);
                                setBottomBarHide();
                                model.removeEditableItemFromCart(productDummy,"clear_cart");
                              });
                            },
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                        ),

        ],),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Amount Paid    ',),
            Spacer(),
            Container(
              width: 40,
              child: TextFormField(
                autofocus: false,
                initialValue: '0',
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                  ),
                onChanged: (text){
                  print(text.toString());
                  model.analyzeCredit(double.parse(text), 'credit');

                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  //                                                        hintText: '${product['mrp'].toString()}'
                  ),
                ),
              ),
          ],

          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Amount Credited     ',),
            Spacer(),
            Container(
                padding: EdgeInsets.all(10),
                height: 33,
                width: 50,
                child: Text(model.credit.toString())
                )
          ],

          ),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                color:  creditMode == 'CASH'
                    ?Color(0xff4db6ac)
                    :Colors.white30,
//                ,
                child: Text('CASH'),
                onPressed: () {
                  setState(() {
                    creditModeFunc('CASH');
                  });
                },
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                ),
              flex: 6,
            ),
            Expanded(
                child: SizedBox(
                  width: 10,
                ),
                flex:1
                ),

            Expanded(
              child: RaisedButton(
                  color:  creditMode == 'DEBIT/CREDIT CARD'
                      ?Color(0xff4db6ac)
                      :Colors.white30,
                child: Text('DEBIT/CREDIT CARD'),
                onPressed: () {
                  setState(() {
                    setState(() {
                      creditModeFunc('DEBIT/CREDIT CARD');
                    });
//
                  });
                },
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                ),
              flex: 6,
            )

          ],
          ),
        Row(
          children: <Widget>[
            Expanded(
                child:RaisedButton(
                    color:  creditMode == 'PAYTM'
                        ?Color(0xff4db6ac)
                        :Colors.white30,
                  child: Text('PAYTM'),
                  onPressed: () {
                    setState(() {
                      creditModeFunc('PAYTM');
                    });
                  },
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                  ),
                flex:4
                ),
            Expanded(
                child: SizedBox(
                  width: 10,
                  ),
                flex:1
                ),
            Expanded(
                child:RaisedButton(
                    color:  creditMode == 'BHIM UPI'
                        ?Color(0xff4db6ac)
                        :Colors.white30,
                  child: Text('BHIM UPI'),
                  onPressed: () {
                    setState(() {
                      creditModeFunc('BHIM UPI');
                    });
                  },
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                  ),
                flex:4
                ),
            Expanded(
                child: SizedBox(
                  width: 10,
                  ),
                flex:1
                ),
            Expanded(
                child:RaisedButton(
                    color:  creditMode == 'OTHER'
                        ?Color(0xff4db6ac)
                        :Colors.white30,
                  child: Text('OTHER'),
                  onPressed: () {
                    setState(() {
                      creditModeFunc('OTHER');
                    });
                  },
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                  ),
                flex:4
                ),
          ],
          ),

          Divider(color: Colors.black, thickness: 1, height: 40,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: RaisedButton(
                  color:
//                  Color(0xff90caf9),
                  Color(0xff64b5f6),
                  child: Text('PRINT RECEIPT'),
                  onPressed: () {
                    setState(() {
                      if (creditModeFlag){
                        creditModeFlag = !creditModeFlag;
                        cartState('CREDIT');
                        setBottomBarHide();
                        model.generateInvoice(true);
                        model.analyzeCredit((model.cartTotalValue == null)
                                                ? 0.0
                                                : model.cartTotalValue,
                                                creditMode);
                        model.removeEditableItemFromCart(productDummy, 'clear_cart');
                        creditModeFunc('');

                      }
                      else{
                        Fluttertoast.showToast(
                            msg: "!!  SELECT Payment Mode",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.black87,
                            textColor: Colors.white,
                            fontSize: 16.0
                            );
                      }
                    });
                  },
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                  ),
                flex:6
                ),
            Expanded(
                child: SizedBox(
                  width: 10,
                  ),
                flex:1
                ),
            Expanded(
                child: RaisedButton(

                  color:
                  Color(0xff81c784),
//                  Color(0xff4db6ac),

                    child: Text('DONE'),
                    onPressed: () {
                     setState(() {
                       if (creditModeFlag){
                         creditModeFlag = !creditModeFlag;
                         model.removeEditableItemFromCart(productDummy, 'clear_cart');
                         model.generateInvoice(false);
                         cartState('CREDIT');
                         setBottomBarHide();
                         model.analyzeCredit((model.cartTotalValue == null)
                                                 ? 0.0
                                                 : model.cartTotalValue,
                                                 creditMode);
                         creditModeFunc('');
                       }
                       else{
                         Fluttertoast.showToast(
                             msg: "!!  SELECT Payment Mode",
                             toastLength: Toast.LENGTH_LONG,
                             gravity: ToastGravity.CENTER,
                             timeInSecForIos: 1,
                             backgroundColor: Colors.black87,
                             textColor: Colors.white,
                             fontSize: 16.0
                             );
                       }
                     });

                    },
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                    ),
                flex:6
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
                  customItem
                      ?
                      Align(
                        child:Card(
                          borderOnForeground: false,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            height: 500,
                            width: 370,
                            color: Colors.black12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Add Custom Item'),
                                Divider(color: Color(0xff429585),thickness: 1,height: 10,),
                                Padding(
                                  padding: EdgeInsets.only(top: 10, left: 10, right:10),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                          'df'
                                          ),
                                      Spacer(),
                                      InkWell(
                                        child: Icon(
                                          Icons.clear,
                                          size: 22.0,
                                          ),
                                        onTap: () {
                                          setState(() {
                                            customItem = !customItem;
                                          });

                                        },
                                        ),


                                    ],
                                    ),
                                  ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [


                                    const SizedBox(width: 30.0),
                                    Expanded(
                                      child: Container(

                                      ),
                                      flex: 3,
                                      ),
                                    Expanded(
                                      child: TextFormField(
//                                        focusNode: mrpFocusNode,
autofocus: false,
//                                        initialValue: MRP.toString(),
//                                        inputFormatters: [_amountValidator],
                                        keyboardType: TextInputType.numberWithOptions(
                                          decimal: true,
                                          signed: false,
                                          ),
                                        onChanged: (text){
//                                          model.changeProductValue(text, product, 'mrp');

                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          //                                            hintText: '${product['mrp'].toString()}'
                                          ),
),
                                      flex: 3,
                                      ),
                                    Expanded(
                                      child: new TextFormField(
//                                        focusNode: spFocusNode,
autofocus: false,
//                                        initialValue: sellingPrice.toString(),
//                                        inputFormatters: [_amountValidator],
                                        keyboardType: TextInputType.numberWithOptions(
                                          decimal: true,
                                          signed: false,
                                          ),
                                        onChanged: (text){
//                                          model.changeProductValue(text, product, 'sp');
                                          model.calculateCartTotalValue(model.Discount.toString());
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          //                                            hintText: '${product['sp'].toString()}'
                                          ),
),
                                      flex: 3,
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
//                                                  focusNode: quantityFocusNode,
autofocus: false,
//                                          initialValue: quantity.toString(),
//                                                  controller: quantityController,
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: <TextInputFormatter>[
                                                    WhitelistingTextInputFormatter.digitsOnly
                                                  ],
                                                  onChanged: (text){
//                                                    model.changeProductValue(text, product, 'quantity');
                                                    model.calculateCartTotalValue(model.Discount.toString());
                                                  },
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    //                                                      hintText: '${product['quantity'].toString()}'
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
//                                                          model.addEditableProductToCart(product);
                                                          model.calculateCartTotalValue(model.Discount.toString());
                                                        },
                                                        ),
                                                      ),
                                                    InkWell(
                                                      child: Icon(
                                                        Icons.arrow_drop_down,
                                                        size: 22.0,
                                                        ),
                                                      onTap: () {
//                                                        model.removeEditableItemFromCart(product, "reduce_quantity");
                                                        model.calculateCartTotalValue(model.Discount.toString());
                                                      },
                                                      ),
                                                  ],
                                                  ),
                                                ),
                                            ],
                                            ),
                                          ),
                                        ),
                                      flex: 3,
                                      ),
                                    Expanded(
                                      child: Container(
                                        child: Column(children: <Widget>[
//                                          Text('${formatter.format(sellingPrice*quantity)}'.toString()),
                                          SizedBox(
                                            height: 17,
                                            ),

                                        ],),
                                        ),
                                      flex: 4,
                                      ),
                                  ],
                                  ),

                              ],
                              ),
                            ),
                        ),
                        alignment: Alignment.center,
                      )
                      :
                      new Container()
                ],
                );
            }),
        ),
      );
  }




}


final Map productDummy = {"id": 1, "name": "custom dal"};

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
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right:10),
                  child: Row(
                    children: <Widget>[
                      Text(
                        product['name'].toString(),
                        style: localTheme.textTheme.subhead
                            .copyWith(fontWeight: FontWeight.w600),
                        ),
                      Spacer(),
                      InkWell(
                        child: Icon(
                          Icons.clear,
                          size: 22.0,
                          ),
                        onTap: () {
                          model.removeEditableItemFromCart(product,  'remove_row');
                          model.calculateCartTotalValue(model.Discount.toString());
                        },
                        ),


                    ],
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [


                    const SizedBox(width: 30.0),
                    Expanded(
                      child: Container(

                      ),
                      flex: 3,
                      ),
                    Expanded(
                      child: TextFormField(
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
                      flex: 3,
                      ),
                    Expanded(
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
                      flex: 3,
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
                                          model.addEditableProductToCart(product);
                                          model.calculateCartTotalValue(model.Discount.toString());
                                        },
                                        ),
                                      ),
                                    InkWell(
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        size: 22.0,
                                        ),
                                      onTap: () {
                                        model.removeEditableItemFromCart(product, "reduce_quantity");
                                        model.calculateCartTotalValue(model.Discount.toString());
                                      },
                                      ),
                                  ],
                                  ),
                                ),
                            ],
                            ),
                          ),
                        ),
                      flex: 3,
                      ),
                    Expanded(
                      child: Container(
                        child: Column(children: <Widget>[
                          Text('${formatter.format(sellingPrice*quantity)}'.toString()),
                          SizedBox(
                            height: 17,
                            ),

                        ],),
                        ),
                      flex: 4,
                      ),
                  ],
                  ),
                Divider(color: Color(0xff429585),thickness: 1,height: 4,)

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
//          print("entering add product to cart from quicklinks\n\n");
//          addProductToCart(model, product);
            print("entering add addEditableProductToCart to cart from quicklinks\n\n");
            model.addEditableProductToCart(product);
            model.calculateCartTotalValue(discount.toString());

//            Scaffold.of(context).showSnackBar(SnackBar(
//              content: Text('Product Added Successfully'),
//              ));

            Fluttertoast.showToast(
                msg: "Product Added",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
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
                product == null ? '' : formatter.format(product['sp']),
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


class NewShoppingCartSummary extends StatefulWidget {
  NewShoppingCartSummary({this.model});
  final NewAppStateModel model;

  @override
  _ShoppingCartSummary createState() => _ShoppingCartSummary();
}

class _ShoppingCartSummary extends State<NewShoppingCartSummary> {
//   AppStateModel model;
//   _ShoppingCartSummary({this.model});


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

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('GST'),
                  Switch(
                    value: (model.includeTaxes == null ? false : model.includeTaxes),
                    onChanged: (bool value) {
                      setState(() {
                        model.setGST(value);
                        model.calculateCartTotalValue(model.Discount.toString());
                      });
                    },
                    activeColor: Colors.white,
                    activeTrackColor: Color(0xff429585),

                    ),


                ],
                ),
//                    const SizedBox(height: 4.0),
              model.includeTaxes
                  ?
              Container(
//                height: 400,
//                width: 400,
child: Column(children: <Widget>[
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
],),
)
                  :
              new Container(),

              Row(
                children: [
                  Text('Discount:'),
                  Spacer(),
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


            ],
            ),
          );
      },
      );
  }
}

class KeyboardListener extends StatefulWidget {

  KeyboardListener();

  @override
  _RawKeyboardListenerState createState() => new _RawKeyboardListenerState();
}

class _RawKeyboardListenerState extends State<KeyboardListener> {

//  TextEditingController _controller = new TextEditingController();
  FocusNode _textNode = new FocusNode();


//  @override
//  initState() {
//    super.initState();
//  }

  //Handle when submitting
//  void _handleSubmitted(String finalinput) {
//
//    setState(() {
//      SystemChannels.textInput.invokeMethod('TextInput.hide'); //hide keyboard again
//      _controller.clear();
//    });
//  }

  String barcode = "";
//  handleKey(RawKeyEvent key) {
//    //print("Event runtimeType is ${key.runtimeType}");
//    if(key.runtimeType.toString() == 'RawKeyDownEvent'){
//      RawKeyEventDataAndroid data = key.data as RawKeyEventDataAndroid;
//      String _keyCode;
//      _keyCode = data.keyCode.toString(); //keycode of key event (66 is return)
//
//      barcode = barcode + key.data.keyLabel;
//
//      print("\n\nwhy does this run twice ${newModel.subTotal}");
//    }
//
//    print("\n\n${barcode}");
//  }

  _buildTextComposer() {


    FocusScope.of(context).requestFocus(_textNode);

    return ScopedModelDescendant<NewAppStateModel> (
        builder: (context, child, model) {
          FocusScope.of(context).requestFocus(_textNode);
          return new RawKeyboardListener(
              focusNode: _textNode,
              autofocus: false,
              onKey: (key) => model.processBarcode(key),
              child: Text("")
              );
        });
  }


  @override
  Widget build(BuildContext context) {
    return _buildTextComposer();
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
