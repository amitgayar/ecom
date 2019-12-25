
import 'package:flutter/material.dart';



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
        body: Container(
          child:
//          Image(image: AssetImage('images/logo.png'))
          Image.asset(
          'assets/images/logo.png',
          width: 400.0,
          height: 240.0,
          fit: BoxFit.fitWidth,
          ),
//          IconButton(
//            icon: Icon(Icons.account_box),
//            onPressed: (){
//              Navigator.pushNamed(context, '/');
//            },
//            ),
          )
        );
  }
}

