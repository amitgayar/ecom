
import 'package:flutter/material.dart';
//import 'package:mpos/customer.dart';
//import 'package:mpos/shopping_cart.dart';
import 'homeshrine.dart';
import 'login.dart';
import 'shopping_cart.dart';
import 'customer.dart';





class ExpressStoreApp extends StatefulWidget {
  @override
  _ExpAppState createState() => _ExpAppState();
}

class _ExpAppState extends State<ExpressStoreApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExpStore',
//      initialRoute: '/login',
//      onGenerateRoute: _getRoute,
      routes: {
        '/login': (context) => LoginPage(),
        '/': (context) => HomePage(),
        '/cart': (context) => ShoppingCartPage(),
        '/customer' : (context) => Customer(),
        '/addCustomer': (context) => AddCustomer(),
      },
//      theme: new ThemeData(
//              brightness: Brightness.dark,                        // new
//      ),
    );
  }
}

//Route<dynamic> _getRoute(RouteSettings settings) {
//  if (settings.name != '/login') {
//    return null;
//  }
//
//  return MaterialPageRoute<void>(
//    settings: settings,
//    builder: (context) => LoginPage(),
//    fullscreenDialog: true,
//  );
//}

