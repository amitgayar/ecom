import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../model/app_state_model.dart';
import 'package:express_store/service_locator.dart';
import 'customer.dart';
import 'orders.dart';
import 'drawer_express_store.dart';

NewAppStateModel customerPlusOrderModel = new NewAppStateModel();


class CustomerPlusOrder extends StatefulWidget {
  CustomerPlusOrder({this.page});
  String page;
  @override
  _CustomerPlusOrder createState() => _CustomerPlusOrder();


}

class _CustomerPlusOrder extends State<CustomerPlusOrder> {


  @override
  void initState(){
    if (widget.page == 'customers'){
      customerPlusOrderModel.queryCustomerInDatabase('all', "");
    }
    else{
      customerPlusOrderModel.filterOrders('', '', '', '', false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

//    customerModel.queryCustomerInDatabase('all', "");
    return Scaffold(
      drawer: DrawerExpress(),

      appBar: AppBar(
        title: Text(widget.page),
        backgroundColor: Color(0xff429585),
        ),

      body: SafeArea(

        child: ScopedModel<NewAppStateModel>(
          model: customerPlusOrderModel,
          child: widget.page == 'customers'?
          SelectCustomer()
              :
              OrderTiles(),
          ),
        ),
      );
  }

}
