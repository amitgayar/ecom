import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:express_store/model/app_state_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/services.dart';
//import '../model/app_state_model.dart';
import '../model/queryForUI.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';




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
                    onPressed: () async {
                      await model.removeEditableItemFromCart(productDummy,"clear_cart");
                      await model.calculateCartTotalValue(model.Discount.toString());
                    },
                    ),
                  Spacer(),
                  Material(
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
                        model.setBottomBarHide();
                      },
                      ),
                    ),

                  Spacer(),
                  (model.selectedCustomer != null && model.selectedCustomer['id'] != null)?
                  SizedBox(
                    width: 20,
                    )
                      :
                  IconButton(
                    icon: Icon(Icons.person_add
                               ),
                    onPressed: () async {
                      await model.queryCustomerInDatabase('all', '');
                      print('lolo ${model.selectedCustomer}');
                      await model.setSelectCustomerForCartFlag(true);


                      // Select customer from bottom bar - Add function to load all customers
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
      color: Colors.white,
      child: ScopedModelDescendant<NewAppStateModel>(
        builder: (context, child, model) {
          return Column (
            children: _createShoppingCartRows(model),
            );
        },
        ),
      );


    TextEditingController tc;
    final _formKey = GlobalKey<FormState>();

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


    return Scaffold(
      body: SafeArea(

        child: ScopedModelDescendant<NewAppStateModel>(

            builder: (context, child, model) {
              return  Stack(
                children: <Widget>[
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 0.1),
                    children: <Widget>[

//                      model.rawListener?
                      KeyboardListener(),
//                          :new Container(),
                      const Divider(
                          color: Colors.deepOrangeAccent, height: 5
                          ),

                      //              quickLinkSection,
                      _buildPanel(model),
                      Container(
                        color: Colors.white,
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

                            model.totalCartQuantity == null || !model.bottomBarHide
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

  model.selectedCustomer != null && model.selectedCustomer['id'] != null ?
  Divider(color: Colors.green, height: 10,thickness: 1,)
      :
  Divider(color: Colors.red, height: 10,thickness: 1,),
  InkWell(
    onTap: () async {
      if (model.selectedCustomer != null && model.selectedCustomer['id'] != null){
        print('\n\nselectedCustomer ID = ${model.selectedCustomer['id']}');

      }
      else{
        await model.queryCustomerInDatabase('all', '');
//      Navigator.pushNamed(context, '/customers');
        print('lolo ${model.selectedCustomer}');
        await model.setSelectCustomerForCartFlag(true);
      }

    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: model.selectedCustomer != null && model.selectedCustomer['id'] != null ?
      Color(0xff429585) : Color(0xffe48181),
      child: Row(
        children: <Widget>[
          model.selectedCustomer != null && model.selectedCustomer['id'] != null ?
          Icon(Icons.person,color: Colors.black,) : Icon(Icons.person_add,color: Colors.black,) ,
          //Text(model.selectedCustomer['name'] ),
          model.selectedCustomer != null && model.selectedCustomer['id'] != null ?
          Text("      ${model.selectedCustomer['name']}") : Text('      Select Customer' ),
          Spacer(),
          model.selectedCustomer != null && model.selectedCustomer['id'] != null ?
          InkWell(
            onTap: ()async {
              if (model.selectedCustomer != null && model.selectedCustomer['id'] != null){
                print('\n\nselectedCustomer ID = ${model.selectedCustomer['id']}');
                print('selectedCustomer = ${model.selectedCustomer}');
                await model.selectCustomerById(0, '');
                print('selectedCustomer = ${model.selectedCustomer}');
                model.setSelectCustomerForCartFlag(false);
              }
            },
            child: Icon(Icons.clear,color: Colors.black,),
            ):Icon(Icons.report_problem,color: Colors.black,),

        ],
        ),
      ),
    ),


  Divider(color: Colors.grey, height: 1,thickness: 1,),




  !model.otherPaymentFlag && !model.creditPaymentFlag
      ?
  Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                model.setBottomBarHide();

              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Icon(Icons.navigate_before),
                ),
              ),


            Text('Select Payment Mode'),
            Spacer(),
            OutlineButton(child: Text('Clear Cart'),
                              onPressed: ()async{
                                await model.cartState(model.paymentMode, false);
                                await model.setBottomBarHide();
                                await model.removeEditableItemFromCart(productDummy,"clear_cart");
                              },
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                          ),


          ],
          ),
        Row(
          children: <Widget>[
            RaisedButton(
                child: Text('CASH'),
                onPressed: () {
                  setState(() {
                    model.cartState('CASH',true);
                  });
                },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                ),
            Spacer(),
            RaisedButton(
                child: Text('CREDIT'),
                onPressed: () async {
                  await model.analyzeCredit(0.0, "credit", true);
                  setState(() {
                    model.cartState('CREDIT',true);
                  });
                },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                ),
            Spacer(),
            RaisedButton(
                child: Text('DEBIT/CREDIT CARD'),
                onPressed: () {
                  setState(() {
                    model.cartState('DEBIT/CREDIT CARD',true);
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
                    model.cartState('PAYTM', true);
                  });
                },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                ),
            Spacer(),
            RaisedButton(
                child: Text('BHIM UPI'),
                onPressed: () {
                  setState(() {
                    model.cartState('BHIM UPI', true);
                  });
                },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(19.0))
                ),
            Spacer(),
            RaisedButton(
                child: Text('OTHER'),
                onPressed: () {
                  setState(() {
                    model.cartState('OTHER', true);
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
  model.otherPaymentFlag
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
                  model.cartState(model.paymentMode, false);
                });
              },
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Row(children: <Widget>[
                    Icon(Icons.navigate_before), Text(model.paymentMode),
                  ],)
                  ),
              ),



            Spacer(),

            OutlineButton(child: Text('Clear Cart'),
                              onPressed: () async {
                                await model.cartState(model.paymentMode, false);
                                await model.setBottomBarHide();
                                await model.removeEditableItemFromCart(productDummy,"clear_cart");
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
                      setState(() async {
                        await model.cartState(model.paymentMode, false);
                        await model.analyzeCredit((model.cartTotalValue == null)
                                                      ? 0.0
                                                      : model.cartTotalValue,
                                                      model.creditModeBy, false);
                        await model.setBottomBarHide();
                        await model.generateInvoice(true, false);
                        await model.removeEditableItemFromCart(productDummy, 'clear_cart');
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
                  setState(() async {
                    await model.analyzeCredit((model.cartTotalValue == null)
                                                  ? 0.0
                                                  : model.cartTotalValue,
                                                  model.paymentMode, false);
                    await model.generateInvoice(false, false);
                    await model.removeEditableItemFromCart(productDummy, 'clear_cart');


                    await model.cartState(model.paymentMode, false);
                    await model.setBottomBarHide();
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
      :model.creditPaymentFlag
      ?
  Container(
    padding: EdgeInsets.symmetric(horizontal: 13),
    child: Column(
      children: <Widget>[
        Row(children: <Widget>[
          InkWell(
            onTap: () {
              model.cartState(model.paymentMode, false);
              model.creditModeFunc('',false);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Icon(Icons.navigate_before),
              ),
            ),

          Text(model.paymentMode,style:TextStyle(fontSize: 15)),
          Spacer(),
          OutlineButton(child: Text('Clear Cart'),
                            onPressed: () async {
                              await model.cartState(model.paymentMode, false);
                              await model.setBottomBarHide();
                              await model.removeEditableItemFromCart(productDummy,"clear_cart");
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
              width: 60,
              child: TextFormField(
                autofocus: false,
                initialValue: '0',
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                  ),
                onChanged: (text){
                  print(text.toString());
                  model.analyzeCredit(double.parse(text), 'credit', true);

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
                width: 70,
                child: Text(model.credit.toString())
                )
          ],

          ),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                  color:  model.creditModeBy == 'CASH'
                      ?Color(0xff4db6ac)
                      :Colors.white30,
//                ,
                  child: Text('CASH'),
                  onPressed: () {
                    model.creditModeFunc('CASH',true);
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
                  color:  model.creditModeBy == 'DEBIT/CREDIT CARD'
                      ?Color(0xff4db6ac)
                      :Colors.white30,
                  child: Text('DEBIT/CREDIT CARD'),
                  onPressed: () {
                    setState(() {
                      setState(() {
                        model.creditModeFunc('DEBIT/CREDIT CARD', true);
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
                    color:  model.creditModeBy == 'PAYTM'
                        ?Color(0xff4db6ac)
                        :Colors.white30,
                    child: Text('PAYTM'),
                    onPressed: () {
                      setState(() {
                        model.creditModeFunc('PAYTM', true);
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
                    color:  model.creditModeBy == 'BHIM UPI'
                        ?Color(0xff4db6ac)
                        :Colors.white30,
                    child: Text('BHIM UPI'),
                    onPressed: () {
                      setState(() {
                        model.creditModeFunc('BHIM UPI', true);
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
                    color:  model.creditModeBy == 'OTHER'
                        ?Color(0xff4db6ac)
                        :Colors.white30,
                    child: Text('OTHER'),
                    onPressed: () {
                      setState(() {
                        model.creditModeFunc('OTHER', true);
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
                      setState(() async {
                        if (model.creditModeFlag){
                          if (model.selectedCustomer.length != 0){
                            print(model.selectedCustomer);
                            await model.creditModeFunc('', false);
                            await model.cartState('CREDIT',false);
                            await model.setBottomBarHide();
                            await model.analyzeCredit((model.tempTotalAmountPaid == null)
                                                          ? 0.0
                                                          : model.tempTotalAmountPaid,
                                                          model.creditModeBy, true);
                            await model.generateInvoice(true, true);
                            await model.removeEditableItemFromCart(productDummy, 'clear_cart');
                            await model.creditModeFunc('', true);
                          }
                          else{
                            Fluttertoast.showToast(
                                msg: "!!  Have to Select a Customer",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.black87,
                                textColor: Colors.white,
                                fontSize: 16.0
                                );
                          }


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
                      setState(() async {
                        if (model.creditModeFlag){
                          if (model.selectedCustomer.length !=0){

                            await model.cartState('CREDIT', false);
                            await model.setBottomBarHide();
                            await model.analyzeCredit((model.tempTotalAmountPaid == null)
                                                          ? 0.0
                                                          : model.tempTotalAmountPaid,
                                                          model.creditModeBy, true);
                            await model.generateInvoice(false, true);
                            await model.removeEditableItemFromCart(productDummy, 'clear_cart');

                            await model.creditModeFunc('', false);
                          }
                          else{
                            Fluttertoast.showToast(
                                msg: "!! Have to Select a Customer",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.black87,
                                textColor: Colors.white,
                                fontSize: 16.0
                                );
                          }
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

                  model.bottomBarHide != true
                      ?
                  Align(
                    child: Container(
                      color: Colors.white,
                      child: lastBarSection,
                      ),
                    alignment: Alignment.bottomCenter,)
                      :
                  new Container(),
                  model.currentDisplayCustomProductPage
                      ?
                  Align(
                    child: CustomItem(),
                    alignment: Alignment.center,
                    )
                      :
                  new Container(),
                  model.selectCustomerForCartFlag
                      ?
                  SelectCustomer()
                      :
                  new Container(),
                ],
                );
            }),
        ),
      );
  }




}















//................................................................................................................................................................

//...............................................SelectCustomerSection.................................................................................................................



//manageCustomersModel customersModel = manageCustomersModel();




class SelectCustomer extends StatefulWidget {


  @override
  _SelectCustomer createState() => _SelectCustomer ();
}



class _SelectCustomer extends State<SelectCustomer> {

  TextEditingController _customerNameController;
  TextEditingController _phoneController;
  TextEditingController _searchKeyController;
  String searchKey;
  @override
  Widget build(BuildContext context) {




    return ScopedModelDescendant<NewAppStateModel> (

        builder: (context, child, model) {

          List<Container> _buildCustomerTiles(BuildContext context) {

            List<Map> customerList = model.tempCustomersInDatabaseToDisplay;
            if (customerList == null || customerList.isEmpty) {
              print('build tiles : $customerList');
              return const <Container>[];
            }
            print('build tiles : ' + customerList.toString());
            return List.generate(customerList.length, (index) {
              return Container(
                child: ListTile (
                  title: Text(customerList[index]['name']),
                  subtitle: Column(crossAxisAlignment:CrossAxisAlignment.start,
                                     children: <Widget>[
                                       Text(customerList[index]['phone_number']),
                                       Divider(color: Color(0xff429585), thickness: 1,height: 30,)
                                     ],),
                  onTap: () async {
                    print("\n\ncustomerList[index]['id'] = ${customerList[index]['id']}");
                    int id = int.parse(customerList[index]['id'].toString());
                    await model.selectCustomerById(int.parse(customerList[index]['id'].toString()), "cart");
                    var selectedCustomer =  await model.selectedCustomer;
                    print('\nSelected Customer from Select Customer stack  :   ... $selectedCustomer');
                    await model.setSelectCustomerForCartFlag(false);


                  },
                  ),
                );
            }).toList() ;
          }

          return Stack(
            children: <Widget>[
              Container(
//                  height:440,
//            width: 5000,
color: Colors.white,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: <Widget>[


          Container(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  height: 40,
                  width: 380,
                  child: TextField(
                    controller: _searchKeyController,

                    decoration: InputDecoration(
                      hintText: 'search by name or phone number',
                      filled: false,
                      prefixIcon: Icon(
                        Icons.search,
                        size: 14.0,
                        ),
                      ),
                    onChanged: (text) async{
                      await model.queryCustomerInDatabase("all", text);
                      await model.setAddCustomerForCartFlag(true);


                      //_buildCustomerTiles(context);
                    },

                    ),
                  ),
                )
              ),
          Container(height: 20,),
          Text('Select Customer',style: TextStyle(fontWeight: FontWeight.bold),),
          Divider(color: Colors.black12, thickness: 1, height: 20,),

          Column(
            children: _buildCustomerTiles(context),

            )


        ],
        ),
      )
),
              (model.tempCustomersInDatabaseToDisplay.length<=0) && model.addCustomerForCartFlag
                  ?
              Align(alignment: Alignment.centerRight,
                      child: Container(
//                  height:440,
//            width: 5000,
color: Colors.white,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: <Widget>[


          Container(
              height: 40,
              alignment: Alignment.centerLeft,
              child: Text('Create New', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),)
              ),
          Divider(color: Colors.black12, thickness: 1, height: 20,),
          Container(height: 20,),
          Text('Customer Phone Number', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
          TextFormField(
            initialValue: model.prefillField == 'phone'? model.PrefillFieldContentCustomer:'',
            decoration: InputDecoration(
                suffixIcon: Icon(Icons.phone)
                ),
            controller: _phoneController,
            maxLength: 10,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            ),
          Container(height: 20,),
          Text('Customer Name', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
          TextFormField(
            initialValue: model.prefillField == 'name'? model.PrefillFieldContentCustomer:'',
            controller: _customerNameController,

            ),
          Container(height: 20,),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
//                  width: 50,
child: RaisedButton(
  child: Text('CANCEL', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
  color: Color(0xffe48181),
  onPressed: ()async {
    await model.setAddCustomerForCartFlag(false);
//            addCustomer(_customerNameController.text, _phoneController.text);
  },
  ),
  flex: 2,
),

                Expanded(
                  child: Container(
                    width: 20,
                    ),
                  flex: 1,
                  ),
                Expanded(
//                  width: 50,
child: RaisedButton(
  child: Text('ADD', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
  color: Color(0xff81c784),
  onPressed: ()async {
    await model.addNewCustomer(_phoneController.text, _customerNameController.text, 'cart');
    print('customer added from the cart ... fkhgkhg');
//            addCustomer(_customerNameController.text, _phoneController.text);
  },
  ),
  flex: 2,
),

              ],
              ),
            )

        ],
        ),
      )
),)
                  :
              new Container()



            ],
            );
        }
        );



  }
}



//................................................................................................................................................................
//................................................................................................................................................................
//................................................................................................................................................................
//................................................................................................................................................................



//...................................CustomItemAddSection.............................................................................................................................


class CustomItem extends StatefulWidget {
//  CustomItem({this.id});
//  final bool id;
  @override
  _CustomItem createState() => _CustomItem();
}

class _CustomItem extends State<CustomItem> {
  final customProductNameController  = TextEditingController();
  final customMRPController  = TextEditingController();
  final customSPController  = TextEditingController();
  final customQTYController  = TextEditingController();
  final customSGSTController  = TextEditingController();
  final customCGSTController  = TextEditingController();
  final customCESSController  = TextEditingController();
  final customCategoryController = TextEditingController();
  final customBrandController = TextEditingController();

  @override
  void initState() {
    super.initState();
//    customProductNameController.addListener();
  }

  @override
  void dispose() {
    customProductNameController.dispose();
    super.dispose();
  }
  String _selectedCategory;
  String _selectedBrand;
  final _amountValidator = RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

  @override
  Widget build(BuildContext context) {
//    _print(category, msg:'category in product_grid_view.dart');
    return ScopedModelDescendant<NewAppStateModel> (
        builder: (context, child, model)
        {

          List categories = (model.finalListOfCategories.length > 0) ? model.finalListOfCategories : ["Select Category"];
          List brands = (model.finalListOfBrands.length > 0) ? model.finalListOfBrands : ["Select Brand"];

          print("$categories :::: $brands");
          return Stack(
            children: <Widget>[
              Opacity(
                  opacity: .8,
                  child: InkWell(
                    onTap: (){
                      model.updateFlagOfAddCustomItem(false);
                    },
                    child: Container(
                      height: 5000,
                      width: 3000,
                      color: Colors.black,
                      ),
                    )
                  ),
              Align(
                alignment: Alignment.center,
                child: Card(
                  borderOnForeground: false,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: 500,
                    width: 370,
                    child: ListView(
                      //                              crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: <Widget>[
                            Text('Add Custom Item',
                                 ),
                            Spacer(),
                            InkWell(
                              child: Icon(
                                Icons.clear,
                                size: 22.0,
                                ),
                              onTap: () {
                                setState(() {
                                  model.updateFlagOfAddCustomItem(false);
                                });

                              },
                              ),
                          ],
                          ),
                        Divider(color: Color(0xff429585),thickness: 1,height: 10,),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10, right:10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text('Name',
                                            ),
                                flex: 1,
                                ),
                              Expanded(
                                child: Container(
                                  width: 150,
                                  child: TextField(
                                    controller: customProductNameController,
                                    //                              decoration: InputDecoration(
                                    //                                focusedBorder: UnderlineInputBorder(
                                    //                                  borderSide: BorderSide(color: Colors.black),
                                    //                                  ),
                                    //                                ),
                                    ),
                                  ),
                                flex: 4,
                                ),

                            ],
                            ),
                          ),

                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10, right:10),
                          child:
                          Row(
                            children: <Widget>[

                              Expanded(
                                child:Text('MRP ',
                                           ),
                                flex: 1,
                                ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: TextField(
                                    controller: customMRPController,
                                    inputFormatters: [_amountValidator],
//
                                    keyboardType: TextInputType.numberWithOptions(
                                      decimal: true,
                                      signed: false,
                                      ),
                                    onChanged: (text){
                                      //                                          model.changeProductValue(text, product, 'mrp');
                                      setState(() {
                                      });

                                    },
                                    ),
                                  ),
                                flex: 2,
                                ),
                              Expanded(
                                child: Text(''),
                                flex: 1,
                                ),
                              Expanded(
                                child:Text('SP   ',
                                           ),
                                flex: 1,
                                ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: TextField(
                                    controller: customSPController,
                                    inputFormatters: [_amountValidator],
                                    keyboardType: TextInputType.numberWithOptions(
                                      decimal: true,
                                      signed: false,
                                      ),
                                    onChanged: (text){
                                      //                                          model.changeProductValue(text, product, 'mrp');

                                    },

                                    ),
                                  ),
                                flex: 2,
                                ),




                            ],
                            ),
                          ),

                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10, right:10),
                          child:
                          Row(
                            children: <Widget>[

                              Expanded(
                                child: Text('SGST   ',
                                            ),
                                flex: 1,
                                ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  width: 150,
                                  child: TextField(

                                    inputFormatters: [_amountValidator],
                                    controller: customSGSTController,
                                    keyboardType: TextInputType.numberWithOptions(
                                      decimal: true,
                                      signed: false,
                                      ),
                                    onChanged: (text){
                                      //                                          model.changeProductValue(text, product, 'mrp');

                                    },

                                    ),
                                  ),
                                flex: 2,
                                ),
                              Expanded(
                                child:Text('',
                                           ),
                                flex: 1,
                                ),
                              Expanded(
                                child:Text('CGST   ',
                                           ),
                                flex: 1,
                                ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  width: 150,
                                  child: TextField(
                                    inputFormatters: [_amountValidator],
                                    controller: customCGSTController,
                                    keyboardType: TextInputType.numberWithOptions(
                                      decimal: true,
                                      signed: false,
                                      ),
                                    onChanged: (text){
                                      //                                          model.changeProductValue(text, product, 'mrp');

                                    },
                                    ),
                                  ),
                                flex: 2,
                                ),




                            ],
                            ),
                          ),

                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10, right:10),
                          child:



                          Row(
                            children: <Widget>[

                              Expanded(
                                child:Text('CESS',
                                           ),
                                flex: 1,
                                ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  width: 15,
                                  child: TextField(
                                    inputFormatters: [_amountValidator],
                                    controller: customCESSController,
                                    keyboardType: TextInputType.numberWithOptions(
                                      decimal: true,
                                      signed: false,
                                      ),
                                    onChanged: (text){
                                      //                                          model.changeProductValue(text, product, 'mrp');

                                    },

                                    ),
                                  ),
                                flex: 2,
                                ),
                              Expanded(
                                child:Text(' ',
                                           ),
                                flex: 4,
                                ),




                            ],
                            ),
                          ),

                        Padding(
                            padding: EdgeInsets.only(top: 10, left: 10, right:10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: new DropdownButton<String>(
                                    items: categories.map((var value) {
                                      print("\n\n value dropdown = $value");
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(value),
                                        );
                                    }).toList(),
                                    value: _selectedCategory,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedCategory = newValue;
                                      });
                                    },
                                    hint: Text('Select Category'),
                                    ),
                                  flex: 4,
                                  ),

                              ],
                              )
                            ),
                        Padding(
                            padding: EdgeInsets.only(top: 10, left: 10, right:10),
                            child: Row(
                              children: <Widget>[

                                Expanded(
                                  child: new DropdownButton<String>(
                                    items: brands.map((var value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(value),
                                        );
                                    }).toList(),
                                    value: _selectedBrand,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedBrand = newValue;
                                      });
                                    },
                                    hint: Text('Select Brand'),
                                    ),
                                  flex: 4,
                                  )
                              ],
                              )
                            ),


                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10, right:10),
                          child:

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              RaisedButton(
                                //                                                    height: 50,
                                //                                                    width: 150,
                                child: Text('SUBMIT'),
                                  onPressed: ()async{
                                    if (customCESSController.text == ''){
                                      customCESSController.text = '0.0';
                                    }
                                    if (customCGSTController.text == ''){
                                      customCGSTController.text = '0.0';
                                    }
                                    if (customSGSTController.text == ''){
                                      customSGSTController.text = '0.0';
                                    }
                                    if(_selectedBrand == null){
                                      _selectedBrand = '';
                                    }
                                    if (_selectedCategory == null){_selectedCategory = '';
                                    }



                                    if (
                                    customProductNameController.text != '' &&
                                        customMRPController.text != '' &&
                                        customSPController.text != ''
                                    ){
                                      await model.addCustomItem(
                                        customProductNameController.text,
                                        customMRPController.text,
                                        customSPController.text,
                                        customCESSController.text,
                                        customCGSTController.text,
                                        customSGSTController.text,
                                        _selectedCategory,
                                        _selectedBrand,
                                        );
                                      await queryForAll(model, 'initStack', '', '');
                                      await model.updateFlagOfAddCustomItem(false);
                                    }
                                    else{
                                      Fluttertoast.showToast(
                                          msg: "!! Name, Mrp, SP must not be Empty",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIos: 1,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                          );
                                    }
                                  },

                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22.0)),
                                )
                            ],
                            ),
                          ),

                      ],
                      ),
                    ),
                  ),

                )
            ],
            );

        });
  }
}
//var screenSize = MediaQuery.of(context).size;












//................................................................................................................................................................
//................................................................................................................................................................
//................................................................................................................................................................






final Map productDummy = {"id": 1, "name": "custom dal"};

class NewShoppingCartRow extends StatefulWidget {
  NewShoppingCartRow({@required this.id}
      );
  final String id;
  @override
  _NewShoppingCartRow createState() => _NewShoppingCartRow();
}

class _NewShoppingCartRow extends State<NewShoppingCartRow> {


  FocusNode _focusNode;
//  TextEditingController _textFieldController;
//
//  @override
//  void initState() {
//    _focusNode = FocusNode();
//    _focusNode.addListener(() {
//      if (_focusNode.hasFocus) _textFieldController.clear();
//    });
//    super.initState();
//  }





  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(name: 'INR',
                                                    decimalDigits: 2,
                                                  //                                                      locale: Localizations.localeOf(context).toString()
                                                  );
    final localTheme = Theme.of(context);


    return ScopedModelDescendant<NewAppStateModel> (
        builder: (context, child, model) {

          final Map product =  model.getProductById(widget.id);
          final int quantity =  (model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['quantity'].runtimeType.toString() == 'String') ? double.parse(model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['quantity'].toString()) : model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['quantity'];
          final double sellingPrice =  (model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['sp'].runtimeType.toString() == 'String' && model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['sp'].runtimeType.toString() != '') ? double.parse(model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['sp'].toString()) : model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['sp'];
          final double MRP =  (model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['mrp'].runtimeType.toString() == 'String') ? double.parse(model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['mrp'].toString()) : model.editableListOfProductsInCart[model.editableListOfProductsInCart.indexWhere((p) => p['id'] == widget.id)]['mrp'];





          TextEditingController mrpController = TextEditingController(text: '${double.parse(product['mrp'].toString())}');
          TextEditingController spController = TextEditingController(text: '${double.parse(product['sp'].toString())}');
          TextEditingController quantityController = TextEditingController(text: '${quantity.toString()}');
          final _amountValidator = RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');
          bool hasSpOnChangeAnalysisDone = false, hasMrpOnChangeAnalysisDone = false, hasQuantityOnChangeAnalysisDone = false;
          String oldSpValue = spController.text;
          print("\n\n oldSpValue = $oldSpValue\n\n");

          updateSpValue(String oldSpValue) {
            spController.text = oldSpValue;
          }
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
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.clear,
                              size: 13.0,
                              ),
                            height: 25,width:40),


                        onTap: () async {
                          await model.removeEditableItemFromCart(product,  'remove_row');
                          await model.calculateCartTotalValue(model.Discount.toString());
                        },
                        ),


                    ],
                    ),
                  ),
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
                      child: TextFormField(

                        textAlign: TextAlign.center,
                        autofocus: false,
                        controller: mrpController,
                        inputFormatters: [_amountValidator],
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                          ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '${product['mrp'].toString()}'
                            ),
                        onChanged: (text){
                          print("\n\n Entered into on change MRP\n\n");
                          if (!hasMrpOnChangeAnalysisDone) {
                            print("\n\n mrpController after hasMrpOnChangeAnalysisDone = ${spController.hashCode} :::: spController = ${spController.value}");
                            hasMrpOnChangeAnalysisDone = true;

                            Future.delayed(const Duration(milliseconds: 45), () async{
                              //Future.delayed(const Duration(milliseconds: 70), (){

                              print("\n\n flagToCheckBarcodeState after 1 ms = ${model.flagToCheckBarcodeState}\n\n");
//                              print("\n\n oldSpValue = ${oldSpValue}\n\n");
                              if (model.flagToCheckBarcodeState) {
                                mrpController.text = product['sp'].toString();
                                print("\n\n mrpController inside if = ${mrpController.hashCode} :::: mrpController = ${mrpController.value}");
                                print("\n\n\nChecking product in widget = $product\n\n\n");
                              }
                              else {
                                print("\n\n mrpController inside else = ${mrpController.hashCode} :::: mrpController = ${mrpController.value}");
                                print("\n\n\nChecking product in widget = $product\n\n\n");
                                await model.changeProductValue(text, product, 'mrp');
                              }
//                              print("\n\n spController = ${spController.value}\n\n");
                              hasMrpOnChangeAnalysisDone = false;
                            });
                          }

                        },


                        ),
                      flex: 3,
                      ),
                    Expanded(
                      child: new TextField(
                        textAlign: TextAlign.center,
                        autofocus: false,
                        controller: spController,
                        inputFormatters: [_amountValidator],
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                          ),
                        onChanged: (text) async {

                          print("\n\n Entered into on change SP\n\n");
                          if (!hasSpOnChangeAnalysisDone) {
                            print("\n\n spController after hasSpOnChangeAnalysisDone = ${spController.hashCode} :::: spController = ${spController.value}");
                            hasSpOnChangeAnalysisDone = true;

                            Future.delayed(const Duration(milliseconds: 45), () async{
                              //Future.delayed(const Duration(milliseconds: 70), (){

                              print("\n\n flagToCheckBarcodeState after 1 ms = ${model.flagToCheckBarcodeState}\n\n");
//                              print("\n\n oldSpValue = ${oldSpValue}\n\n");
                              if (model.flagToCheckBarcodeState) {
                                spController.text = product['sp'].toString();
                                print("\n\n spController inside if = ${spController.hashCode} :::: spController = ${spController.value}");
                                print("\n\n\nChecking product in widget = $product\n\n\n");
                              }
                              else {
                                print("\n\n spController inside else = ${spController.hashCode} :::: spController = ${spController.value}");
                                print("\n\n\nChecking product in widget = $product\n\n\n");
                                await model.changeProductValue(text, product, 'sp');
                                await model.calculateCartTotalValue(model.Discount.toString());
                              }
//                              print("\n\n spController = ${spController.value}\n\n");
                              hasSpOnChangeAnalysisDone = false;
                            });
                          }



                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
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
                                  textAlign: TextAlign.center,
                                  autofocus: false,
                                  controller: quantityController,
                                  inputFormatters: [_amountValidator],
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: false,
                                    ),
                                  onChanged: (text){print("\n\n Entered into on change Quantity\n\n");
                                  if (!hasQuantityOnChangeAnalysisDone) {
                                    print("\n\n quantityController after hasMrpOnChangeAnalysisDone = ${spController.hashCode} :::: quantityController = ${quantityController.value}");
                                    hasQuantityOnChangeAnalysisDone = true;

                                    Future.delayed(const Duration(milliseconds: 45), () async{
                                      //Future.delayed(const Duration(milliseconds: 70), (){

                                      print("\n\n flagToCheckBarcodeState after 1 ms = ${model.flagToCheckBarcodeState}\n\n");
//                              print("\n\n oldSpValue = ${oldSpValue}\n\n");
                                      if (model.flagToCheckBarcodeState) {
                                        quantityController.text = product['sp'].toString();
                                        print("\n\n quantityController inside if = ${quantityController.hashCode} :::: quantityController = ${quantityController.value}");
                                        print("\n\n\nChecking product in widget = $product\n\n\n");
                                      }
                                      else {
                                        print("\n\n mrpController inside else = ${quantityController.hashCode} :::: mrpController = ${quantityController.value}");
                                        print("\n\n\nChecking product in widget = $product\n\n\n");
                                        await model.changeProductValue(text, product, 'quantity');
                                        await model.calculateCartTotalValue(model.Discount.toString());
                                      }
//                              print("\n\n spController = ${spController.value}\n\n");
                                      hasQuantityOnChangeAnalysisDone = false;
                                    });
                                  }

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
                                        onTap: () async {
                                          await model.addEditableProductToCart(product);
                                          await model.calculateCartTotalValue(model.Discount.toString());
                                        },
                                        ),
                                      ),
                                    InkWell(
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        size: 22.0,
                                        ),
                                      onTap: () async {
                                        await model.removeEditableItemFromCart(product, "reduce_quantity");
                                        await model.calculateCartTotalValue(model.Discount.toString());
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
                      child: Container(
                        padding: EdgeInsets.only(right: 10),
                        alignment: Alignment.centerRight,
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









//................................................................................................................................................................
//................................................................................................................................................................
//................................................................................................................................................................

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












//................................................................................................................................................................
//................................................................................................................................................................
//................................................................................................................................................................










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
          onTap: () async {
            final discount = (model.Discount == null) ? 0.0 : model.Discount;
//          print("entering add product to cart from quicklinks\n\n");
//          addProductToCart(model, product);
            print("entering add addEditableProductToCart to cart from quicklinks\n\n");
            await model.addEditableProductToCart(product);
            await model.calculateCartTotalValue(discount.toString());

//            Scaffold.of(context).showSnackBar(SnackBar(
//              content: Text('Product Added Successfully'),
//              ));

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






//................................................................................................................................................................
//................................................................................................................................................................
//................................................................................................................................................................









class NewShoppingCartSummary extends StatefulWidget {
  NewShoppingCartSummary({this.model});
  final NewAppStateModel model;

  @override
  _ShoppingCartSummary createState() => _ShoppingCartSummary();
}

class _ShoppingCartSummary extends State<NewShoppingCartSummary> {
//   AppStateModel model;
//   _ShoppingCartSummary({this.model});
  String isGstMandatory = "false";
  void getSharedPReference () async {
    print("\n\n Entered into getSharedPReference");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isGstMandatory = prefs.getString("is_gst_mandatory");
    print("\n\n isGstMandatory = $isGstMandatory :::: isGstMandatory type = ${isGstMandatory.runtimeType}");
  }

  @override
  void initState() {
    super.initState();
    getSharedPReference();
  }


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

        //isGstMandatory != "false" ? model.includeTaxesValue = true : model.includeTaxesValue=false;


        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox (
                height: 20,
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('GST'),
                  isGstMandatory != "false" ? Text("") : Switch(
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
        child: Text('SUBTOTAL'),
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





//................................................................................................................................................................
//................................................................................................................................................................
//................................................................................................................................................................











class KeyboardListener extends StatefulWidget {

  KeyboardListener();

  @override
  _RawKeyboardListenerState createState() => new _RawKeyboardListenerState();
}

class _RawKeyboardListenerState extends State<KeyboardListener> {




  @override
  initState() {
    super.initState();
  }

  //Handle when submitting
  void _handleSubmitted(String finalinput) {

    setState(() {
      //SystemChannels.textInput.invokeMethod('TextInput.hide'); //hide keyboard again
      //_controller.clear();
    });
  }


  _buildTextComposer() {

    return ScopedModelDescendant<NewAppStateModel> (
        builder: (context, child, model) {
          TextEditingController _controller = new TextEditingController();
          FocusNode _textNode;
          void _listener() {
            if (_textNode.hasFocus) {
              print("\n\n Focus moved to _textNode \n\n");
            }
            else {
              print("\n\n Focus removed from _textNode \n\n");
            }
          }


          _textNode = new FocusNode()..addListener(_listener);


          return new RawKeyboardListener(
              focusNode: _textNode,
              autofocus: true,
              onKey: (key) async {
                await FocusScope.of(context).requestFocus(_textNode);
                await model.processBarcode(key);
              },
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