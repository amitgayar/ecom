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
      phoneNumber: json['phoneNumber'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["phoneNumber"] = phoneNumber;
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
      return http.post(url, body: body);
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
      OTP: json['OTP'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["OTP"] = OTP;
    map["phoneNumber"] = phoneNumber;
    print("SubmitOTP done $map");

    return map;
  }
}