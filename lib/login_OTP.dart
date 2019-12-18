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
//import 'colors.dart';
import 'Databases/Database.dart';
import 'package:flutter/services.dart';
import 'Utilities/authentication.dart';
import 'home.dart';
import 'Constants/const.dart';




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



  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _passwordController.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                const SizedBox(height: 16.0),
                Text(
                  'Express Stores',
                  style: Theme.of(context).textTheme.headline,
                ),
              ],
            ),





            const SizedBox(height: 12.0),
            PrimaryColorOverride(
              child: Text(
                'Enter OTP',
                style: new TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            PrimaryColorOverride(
              child: TextField(
                controller: _passwordController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  errorText: (validatePassword == 1) ? "OTP can not be empty" : ((validatePassword == 2) ? "You have entered incorrect OTP" : null),
                ),


              ),
            ),
            ButtonBar(
              children: <Widget>[


                FlatButton(
                  child: const Text('Resend OTP'),
                  shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () async {

                    String resendRequesNumber = widget.phone_for_OTP.phone_number_OTP;
                    var p;
                    Post newPost = new Post(
                        phoneNumber: resendRequesNumber);
                    p = await createPost(
                        getOTP,
                        body: newPost.toMap());
                    print(p);



                    setState(() {
                      resendPressed= true;
                    });

                  },
                ),
                RaisedButton(
                  child: const Text('Login'),
                  elevation: 8.0,
                  shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
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

                    var p;
                    String phone_fetched = widget.phone_for_OTP.phone_number_OTP;
                    if (validatePassword == 0){
                      // Call API to send OTP to the input number
                      SubmitOTP newPost = new SubmitOTP(
                          OTP: _passwordController.text,
                          phoneNumber: phone_fetched
                      );
                      p = await createPost(
                          submitOTP,
                          body: newPost.toMap());
                      print(p);



                      //Check API Status
                      if(p == 200)
                      {
                        // If status is 200 navigate to OTP screen
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new HomePage()
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
            resendPressed ? Text("OTP sent successfully", style: TextStyle(color: Colors.blue)) : SizedBox(),
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




class Data {
  final String phone_number_OTP;
  const Data({this.phone_number_OTP});
}
