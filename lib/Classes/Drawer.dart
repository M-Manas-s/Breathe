import 'package:breathe/Constants/Constants.dart';
import 'package:breathe/Screens/LandingPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatelessWidget {
  final int activeInd;
  final Image userImg;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Function change;

  CustomDrawer({
    this.activeInd,
    this.userImg,
    this.change,
  });

  List<dynamic> optionsData = [
    {"icon": Icons.dashboard, "label": "Dashboard"},
    {"icon": Icons.history, "label": "Order History"},
    {"icon": Icons.groups, "label": "Vendors"},
    {"icon": Icons.settings, "label": "Settings"}
  ];

  Widget options(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        change(index);
      },
      child: AnimatedContainer(
        duration: Duration(microseconds: 200),
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(0.0),
        padding: EdgeInsets.all(3.0),
        child: Row(
          children: [
            Icon(optionsData[index]["icon"],
                size: activeInd == index ? 42 : 32,
                color: activeInd == index ? Color(0xFF1F4F99) : Colors.black),
            SizedBox(
              width: 15,
            ),
            Text(optionsData[index]["label"],
                style: TextStyle(
                    fontSize: activeInd == index ? 27 : 22,
                    fontWeight: FontWeight.w700,
                    color:
                        activeInd == index ? Color(0xFF1F4F99) : Colors.black)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      width: query.width * 0.8,
      height: query.height,
      child: Stack(
        children: [
          Container(
            width: query.width * .55,
            height: query.width * .55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(100),
                  bottomRight: Radius.circular(100)),
              color: Theme.of(context).accentColor.withAlpha(30),
            ),
          ),
          Container(
            width: query.width * .7,
            height: query.width * .7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.elliptical(100, 150),
                  bottomRight: Radius.circular(200)),
              color: Theme.of(context).accentColor.withAlpha(20),
            ),
          ),
          Container(
            width: query.width * .8,
            height: query.width * .8,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.elliptical(160, 150)),
              color: Theme.of(context).accentColor.withAlpha(15),
            ),
          ),
          Container(
            width: query.width * .8,
            height: query.width * 0.95,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.elliptical(120, 80)),
              color: Theme.of(context).accentColor.withAlpha(10),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 28.0, left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.fill,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(1000.0)),
                        child: Align(
                          alignment: getAlign(userAv),
                          child: userImg,
                          widthFactor: 0.25,
                          heightFactor: 0.25,
                        ),
                      ),
                      Container(
                          width: query.width * 3,
                          child: Text(
                            "Hi\n${username.split(' ')[0]}!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 230,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0,
                                color: Theme.of(context)
                                    .accentColor
                                    .withGreen(40)),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: optionsData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        options(context, index),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  },
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: GestureDetector(
              onPanDown: (var x) async {
                await _auth.signOut();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('Email');
                prefs.remove('User');
                Navigator.pushAndRemoveUntil(context,
                    CustomRoute(builder: (_) => LandingPage()), (r) => false);
              },
              child: Container(
                margin: EdgeInsets.only(top: 28.0, left: 22.0, bottom: 20.0),
                width: query.width,
                child: Row(
                  children: [
                    Icon(Icons.power_settings_new_outlined,
                        size: 35, color: Colors.black),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Sign Out',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
