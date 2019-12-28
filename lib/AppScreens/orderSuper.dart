
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../model/app_state_model.dart';
import 'orders.dart';
NewAppStateModel orderModel = new NewAppStateModel();




class OrderName extends StatefulWidget {
  @override
  _OrderName createState() => _OrderName();
}

class _OrderName extends State<OrderName> {

  @override
  Widget build(BuildContext context) {

//    orderModel.filterOrders("", "", "", "", false);
    return Scaffold(
      body: SafeArea(

        child: ScopedModel<NewAppStateModel>(
          model: orderModel,
          child: OrderDescendant(orderModel: orderModel),
        ),
      ),
    );
  }

}










