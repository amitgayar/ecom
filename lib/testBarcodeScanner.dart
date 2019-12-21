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

  handleKey(RawKeyEventDataAndroid key) {
    String _keyCode;
    _keyCode = key.keyCode.toString(); //keycode of key event (66 is return)

    print("why does this run twice ${key.keyLabel}");
  }

  _buildTextComposer() {
    TextField _textField = new TextField(
      controller: _controller,
      onSubmitted: _handleSubmitted,
    );

    FocusScope.of(context).requestFocus(_textNode);

    return new RawKeyboardListener(
        focusNode: _textNode,
        onKey: (key) => handleKey(key.data),
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