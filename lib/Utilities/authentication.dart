import 'package:flutter/material.dart';
import 'dart:io' show Directory;
import '../Databases/Database.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';



class processPhoneNumber {
  final String phoneNumber;

  processPhoneNumber({this.phoneNumber});

  factory processPhoneNumber.fromJson(Map<String, dynamic> json) {
    return processPhoneNumber(
      phoneNumber: json['phone_number'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["phone_number"] = phoneNumber;
    print(map);

    return map;
  }
}

submitAuthenticationDetails(String url, {Map body}) async {

  print("POST REQUEST Received to submit authentication details");
  Map<String, String> headers = {"Content-type": "application/json"};
  try {
    print("check Internet");
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      try {
        print("post was not made to url: $url ::: to body = $body");
        http.Response response = await http.post(url, body: body);
        print("post was made");
        return (response);
      }
      on SocketException catch (_) {
        print('\n\n connction Error');
        return (null);
      }

    }
  } on SocketException catch (_) {
    print('not connected');
    return (null);
  }



}


class processOTP {
  final String OTP;
  final String phoneNumber;

  processOTP({this.OTP, this.phoneNumber});

  factory processOTP.fromJson(Map<String, dynamic> json) {
    return processOTP(
      OTP: json['otp'],
      phoneNumber: json['phone_number'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["otp"] = OTP;
    map["phone_number"] = phoneNumber;
    print("SubmitOTP done $map");

    return map;
  }
}