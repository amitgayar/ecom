//import 'package:flutter/material.dart';
//import 'dart:io' show Directory;
//import '../Databases/Database.dart';
//import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class Post {
  final String phoneNumber;

  Post({this.phoneNumber});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
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

createPost(String url, {Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return statusCode;
  });
}


class SubmitOTP {
  final String OTP;
  final String phoneNumber;

  SubmitOTP({this.OTP, this.phoneNumber});

  factory SubmitOTP.fromJson(Map<String, dynamic> json) {
    return SubmitOTP(
      OTP: json['OTP'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["OTP"] = OTP;
    map["phoneNumber"] = phoneNumber;
    print(map);

    return map;
  }
}