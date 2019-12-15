
import 'package:flutter/material.dart';
import 'dart:io' show Directory;
import 'Utilities/authentication.dart';
import 'Databases/Database.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login_OTP.dart';
import 'Constants/const.dart';


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
            const SizedBox(height: 120.0),
            PrimaryColorOverride(
              child: Text(
                'Enter Your Mobile Number',
                style: new TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
                ),
              ),

            PrimaryColorOverride(
              child: TextField(
                controller: _usernameController,
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

            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('CANCEL'),
                  shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                  ),
                RaisedButton(
                  child: const Text('Get OTP'),
                  elevation: 8.0,
                  shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
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



                    var p;
                    if (validateUsername == 0){
                      // Call API to send OTP to the input number
                      Post newPost = new Post(
                          phoneNumber: _usernameController.text);
                      p = await createPost(
                          getOTP,
                          body: newPost.toMap());
                      print(p);



                      //Check API Status
                      if(p == 200)
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
              ],
              ),
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
