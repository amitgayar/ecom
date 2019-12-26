
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../model/manageCustomers.dart';
import 'customerDescendent.dart';
import '../model/app_state_model.dart';
NewAppStateModel customerModel = new NewAppStateModel();

//----------------Model initialization for cart 1


//---------------- CLASS for TabBar Heading or Cart Status




List<Map<String, dynamic>> dummyCustomersList = [
{
"id": 1,
"name": "Amit",
"gender": "M",
"phone_number": "9878923030",
"credit_balance": 100,
"total_orders": 10,
"total_spent": 2000,
"average_spent": 200,
"total_discount": 50,
"avg_discount_per_order": 5
},
{
"id": 2,
"name": "Mohit",
"gender": "M",
"phone_number": "9711575088",
"credit_balance": 20,
"total_orders": 50,
"total_spent": 20000,
"average_spent": 400,
"total_discount": 1000,
"avg_discount_per_order": 20
},
{
"id": 3,
"name": "Manav",
"gender": "M",
"phone_number": "8368856340",
"credit_balance": 110,
"total_orders": 10,
"total_spent": 10000,
"average_spent": 1000,
"total_discount": 1000,
"avg_discount_per_order": 1000
},
  {
    "id": 4,
    "name": "Sumit",
    "gender": "M",
    "phone_number": "9878923031",
    "credit_balance": 0,
    "total_orders": 10,
    "total_spent": 2000,
    "average_spent": 200,
    "total_discount": 50,
    "avg_discount_per_order": 5
  },
];


//--------------------- CLASS to exploit ScopedModel for the CART

class Customer extends StatefulWidget {
  @override
  _Customer createState() => _Customer();
}

class _Customer extends State<Customer> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(

        child: ScopedModel<NewAppStateModel>(
          model: customerModel,
          child: CustomerDescendant(),
          ),
        ),
      );
  }

}



class CustomerDescendant extends StatelessWidget {


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
        body: SelectCustomer()

        );
  }
}

class SelectCustomer extends StatefulWidget {

  @override
  _SelectCustomer createState() => _SelectCustomer ();
}


class _SelectCustomer extends State<SelectCustomer> {

String selectedType = 'customer';
String selectedHistory = 'credit';
String selectedCustomer = '';
int selectedCustomerID = 0 ;
bool isCostumerSelected = false;

 void pageState({String type:'',String customer :'', int customerID}){
  selectedType = type;
  selectedCustomer = customer;
  selectedCustomerID = customerID;
 }

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
                  subtitle: Text(customerList[index]['phone_number']),
                  trailing:
//                  selectedType == 'credit'
//                      ?
                  Text('Rs. 230', style: TextStyle(color: Colors.red),),
//                  : new Container(),
                  onTap: ()  {
                   setState(() {

//                     int id = int.parse(customerList[index]['id'].toString());
//                     await model.selectCustomer(id, "cart");
//                     var selectedCustomer = await model.selectedCustomer;
//                     pageState(customer: 'amit');
                     isCostumerSelected = true;

                   });


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
                      //_buildCustomerTiles(context);
                    },

                    ),
                  ),
                )
              ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
//                  color: Color(0xff429585),
                  child: FlatButton(
                      child: Text('Customers'),
                      color: selectedType == 'customer'
                      ?
                      Colors.greenAccent
                      :
                      Colors.white,
                      onPressed:(){

                        setState(() {
                          selectedType = 'customer';
                        });

                      }
                      ),
                  ),
                flex: 1,
                ),
              Expanded(
                child: FlatButton(
                    child: Text('Credit'),
                    color: selectedType == 'credit'
                        ?
                    Colors.greenAccent
                        :
                    Colors.white,
                    onPressed:(){
                    setState(() {
                      selectedType = 'credit';
                    });

                    }
                    ),
                flex: 1,
                ),
            ],
            ),

          Column(
            children: _buildCustomerTiles(context),

            )


        ],
        ),
      )
),
              isCostumerSelected
                  ?
              Container(
                height: 5000,
                width: 5000,
                color: Colors.white,
                child: IconButton(
                    icon: Icon(Icons.arrow_back),
                                  onPressed: (){
                  setState(() {
                    isCostumerSelected = false;
                  });
                }
                ),
              )
                  :new Container()

            ],
          );

        }
        );



  }
}




