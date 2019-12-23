
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cron/cron.dart';
import 'services/syncData.dart';
import 'app.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'dart:ui' as ui;




void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);


  SharedPreferences cronFrequency = await SharedPreferences.getInstance();

  final getFrequencyCron = new Cron();
  getFrequencyCron.schedule(new Schedule.parse('0 0 * * *'), () async {
    print('every three minutes');
    if (cronFrequency.getString("authentication_token") != null){
      await getFrequencyAPI();
    }
    else {
      cronFrequency.setBool("is_login_true", false);
      navigatorKey.currentState.pushNamed('/login');
    }



  });





  Widget _defaultHome;
  if (cronFrequency.getString("authentication_token") != null){
    _defaultHome = new NewsListPage();
  }
  else {
    _defaultHome = new LoginPage();;
  }




  runApp(
      ExpressStoreApp(
          defaultWidgetHome: DefaultWidget(
            defaultWidget: _defaultHome,)
  ));
}
//Color(0xff429585)