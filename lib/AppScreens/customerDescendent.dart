
import 'package:flutter/material.dart';
import '../model/manageCustomers.dart';
import '../model/queryForUI.dart';
import 'package:scoped_model/scoped_model.dart';



class CustomerDescendant extends StatelessWidget {
  CustomerDescendant({@required this.customerModel}
      );
  final manageCustomersModel customerModel;

  @override
  Widget build(BuildContext context) {
    print('\n\n customer page check     ...... ');
    return Scaffold(
        drawer: Drawer(
          child: ListView(

            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Container(
//                color: Color(0xff429585),
child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    Expanded(
      child: Container(
        child: Image.asset('assets/images/logo.png',
                             width: 120.0,
                             height: 90.0,
                             fit: BoxFit.fitWidth,
                             color: Colors.black87,
                           ),
        ),
      flex: 2,),
    Expanded(
      child: Icon(Icons.account_circle,
                    size:30,
                  ),
      flex: 1,),
    Expanded(
      child: Text('Store Name\n(9876567800)',
                    style: TextStyle(color: Colors.black,
                                     //                                                  fontSize: 22.0
                                     ),
                  ),
      flex: 1,
      )
  ],
  ),
  alignment: Alignment.center,
),
                decoration: BoxDecoration(
                  color: Color(0xff429585),
                  ),
                ),
              ListTile(
                title : Text('HOME'),
                leading: Icon(Icons.add_shopping_cart),
                onTap: (
                    ){
                  Navigator.pushNamed(context, '/');
                },
                ),
              Divider(color:Color(0xff429585) , thickness: 2, height: 20,),
              ListTile(
                title : Text('ORDERS'),
                leading: Icon(Icons.shopping_basket),
                onTap: (){

//                OrdersName();
                  print("\n\n ORDERS is clicked in menu bar\n\n");
                  Navigator.pushNamed(context, '/orders');
                },
                ),
              Divider(color:Color(0xff429585) , thickness: 2, height: 20,),
              ListTile(
                title : Text('CUSTOMERS'),
                leading: Icon(Icons.account_box),
                onTap: (){
                  Navigator.pushNamed(context, '/customers');
                },
                ),
              Divider(color:Color(0xff429585) , thickness: 2, height: 20,),
              ListTile(
                title : Text('REQUEST STOCKS'),
                leading: Icon(Icons.near_me),
                onTap: (){
                  Navigator.pushNamed(context, '/requestStocks');
                },
                ),
              Divider(color:Color(0xff429585) , thickness: 2, height: 20,),
              Container(
                height: 225,

                ),
              Divider(color:Color(0xff429585) , thickness: 2, height: 10,),
              Container(
                alignment: Alignment.topCenter,
                height: 240,
//              color: Color(0xff429585),
                child: ListTile(
                  title : Text('LogOut'),

                  leading: Icon(Icons.power_settings_new),
                  onTap: (){
//                  getSyncAPI();
                    Navigator.pushNamed(context, '/login');
                  },
                  ),
                ),
            ],
            ),
          ),

        appBar: AppBar(
          title: Text('Customers'),
          backgroundColor: Color(0xff429585),
          //          bottom: TabBar(
          //            // These are the widgets to put in each tab in the tab bar.
          //            tabs: _tabs.map((String name) => Tab(text: name)).toList(),
          //            ),
          ),
        body: SelectCustomer(customerModel: customerModel)

        );
  }
}

class SelectCustomer extends StatefulWidget {
  SelectCustomer({@required this.customerModel}
      );
  final manageCustomersModel customerModel;

  @override
  _SelectCustomer createState() => _SelectCustomer ();
}

class _SelectCustomer extends State<SelectCustomer> {

  List<Container> _buildCustomerTiles(BuildContext context, List<Map> customerList ) {
    if (customerList == null || customerList.isEmpty) {
      return const <Container>[];
    }
    return List.generate(customerList.length, (index) {
      return Container(
        child: ListTile (
          title: Text(customerList[index]['name']),
          subtitle: Text(customerList[index]['phone_number']),
          onTap: () async {

            int id = int.parse(customerList[index]['id'].toString());
            await widget.customerModel.selectCustomer(id, "customer_section");
            await widget.customerModel.getOrdersFromDatabase(id, "customer_credit_history");
//            model.setSelectCustomerForCartFlag(false);
          },
          ),
        );
    }).toList() ;
  }




  @override
  Widget build(BuildContext context) {



    widget.customerModel.queryCustomerInDatabase('all', '');
//    print('gayar in UI\n\n' + dummyCustomersList.toString());

    return ScopedModel<manageCustomersModel>(
        model:  widget.customerModel,
        child: ScopedModelDescendant<manageCustomersModel> (


            builder: (context, child, model) {


              return Container(
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
                  width: 280,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'search',
                      filled: false,
                      prefixIcon: Icon(
                        Icons.search,
                        size: 18.0,
                        ),
                      ),
                    onChanged: (text) async{
                      model.queryCustomerInDatabase("all", text);
                    },

                    ),
                  ),
                )
              ),
          Text('Select Customer'),
          Divider(color: Colors.black12, thickness: 3, height: 20,),

          Column(
            children: _buildCustomerTiles(context, widget.customerModel.tempCustomersInDatabaseToDisplay),

            )


        ],
        ),
      )
);
            }
            )
        );



  }
}
