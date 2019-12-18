//import 'package:flutter/material.dart';
//import 'dart:io' show Directory;
//import '../Databases/Database.dart';
//import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
//import 'dart:convert';
import 'dart:async';
import 'dart:io';



Future<http.Response> dbSyncGet(String url) async {
  return http.get(
    url,
    // Send authorization headers to the backend.
    headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here"},
  );
}