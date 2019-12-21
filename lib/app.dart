
import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import 'customer.dart';
import 'orders.dart';
//import 'AppScreens/Customers.dart';
import 'package:connectivity/connectivity.dart';
import 'testBarcodeScanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/syncData.dart';

import 'package:flutter/services.dart';






class DefaultWidget {
  final Widget defaultWidget;
  const DefaultWidget({this.defaultWidget});
}

class ExpressStoreApp extends StatefulWidget {
  final DefaultWidget defaultWidgetHome;

  // In the constructor, require a Todo.
  ExpressStoreApp({Key key, @required this.defaultWidgetHome}) : super(key: key);


  @override
  _ExpressStoreAppState createState() => _ExpressStoreAppState();
}
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class _ExpressStoreAppState extends State<ExpressStoreApp>
    with SingleTickerProviderStateMixin {

  var _connectionStatus = 'Unknown';
  Connectivity connectivity;

//  zxc
//  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivity = new Connectivity();
//    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) async {
          _connectionStatus = result.toString();
          print(_connectionStatus);
          if (_connectionStatus == "ConnectivityResult.wifi" ||
              _connectionStatus == "ConnectivityResult.mobile") {
            SharedPreferences is_post_sync_successful = await SharedPreferences.getInstance();



            var CheckpostSyncStatus = is_post_sync_successful.getBool('postSyncStatus');
            var CheckgetSyncStatus = is_post_sync_successful.getBool('getSyncStatus');

            if (CheckpostSyncStatus == false) {
              //zxc
              await PostSyncAPI();
            }
            if (CheckgetSyncStatus == false) {
              await getSyncAPI();
            }
          }
        });



    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
      value: 1.0,
      );
  }

  @override
  void dispose() {
    print("dispose function called in app.dart");

//    zxc
//    subscription.cancel();
    super.dispose();
  }


  // Controller to coordinate both the opening/closing of backdrop and sliding
  // of expanding bottom sheet.
  AnimationController _controller;





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

