
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../model/manageCustomers.dart';
import 'customerDescendent.dart';
manageCustomersModel customerModel = new manageCustomersModel();

//----------------Model initialization for cart 1


//---------------- CLASS for TabBar Heading or Cart Status







//--------------------- CLASS to exploit ScopedModel for the CART

class customer extends StatefulWidget {
  @override
  _customer createState() => _customer();
}

class _customer extends State<customer> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(

        child: ScopedModel<manageCustomersModel>(
          model: customerModel,
          child: CustomerDescendant(customerModel: customerModel),
          ),
        ),
      );
  }

}









