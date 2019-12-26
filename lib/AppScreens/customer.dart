
import 'package:flutter/material.dart';
import '../model/manageCustomers.dart';
import '../model/queryForUI.dart';
import 'package:scoped_model/scoped_model.dart';



List<Map<String, dynamic>> dummyCustomersList =
[
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
}
];

class Customer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print('\n\n customer page check     ...... ');
    return Scaffold(

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

manageCustomersModel pageCustomersModel = new manageCustomersModel();
class SelectCustomer extends StatefulWidget {


  @override
  _SelectCustomer createState() => _SelectCustomer ();
}

class _SelectCustomer extends State<SelectCustomer> {

  List<Container> _buildCustomerTiles(BuildContext context, List<Map<String,dynamic>> customerList ) {
    if (customerList == null || customerList.isEmpty) {
      return const <Container>[];
    }
    return List.generate(customerList.length, (index) {
      return Container(
        child: ListTile (
          title: Text(customerList[index]['name']),
          subtitle: Text(customerList[index]['phone_number']),
          onTap: (){

//            model.setSelectCustomerForCartFlag(false);
          },
          ),
        );
    }).toList() ;
  }




  @override
  Widget build(BuildContext context) {

    getCustomersG(pageCustomersModel);

//    print('gayar in UI\n\n' + dummyCustomersList.toString());

    return ScopedModel<manageCustomersModel>(
        model:  pageCustomersModel,
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
//                      search customer textfield
                                  },

                                  ),
                                ),
                              )
                            ),
                        Text('Select Customer'),
                        Divider(color: Colors.black12, thickness: 3, height: 20,),

                        Column(
                          children: _buildCustomerTiles(context, model.tempCustomersInDatabaseToDisplay),

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

