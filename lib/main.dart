//import 'package:flutter/material.dart';
//import 'package:mpos/screens/account.dart';
//import 'package:mpos/screens/home2.dart';
//import 'package:mpos/screens/settings.dart';
////import 'package:mpos/screens/tabs.dart';
//
//void main() {
//  runApp(MaterialApp(
//    debugShowCheckedModeBanner: false,
//    home: HomeScreen2(), // route for home is '/' implicitly
////    theme: ThemeData(
////      primarySwatch: Colors.brown,
////      accentColor: Colors.lightBlueAccent,
////      backgroundColor: Colors.white,
////    ),
//    routes: <String, WidgetBuilder>{
//      // define the routes
//      SettingsScreen.routeName: (BuildContext context) => SettingsScreen(),
//      AccountScreen.routeName: (BuildContext context) => AccountScreen(),
//    },
//  ));
//}


//main shrine app



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

import 'app.dart';
import 'model/app_state_model.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  AppStateModel model = AppStateModel();
//  model.loadProducts();

  runApp(
    ScopedModel<AppStateModel>(
      model: model,
      child: ExpressStoreApp(),
    ),
  );
}
