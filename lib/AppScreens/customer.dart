
import 'package:flutter/material.dart';



class Customer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: Text('Customers'),
          backgroundColor: Color(0xff429585),
          //          bottom: TabBar(
          //            // These are the widgets to put in each tab in the tab bar.
          //            tabs: _tabs.map((String name) => Tab(text: name)).toList(),
          //            ),
          ),
        body: Card(
          child: IconButton(
            icon: Icon(Icons.account_box),
            onPressed: (){
              Navigator.pushNamed(context, '/');
            },
            ),
          )
        );
  }
}

