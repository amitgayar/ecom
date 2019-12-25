// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io' show Directory;
import 'Utilities/authentication.dart';
import 'Databases/Database.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login_OTP.dart';
import 'Constants/const.dart' as constants;


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;
  int validateUsername = 0;
  int _validatePassword = 0;



  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  // Function to insert data in DB
/*//  void _insert() async {
//    // row to insert
//    String userName = _usernameController.text;
//    String password = "123456";
//    Map<String, dynamic> row = {
//      DatabaseHelper.columnName : userName,
//      DatabaseHelper.columnPassword  : password
//    };
//    final id = await dbHelper.insert(row);
//    print('inserted row id: $id');
//    print('inserted row id: $password');
//    print('inserted row id: $userName');
//  }*/




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center ,
//          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                              onTap: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                        }
                        },
                          child:Container(
                            alignment: Alignment.center,
                            child: Image.asset('assets/images/logo.png',
                               width: 220.0,
                               height: 190.0,
                               fit: BoxFit.fitWidth,
                               color: Color(0xff429585),
                             ),

                                 ),
                              ),







                flex: 10,
            ),
            Expanded(
              child: Container(
                width: 260,
                height: 60,
                child: Column(children: <Widget>[
                  PrimaryColorOverride(
                    child: Text(
                      'Enter Your Mobile Number',
                      style: new TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      ),
                    ),

                  PrimaryColorOverride(
                    child: TextField(
                      controller: _usernameController,
                      textAlign: TextAlign.center,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        hintText: "1234567890",
                        errorText: (validateUsername == 1) ? "Mobile Number can not be empty" : ((validateUsername == 2) ? "Mobile Number should be of length 10" : null),
                        ),



                      ),
                    ),
                ],),
                ),
                flex: 5,
            ),
           Expanded(
             child: RaisedButton(
               child: const Text('Get OTP'),
               color: Color(0xff4db6ac),
               elevation: 8.0,
               shape: const RoundedRectangleBorder(
                 borderRadius: BorderRadius.all(Radius.circular(30.0)),
                 ),
               onPressed: () async {
                 setState(() {
                   if (_usernameController.text.isEmpty)
                   {
                     validateUsername = 1;
                     print("can not be empty");
                   }
                   else if (_usernameController.text.length < 10)
                   {
                     validateUsername = 2;
                     print("shoulb be of 10 length");
                   }
                   else
                   {
                     validateUsername = 0;
                   }
                 });

                 //_insert();
                 //String phoneNumber = _usernameController.text;
                 //dbHelper.queryRowCount(phoneNumber);



                 http.Response p;
                 if (validateUsername == 0){
                   // Call API to send OTP to the input number
                   processPhoneNumber newPost = new processPhoneNumber(
                       phoneNumber: _usernameController.text);
                   p = await submitAuthenticationDetails(
                       constants.getOTP,
                       body: newPost.toMap());
                   print("\n\n Status code = ${p.statusCode}");



                   //Check API Status
                   if(p.statusCode == 200)
                   {
                     // If status is 200 navigate to OTP screen
                     var route = new MaterialPageRoute(
                       builder: (BuildContext context) =>
                       new LoginPageOTP(
                           phone_for_OTP: Data(
                             phone_number_OTP: _usernameController.text,

                             )
                           ),
                       );

                     Navigator.of(context).push(route);
                   }
                   else {

                     // If status is not 200 nShow error
                     setState(() {
                       validateUsername = 3;
                     });
                   }
                 }



                 print(_usernameController.text);
                 //print(validateUsername);
                 //print(_passwordController.text);
               },
               ),
             flex: 1,
             ),
Expanded(
  child: new Container(
    height: 300,
  ),
  flex: 2,
),

//            ButtonBar(
//              children: <Widget>[
////                FlatButton(
////                  child: const Text('CANCEL'),
////                  shape: const BeveledRectangleBorder(
////                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
////                  ),
////                  onPressed: () {
////                    _usernameController.clear();
////                    _passwordController.clear();
////                  },
////                ),
//
//              ],
//            ),
          ],
        ),
      ),
    );
  }
}

class PrimaryColorOverride extends StatelessWidget {
  const PrimaryColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(primaryColor: color),

    );
  }
}