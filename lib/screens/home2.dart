
import 'package:flutter/material.dart';

//import 'package:mpos/screens/tabs.dart';


class HomeScreen2 extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen2> with SingleTickerProviderStateMixin {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MPos"),
        backgroundColor: Colors.brown,
      ),
      body: Container(
//          color: Colors.brown,
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 60,
                    child: Text('Deliver features faster', textAlign: TextAlign.center),
                  ),
                  Flexible(
                    child: Text('Craft beautiful UIs', textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    width: 60,
                    child: FittedBox(
                      fit: BoxFit.contain, // otherwise the logo will be tiny
                      child: const FlutterLogo(),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Deliver features faster', textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text('Craft beautiful UIs', textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.contain, // otherwise the logo will be tiny
                      child: const FlutterLogo(),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Deliver features faster', textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text('Craft beautiful UIs', textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.contain, // otherwise the logo will be tiny
                      child: const FlutterLogo(),
                    ),
                  ),
                ],
              ),
            ],

          )
      ),
      drawer: Theme(
        data:Theme.of(context).copyWith(
          canvasColor: Colors.brown,
        ),
          child: Drawer(
            child: ListView(
                children: <Widget>[
                  DrawerHeader(child: Text("\nExpress Store", style: TextStyle(
                      color: Colors.white,
//                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                  ),)),
                  ListTile(title: Text('Catalogue', style: TextStyle(color: Colors.white),),),
                  ListTile(title: Text('Inventory', style: TextStyle(color: Colors.white),),),
                  ListTile(title: Text('Customers', style: TextStyle(color: Colors.white),),),
                  ListTile(title: Text('Profile', style: TextStyle(color: Colors.white),),),
                  ListTile(title: Text('Orders', style: TextStyle(color: Colors.white),),),
                  AboutListTile(
                      child: Text("About", style: TextStyle(color: Colors.white),),
                      applicationName: "Application Name",
                      applicationVersion: "v1.0.0",
                      applicationIcon: Icon(Icons.adb),
                      icon: Icon(Icons.info, color: Colors.red)
                  )
                ]),
          ),
      ),
    );
  }
}

