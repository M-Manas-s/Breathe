import 'package:breathe/Classes/CustomCard.dart';
import 'package:flutter/material.dart';

import 'Info.dart';
import 'Search.dart';

class CustomRoute extends MaterialPageRoute {
  CustomRoute({WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => Duration(milliseconds: 800);
}

class Dashboard extends StatefulWidget {
  static String id = 'Dashboard';

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1565C0),
        title: Text('Breathe',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF1565C0),
        child: Icon(Icons.search_sharp),
        onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => Info()));},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        child: Center(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context,int index) {
              return CustomCard(
                  child: ListView(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Row(
                        children: <Widget>[
                          Text('vendor name'),
                          Center(child: Text('price'),)
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('buyer name')
                        ],
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(12), margin: EdgeInsets.only(left: 20, right: 20,top: 20));
            },
          ),
        ),
      ),
    );
  }
}
