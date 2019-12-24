import 'package:flutter/material.dart';



class RequestStocks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('REQUESTS STOCKS'),
        backgroundColor: Color(0xff429585),
        //          bottom: TabBar(
        //            // These are the widgets to put in each tab in the tab bar.
        //            tabs: _tabs.map((String name) => Tab(text: name)).toList(),
        //            ),
        ),
      body: FlatButton(
        child:  Image.asset(
          'assets/images/logo.png',
          width: 400.0,
          height: 240.0,
          fit: BoxFit.fitWidth,
          ),
        onPressed: (){
          Navigator.pop(context);
        },
        ),

      );
  }
}
