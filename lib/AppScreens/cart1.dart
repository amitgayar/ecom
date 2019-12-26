
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../model/app_state_model.dart';
import 'CartDescendant.dart';
import 'package:intl/intl.dart';
import '../model/manageCustomers.dart';


//----------------Model initialization for cart 1

NewAppStateModel cartModel1 = NewAppStateModel();
manageCustomersModel customerModelCart1 = new manageCustomersModel();
//---------------- CLASS for TabBar Heading or Cart Status






class HeadingOfCart1 extends StatelessWidget {
  HeadingOfCart1({ @required this.head});
 final int head  ;
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(name: 'INR',
                                                      decimalDigits: 2, locale: Localizations.localeOf(context).toString());


    return ScopedModel<NewAppStateModel>(
        model: cartModel1,
        child: ScopedModelDescendant<NewAppStateModel>(
            builder: (context, child, model)
            {
              return Container(
                child: head == 0
                    ?
                Text('Active',
                         style: TextStyle(fontWeight: FontWeight.bold))
                    :
                Container(
                    margin: EdgeInsets.all(10),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Text(model.totalCartQuantity == 0 || model.totalCartQuantity == null ?
                             'No Item'
                                 :
                             formatter.format(model.cartTotal) + ' (${model.totalCartQuantity})',

                             ),


                      ],
                      )
                    )
                ,

                );
            }
            )


        );
  }
}

//--------------------- CLASS to exploit ScopedModel for the CART

class Cart1 extends StatefulWidget {
  @override
  _Cart1 createState() => _Cart1();
}

class _Cart1 extends State<Cart1> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(

        child: ScopedModel<NewAppStateModel>(
          model: cartModel1,
          child: CartDescendant(customerModel: customerModelCart1),
          ),
        ),
      );
  }

}









