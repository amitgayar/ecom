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
                    processPhoneNumber newPost = new processPhoneNumber(
                        phoneNumber: resendRequesNumber);
                    p = await submitAuthenticationDetails(
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
                      //print(p);




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