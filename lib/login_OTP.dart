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
import 'dart:io' show Directory;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'Databases/Database.dart';
import 'package:flutter/services.dart';
import 'Utilities/authentication.dart';
import 'home.dart';
import 'Constants/const.dart';
import 'services/syncData.dart';
import 'testBarcodeScanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Data {
  final String phone_number_OTP;
  const Data({this.phone_number_OTP});
}


class LoginPageOTP extends StatefulWidget {
  final Data phone_for_OTP;

  // In the constructor, require a Todo.
  LoginPageOTP({Key key, @required this.phone_for_OTP}) : super(key: key);

  @override
  _LoginPageOTPState createState() => new _LoginPageOTPState();
}

class _LoginPageOTPState extends State<LoginPageOTP> {
  final TextEditingController _passwordController = TextEditingController();
  int validatePassword = 0;
  bool resendPressed = false;
  FocusNode _focusNode;


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _passwordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
    });

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SizedBox(
            height: 600,
            width: 420,
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 40, 10, 40),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                            children : <Widget>[

                              Container(

//                              padding: EdgeInsets.all(30),
                      alignment: Alignment.center,
                        child: Image.asset('assets/images/logo.png',
                                             width: 220.0,
                                             height: 190.0,
                                             fit: BoxFit.fitWidth,
                                             color: Color(0xff429585),
                                           ),

),
                            ]
                            ),
                        flex: 10,
                        ),
                      Expanded(
                        child:  Row(children: <Widget>[
                          PrimaryColorOverride(
                              child:Container(
                                width: 180,
                                child:  TextField(
                                  autofocus: false,
                                  focusNode: _focusNode,
                                  textAlign: TextAlign.center,
                                  controller: _passwordController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Enter OTP',
                                    labelStyle: TextStyle(),
                                    errorText: (validatePassword == 1) ? "OTP can not be empty" : ((validatePassword == 2) ? "You have entered incorrect OTP" : null),
                                    ),


                                  ),
                                )
                              ),

                        ],
                                    ),
                        flex: 3,
                        ),
                      Expanded(
                        child:  ButtonBar(
                          children: <Widget>[


                            FlatButton(
                              child: const Text('Resend OTP'),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(31.0)),
                                ),
                              onPressed: () async {


                                String resendRequesNumber = widget.phone_for_OTP.phone_number_OTP;
                                var p;
                                processPhoneNumber newPost = new processPhoneNumber(
                                    phoneNumber: resendRequesNumber);
                                p = await submitAuthenticationDetails(
                                    getOTP,
                                    body: newPost.toMap());
                                print(p);
                                setState(() {
                                  resendPressed= true;
                                });
                                Fluttertoast.showToast(
                                    msg: "OTP Sent Successfully",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIos: 1,
                                    backgroundColor: Color(0xff429585),
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                    );

                              },
                              ),
                            Container(
                              width: 120,
                              ),
                            RaisedButton(
                              child: const Text('Login'),
                              color: Color(0xff429585),
                              elevation: 8.0,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(27.0)),
                                ),
                              onPressed: () async {
                                setState(() {

                                  if (_passwordController.text.isEmpty)
                                  {
                                    validatePassword = 1;
                                    print("OTP can not be empty");
                                  }
                                  else
                                  {
                                    validatePassword = 0;
                                  }
                                });

                                //_insert();

                                Response otpSubmissionResponse;
                                String phone_fetched = widget.phone_for_OTP.phone_number_OTP;
                                if (validatePassword == 0){
                                  // Call API to send OTP to the input number
                                  processOTP newPost = new processOTP(
                                      OTP: _passwordController.text,
                                      phoneNumber: phone_fetched
                                      );

                                  otpSubmissionResponse = await getStoreDetailsAPI(
                                      newPost);

                                  //Check API Status
                                  if(otpSubmissionResponse.statusCode == 200)
                                  {

                                    await getFrequencyAPI();
                                    await PostSyncAPI();
                                    // If status is 200 navigate to OTP screen
                                    SharedPreferences cronFrequency = await SharedPreferences.getInstance();
                                    var route = new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                      new HomePage(),
                                      );

                                    Navigator.of(context).push(route);
                                  }
                                  else {

                                    // If status is not 200 nShow error
                                    setState(() {
                                      validatePassword = 2;
                                    });
                                  }
                                }
                                print(_passwordController.text);
                              },
                              ),

                          ],
                          ),
                        flex: 2,
                        ),
                      Expanded(
                        child: Container(
                          height: 260,
                          ),
                        flex: 2,
                        ),



                    ],
                    ),
                  )
              ],
              ),
          )
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