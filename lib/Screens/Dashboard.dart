import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;

import 'package:breathe/Classes/CustomCard.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:breathe/Constants/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import 'LandingPage.dart';
import 'Search.dart';

class Dashboard extends StatefulWidget {
  static String id = 'Dashboard';

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic> list = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  Image userImg;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    userImg = Image.asset('assets/images/user.jpg');
    getData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(userImg.image, context);
  }

  Future getData() async {
    setState(() {
      loading = true;
    });

    List<String> ve = [];
    List<String> ce = [];
    List<double> p = [];
    List<String> date = [];
    List<String> vn = [];
    List<String> cn = [];
    List<int> cavatar = [];
    List<int> vavatar = [];

    await FirebaseFirestore.instance
        .collection('DealsHistory')
        .orderBy('DateTime', descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size == 0) return;
      querySnapshot.docs.forEach((doc) {
        ve.add(doc['VendorEmail']);
        ce.add(doc['CustomerEmail']);
        p.add(doc['Price'] * 1.00);
        date.add(doc['DateTime']);
      });
    });

    for (int i = 0; i < ve.length; i++) {
      await FirebaseFirestore.instance
          .collection('Vendor')
          .where('Email', isEqualTo: ve[i])
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          vn.add(doc['Name']);
          vavatar.add(doc['Avatar']);
        });
      });

      await FirebaseFirestore.instance
          .collection('Customer')
          .where('Email', isEqualTo: ce[i])
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          cn.add(doc['Name']);
          cavatar.add(doc['Avatar']);
        });
      });

      list.add({
        "VN": vn[i],
        "VA": vavatar[i],
        "CN": cn[i],
        "CA": cavatar[i],
        "Price": p[i],
        "DateTime": date[i]
      });
    }
    while (list.length > 10) list.removeLast();
    //   if (list.length != 3)
    //     list.add({
    //       "VN": "Ramesh Singh",
    //       "CN": "Manas Tiwari",
    //       "Price": 1800,
    //       "DateTime": "2021-07-25 21:31:46.756162"
    //     });
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;

    return Scaffold(
      key: _key,
      drawer: Container(
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
                    topRight: Radius.elliptical(100,150),
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(1000.0)),
                          child: Align(
                            alignment: getAlign(34),
                            child: userImg,
                            widthFactor: 0.25,
                            heightFactor: 0.25,
                          ),
                        ),
                        Container(
                            width: query.width * 3,
                            child: Text(
                              "Hi\nManas!",
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
                    height: 50,
                  ),
                  Container(
                    width: query.width,
                    margin: EdgeInsets.all(0.0),
                    padding: EdgeInsets.all(3.0),
                    child: Row(
                      children: [
                        Icon(Icons.dashboard,
                            size: 32, color: Theme.of(context).accentColor),
                        SizedBox(
                          width: 15,
                        ),
                        Text('Dashboard',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).accentColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: GestureDetector(
                onPanDown: (var x) async {
                  await _auth.signOut();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
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
      ),
      body: Stack(children: <Widget>[
        Opacity(
          opacity: 0.95,
          child: Transform.rotate(
            angle: math.pi,
            child: Image.asset(
              "assets/images/bk.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(  // AppBar
          margin: EdgeInsets.only(top: query.height*0.07),
          padding: EdgeInsets.symmetric(horizontal: query.width*0.08),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onPanDown: (var x) => _key.currentState.openDrawer(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: Colors.white.withOpacity(0.3),
                  ),
                    padding: EdgeInsets.all(2),
                  child : SizedBox(
                    width: query.width*0.115,
                      height: query.width*0.115,
                      child: Icon(Icons.view_headline, color: Colors.white, size: 27,))
                ),
              ),
              SizedBox(
                width: query.width*0.05,
              ),
              Container(
                  child : Text("Breathe",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w600
                  ),)
              ),
              SizedBox(
                width: query.width*0.05,
              ),
              GestureDetector(
                onPanDown: (var x) => Navigator.pushAndRemoveUntil(context,
                    CustomRoute(builder: (_) => Search()), (r) => false),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.white.withOpacity(0.3),
                    ),
                    padding: EdgeInsets.all(2),
                    child : SizedBox(
                        width: query.width*0.115,
                        height: query.width*0.115,
                        child: Icon(Icons.search, color: Colors.white, size : 27))
                ),
              ),
            ],
          ),
        ),
        Container(    // body
          margin: EdgeInsets.only(top: query.height * 0.2),
          color: Colors.white,
          child: Scaffold(
            body: loading
                ? SingleChildScrollView(
                    child: SkeletonLoader(
                      builder: Container(
                          margin: EdgeInsets.only(top : 5),
                          padding: EdgeInsets.symmetric(horizontal: 25,vertical: 15),
                          child: CustomCard(
                              color: Colors.white,
                              radius: 10.0,
                              child: Container(
                                width: query.width * 0.8,
                                height: query.height * 0.17,
                              ))),
                      items: 7,
                      period: Duration(seconds: 2),
                      highlightColor:
                          Theme.of(context).accentColor.withAlpha(100),
                      direction: SkeletonDirection.ltr,
                    ),
                  )
                : Container(
              margin: EdgeInsets.only(top : 5),
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 25,vertical: 15),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "${DateFormat.MMMEd().format(DateTime.parse(list[index]["DateTime"]))}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              )),
                                          Row(
                                            children: [
                                              Text(
                                                  'Paid : \u{20B9}${list[index]["Price"].toInt().toString()}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  )),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(2),
                                                child: Icon(Icons.done,
                                                    color: Colors.white,
                                                    size: 15),
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    shape: BoxShape.circle),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    CustomCard(
                                      padding: EdgeInsets.all(0),
                                      margin: EdgeInsets.zero,
                                      radius: 10.0,
                                      shadow: true,
                                      boxShadow: BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 8,
                                        offset: Offset(0, 3),
                                      ),
                                      color: Colors.white,
                                      child: Container(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CustomCard(
                                                padding: EdgeInsets.zero,
                                                margin: EdgeInsets.zero,
                                                color: Colors.white,
                                                radius: 10.0,
                                                shadow: true,
                                                boxShadow: BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 3,
                                                  blurRadius: 8,
                                                  offset: Offset(3,
                                                      0),
                                                ),
                                                child: Column(children: [
                                                  userAvater(list[index]["VA"], context, userImg),
                                                  Container(
                                                    padding: EdgeInsets.all(3),
                                                    child: Text(
                                                      list[index]["VN"],
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              )
                                            ],
                                          ),
                                          Expanded(
                                              child: Icon(Icons.swap_horiz,
                                                  size: 55)),
                                          CustomCard(
                                            padding: EdgeInsets.zero,
                                            margin: EdgeInsets.zero,
                                            color: Colors.white,
                                            radius: 10.0,
                                            shadow: true,
                                            boxShadow: BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 3,
                                              blurRadius: 8,
                                              offset: Offset(-3,
                                                  0), // changes position of shadow
                                            ),
                                            child: Column(
                                              children: [
                                                userAvater(list[index]["CA"], context, userImg),
                                                Container(
                                                  padding: EdgeInsets.all(3),
                                                  child: Text(
                                                    list[index]["CN"],
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )

                                          // Column(
                                          //   children: [
                                          //     CustomCard(
                                          //       child: Row(children: [
                                          //         Text(
                                          //           list[index]["VN"],
                                          //           style: TextStyle(
                                          //               fontSize: 18, color: Colors.white),
                                          //         ),
                                          //         SizedBox(
                                          //           height: 7,
                                          //         ),
                                          //         Text(
                                          //           ' to ',
                                          //           style: TextStyle(
                                          //               fontSize: 15, color: Colors.white),
                                          //         ),
                                          //         SizedBox(
                                          //           height: 7,
                                          //         ),
                                          //         Text(
                                          //           list[index]["CN"],
                                          //           style: TextStyle(
                                          //             fontSize: 18,
                                          //             color: Colors.white,
                                          //           ),
                                          //         )
                                          //       ]),
                                          //       padding: EdgeInsets.symmetric(
                                          //           horizontal: 25, vertical: 15),
                                          //       margin: EdgeInsets.zero,
                                          //       radius: 0.0,
                                          //       color: Color(0xFF3847bf),
                                          //     ),
                                          //     Column(
                                          //       mainAxisAlignment: MainAxisAlignment.center,
                                          //       children: [
                                          //       ClipRRect(
                                          //         borderRadius: BorderRadius.only(
                                          //           topRight: Radius.circular(10.0),
                                          //           bottomRight: Radius.circular(10.0),
                                          //         ),
                                          //         child: Align(
                                          //           alignment: getAlign(32),
                                          //           child: Image.asset(
                                          //               'assets/images/user.jpg'),
                                          //           widthFactor: 0.25,
                                          //           heightFactor: 0.25,
                                          //         ),
                                          //         //clipper: TriangleClipper(),
                                          //       ),
                                          //       Container(
                                          //         width: MediaQuery
                                          //             .of(context)
                                          //             .size
                                          //             .width * 0.4,
                                          //         child: Center(
                                          //           child: CustomCard(
                                          //             shadow: false,
                                          //             padding: EdgeInsets.symmetric(
                                          //                 horizontal: 15, vertical: 7),
                                          //             margin: EdgeInsets.zero,
                                          //             color: Color(0xff253199),
                                          //             child: Text(
                                          //                 '\u{20B9} ${list[index]["Price"]
                                          //                     .toInt()
                                          //                     .toString()}',
                                          //                 style: TextStyle(
                                          //                   fontSize: 20,
                                          //                   color: Colors.white,
                                          //                 )),
                                          //             radius: 15,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       ],
                                          //     )
                                          //   ],
                                          // ),

                                          ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 3),
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(vertical: query.height * 0.16, horizontal: query.width*0.08),
          child: SizedBox(
            height: query.height*0.08,
            child: Center(
              child: Text("Fulfilled Oxygen Supplies",
              style: TextStyle(
                letterSpacing: 1,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),),
            ),
          ),
        )
      ]),
    );

  }
}
