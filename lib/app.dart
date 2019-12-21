
import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import 'customer.dart';
import 'orders.dart';





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
        '/cart': (context) => new Container(),
        '/customers' : (context) => Customer(),
        '/addCustomer': (context) => AddCustomer(),
        '/orders' : (context) => Orders(),
        '/requestStocks' : (context) => Orders(),
        '/logout' : (context) => Orders(),

      },
      theme: new ThemeData(
              brightness: Brightness.light,                        // new
      ),
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

