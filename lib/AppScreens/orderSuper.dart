
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../model/app_state_model.dart';
import 'orders.dart';
NewAppStateModel orderModel = new NewAppStateModel();

//----------------Model initialization for cart 1


//---------------- CLASS for TabBar Heading or Cart Status







//--------------------- CLASS to exploit ScopedModel for the CART

class orderName extends StatefulWidget {
  @override
  _orderName createState() => _orderName();
}

class _orderName extends State<orderName> {

  @override
  Widget build(BuildContext context) {

//    orderModel.filterOrders("", "", "", "", false);
    return Scaffold(
      body: SafeArea(

        child: ScopedModel<NewAppStateModel>(
          model: orderModel,
          child: OrderDescendent(orderModel: orderModel),
        ),
      ),
    );
  }

}










