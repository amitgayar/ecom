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
//import 'package:scoped_model/scoped_model.dart';
import 'app.dart';
import 'package:cron/cron.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'model/app_state_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

      runApp(
        ExpressStoreApp(),
  );
}



//
//
//
//void main() async {
//
//  WidgetsFlutterBinding.ensureInitialized();
//  SystemChrome.setPreferredOrientations(
//      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//
//
//  SharedPreferences cronFrequency = await SharedPreferences.getInstance();
//
//  final getFrequencyCron = new Cron();
//  getFrequencyCron.schedule(new Schedule.parse('0 0 * * *'), () async {
//    print('every three minutes');
//    if (cronFrequency.getString("authentication_token") != null){
//      await getFrequencyAPI();
//    }
//    else {
//      cronFrequency.setBool("is_login_true", false);
//      navigatorKey.currentState.pushNamed('/login');
//    }
//
//
//
//  });
//
//
//
//
//
//  Widget _defaultHome;
//  if (cronFrequency.getString("authentication_token") != null){
//    _defaultHome = new NewsListPage();
//  }
//  else {
//    _defaultHome = new LoginPage();;
//  }