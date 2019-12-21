
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import '../app.dart';
import 'package:shared_preferences/shared_preferences.dart';



Future<http.Response> dbSyncGet(String url) async {

  SharedPreferences cronFrequency = await SharedPreferences.getInstance();

    print("Authentication Token ${cronFrequency.getString("authentication_token")}");
    if (cronFrequency.getString("authentication_token") == null || cronFrequency.getString("authentication_token") == "") {
      navigatorKey.currentState.pushNamed('/login');
    }
    else {
      print("GET REQUEST Received");
      Map<String, String> headers = {"Content-type": "application/json", HttpHeaders.authorizationHeader: "wm_auth_token : ${cronFrequency.getString("authentication_token")}"};
      try {
        print("check Internet");
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('connected');
          print(url);
          Response response = await http.get(
            url,
            // Send authorization headers to the backend.
            headers: headers,
          );
          print("cfgvhbjnkytghbjknmgybuhjnmbiujkn mbhjbn  ${response.body}");
          return response;
        }
      } on SocketException catch (_) {
        print('not connected');
        return (null);
      }
    }







}

Future<http.Response> dbSyncPost(String url, String body) async {

  SharedPreferences cronFrequency = await SharedPreferences.getInstance();
  print("Authentication Token ${cronFrequency.getString("authentication_token")}");
  if (cronFrequency.getString("authentication_token") == null || cronFrequency.getString("authentication_token") == "") {
    navigatorKey.currentState.pushNamed('/login');
  }
  else {
    print("POST REQUEST Received");
    Map<String, String> headers = {
      "Content-type": "application/json",
      HttpHeaders.authorizationHeader: "wm_auth_token : ${cronFrequency
          .getString("authentication_token")}"
    };

    try {
      print("check Internet");
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return http.post(url, headers: headers, body: body);
      }
    } on SocketException catch (_) {
      print('not connected');
      return (null);
    }
  }

}