import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;

import 'package:breathe/Classes/Drawer.dart';
import 'package:breathe/Screens/VendorPage.dart';
import 'package:flutter/rendering.dart';
import 'package:breathe/Constants/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Dashboard.dart';
import 'OrderHistory.dart';
import 'Search.dart';
import 'Settings.dart';

class Home extends StatefulWidget {
  static String id = 'Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> list = [];
  bool loading = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int activeTab=0;
  bool queueReload = false;
  List<String> pageLabel = [
    "Fulfilled Oxygen Supplies",
    "Order History",
    "Vendors Around You",
    "Settings"
  ];

  @override
  void initState() {
    super.initState();
    activeTab=0;
    loading=false;
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
      list.clear();
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
        .collection('Customer')
        .where('Email', isEqualTo: useremail)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        username = doc['Name'];
        userAv = doc['Avatar'];
        phno = doc['PhoneNumber'];
      });
    });
    print(username);

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
    setState(() {
      loading = false;
    });
  }

  Widget tabs(int i) {
    List<Widget> tabs = [
      Dashboard(loading: loading, list: list,),
      OrderHistory(loading: loading, list: list,),
      VendorPage(),
      UserSettings(),
    ];
    return tabs[i];
  }

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        if ( _key.currentState.isDrawerOpen )
          Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        key: _key,
        drawer: !loading ? CustomDrawer(activeInd: activeTab, userImg: userImg, change: (int index) {
          setState(() {
            activeTab = index;
            if ( index == 3 )
                setState(() {
                  queueReload = true;
                });
            if ( index == 0 && queueReload )
              getData();
          });
          Timer(const Duration(milliseconds: 100), () {
              Navigator.pop(context);
          });
        },) : Container(),
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
                  onPanDown: (var x) => !loading ? _key.currentState.openDrawer() : {},
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
          tabs(activeTab),
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
                child: Text(pageLabel[activeTab],
                style: TextStyle(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),),
              ),
            ),
          )
        ]),
      ),
    );

  }
}
