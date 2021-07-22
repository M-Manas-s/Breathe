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
        backgroundColor: Color(0xFF1F4F99),
        title: Text(
          'Breathe',
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pushAndRemoveUntil(
              context, CustomRoute(builder: (_) => Search()), (r) => false);
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                spreadRadius: 0.01,
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 15,
              )
            ],
          ),
          child: Container(
            width: 130,
            child: Hero(
              tag: 'icon',
              child: Image.asset('Assets/Images/icon.png'),
            ),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom:10),
              child: Text("Recent Oxygen Supplies",
                  style: TextStyle(color: Color(0xFF1F4F99), fontSize: 19)),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return CustomCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(children: [
                          Text("VN", style: TextStyle(
                              fontSize: 20,
                            color: Colors.white
                          ),),
                          SizedBox(height: 20,),
                          Text("CN", style: TextStyle(
                            fontSize: 20,
                              color: Colors.white
                          ,),)
                        ]),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomCard(
                              shadow : false,
                              padding : EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                              color: Color(0xff253199),
                              child: Text("Price", style: TextStyle(
                                fontSize: 20,
                                color: Colors.white
                                ,)),
                              radius: 15,
                            ),
                          ],
                        )
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    radius: 20.0,
                    color: Color(0xFF3847bf),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
