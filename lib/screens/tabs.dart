import 'package:flutter/material.dart';

class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          // center the children
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.favorite,
              size: 160.0,
              color: Colors.green,
            ),
            Text("First Tab")
          ],
        ),
      ),
    );
  }
}

class Second extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          // center the children
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.adb,
              size: 160.0,
              color: Colors.green,
            ),
            Text("Second Tab")
          ],
        ),
      ),
    );
  }
}


class Third extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          // center the children
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.airport_shuttle,
              size: 160.0,
              color: Colors.green,
            ),
            Text("Third Tab")
          ],
        ),
      ),
    );
  }
}

class DropD extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DropDState();
  }
}

class DropDState extends State<DropD> {
  List _fruits = ["Apple", "Banana", "Pineapple", "Mango", "Grapes"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _selectedFruit;

  @override
  void initState() {
    _dropDownMenuItems = buildAndGetDropDownMenuItems(_fruits);
    _selectedFruit = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List fruits) {
    List<DropdownMenuItem<String>> items = List();
    for (String fruit in fruits) {
      items.add(DropdownMenuItem(value: fruit, child: Text(fruit)));
    }
    return items;
  }

  void changedDropDownItem(String selectedFruit) {
    setState(() {
      _selectedFruit = selectedFruit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("DropDown"),
          backgroundColor: Colors.brown,
        ),
        body: Container(
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Please choose a fruit: "),
                  DropdownButton(
                    value: _selectedFruit,
                    items: _dropDownMenuItems,
                    onChanged: changedDropDownItem,
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class AnimationIM extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAnimationIM();
  }
}

class MyAnimationIM extends State<AnimationIM> {
  bool _bigger = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedContainer(
          width: _bigger ? 100 : 500,
          child: Image.asset('assets/images/GitHub.png'),
          duration: Duration(milliseconds: 100),
        ),
        RaisedButton(
          onPressed: () => setState(() {
            _bigger = !_bigger;
          }),
          child: Text('Zoom'),
        ),
      ],
    );
  }

}
