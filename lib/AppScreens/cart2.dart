
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../model/app_state_model.dart';
import 'CartDescendant.dart';
import 'package:intl/intl.dart';
import '../model/manageCustomers.dart';


//----------------Model initialization for cart 2

NewAppStateModel cartModel2 = NewAppStateModel();
manageCustomersModel customerModelCart2 = new manageCustomersModel();


//---------------- CLASS for TabBar Heading or Cart Status



class HeadingOfCart2 extends StatelessWidget {
  HeadingOfCart2({ @required this.head});
  final int head  ;
  @override
  Widget build(BuildContext context) {

    return ScopedModel<NewAppStateModel>(
        model: cartModel2,
        child: ScopedModelDescendant<NewAppStateModel>(
            builder: (context, child, model)
            {

              final formatter = NumberFormat.simpleCurrency(name: 'INR',
                                                                decimalDigits: 2, locale: Localizations.localeOf(context).toString());

              return Container(
                child: head == 1
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




//--------------------- CLASS to exploit  ScopedModel for the CART 2

class Cart2 extends StatefulWidget {
  @override
  _Cart2 createState() => _Cart2();
}

class _Cart2 extends State<Cart2> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(

        child: ScopedModel<NewAppStateModel>(
          model: cartModel2,
          child: CartDescendant(customerModel: customerModelCart2),
          ),
        ),
      );
  }

}









