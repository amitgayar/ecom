import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class KeyboardListener extends StatefulWidget {

  KeyboardListener();

  @override
  _RawKeyboardListenerState createState() => new _RawKeyboardListenerState();
}

class _RawKeyboardListenerState extends State<KeyboardListener> {

  TextEditingController _controller = new TextEditingController();
  FocusNode _textNode = new FocusNode();


  @override
  initState() {
    super.initState();
  }

  //Handle when submitting
  void _handleSubmitted(String finalinput) {

    setState(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide'); //hide keyboard again
      _controller.clear();
    });
  }

  String barcode = "";
  handleKey(RawKeyEvent key) {
    //print("Event runtimeType is ${key.runtimeType}");
    if(key.runtimeType.toString() == 'RawKeyDownEvent'){
      RawKeyEventDataAndroid data = key.data as RawKeyEventDataAndroid;
      String _keyCode;
      _keyCode = data.keyCode.toString(); //keycode of key event (66 is return)

      barcode = barcode + key.data.keyLabel;

      //print("\n\nwhy does this run twice ${barcode}");
    }

    print("\n\n${key.data.keyLabel}");
  }

  _buildTextComposer() {
    TextField _textField = new TextField(
      controller: _controller,
      onSubmitted: _handleSubmitted,
    );

    FocusScope.of(context).requestFocus(_textNode);

    return new RawKeyboardListener(
        focusNode: _textNode,
        onKey: (key) => handleKey(key),
        child: _textField
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Search Item")),
      body: _buildTextComposer(),
    );
  }
}