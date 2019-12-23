
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../model/app_state_model.dart';
import 'CartDescendant.dart';
import 'package:intl/intl.dart';


//----------------Model initialization for cart 3

NewAppStateModel cartModel3 = NewAppStateModel();





//---------------- CLASS for TabBar Heading or Cart Status





class HeadingOfCart3 extends StatelessWidget {
  HeadingOfCart3({ @required this.head});
  final int head  ;
  @override
  Widget build(BuildContext context) {

    final formatter = NumberFormat.simpleCurrency(name: 'INR',
                                                      decimalDigits: 2, locale: Localizations.localeOf(context).toString());


    return ScopedModel<NewAppStateModel>(
        model: cartModel3,
        child: ScopedModelDescendant<NewAppStateModel>(
            builder: (context, child, model)
            {
              return Container(
                child: head == 2
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



//--------------------- CLASS to exploit ScopedModel for the CART 3

class Cart3 extends StatefulWidget {
  @override
  _Cart3 createState() => _Cart3();
}

class _Cart3 extends State<Cart3> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(

        child: ScopedModel<NewAppStateModel>(
          model: cartModel3,
          child: CartDescendant(),
          ),
        ),
      );
  }

}









