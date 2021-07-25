import 'package:breathe/Classes/CustomCard.dart';
import 'package:breathe/Constants/Constants.dart';
import 'package:breathe/Screens/VendorLocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LandingPage.dart';

class VendorDashboard extends StatefulWidget {
  static String id = 'VendorDashboard';

  @override
  _VendorDashboardState createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<dynamic> list = [];
  SharedPreferences prefs;
  String docId;
  String name;
  int qu;
  String price;
  String address = " ";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> _getCurrentPosition() async {
    final GeolocatorPlatform _geolocationPlatform = GeolocatorPlatform.instance;
    final position = await _geolocationPlatform.getCurrentPosition();
    userLoc = LatLng(position.latitude, position.longitude);
  }

  Future getData() async {
    prefs = await SharedPreferences.getInstance();
    await _getCurrentPosition();
    print(prefs.getString('Email'));

    await FirebaseFirestore.instance
        .collection('Vendor')
        .where('Email', isEqualTo: prefs.getString('Email'))
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        docId = doc.id;
        name = doc['Name'];
        qu = doc['Quantity'];
        price = doc['Price'].toString();
        print(price);
        address = doc['Address1'] + " " + doc['Address2'];
        String str = doc['Location'];
        if (str != "null")
          userLoc = LatLng(
              double.parse(str.split(',')[0]), double.parse(str.split(',')[1]));
      });
    });

    List<String> ce = [];
    List<double> p = [];
    List<String> date = [];
    List<String> cn = [];

    await FirebaseFirestore.instance
        .collection('DealsHistory')
        .where('VendorEmail', isEqualTo: prefs.getString('Email'))
        .orderBy('DateTime')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size == 0) return;
      querySnapshot.docs.forEach((doc) {
        ce.add(doc['CustomerEmail']);
        p.add(doc['Price'] * 1.00);
        date.add(doc['DateTime']);
      });
    });

    for (int i = 0; i < ce.length; i++) {
      await FirebaseFirestore.instance
          .collection('Customer')
          .where('Email', isEqualTo: ce[i])
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          cn.add(doc['Name']);
        });
      });

      list.add({"CN": cn[i], "Price": p[i], "DateTime": date[i]});
    }
    while (list.length > 10) list.removeLast();

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Breathe",
          style: TextStyle(
            fontFamily: 'Barlow',
            letterSpacing: 8,
            fontSize: 29,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).accentColor,
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
              itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                    PopupMenuItem<int>(value: 1, child: Text('Sign Out')),
                  ],
              onSelected: (int value) async {
                await _auth.signOut();
                prefs.remove('Email');
                prefs.remove('User');
                Navigator.pushAndRemoveUntil(context,
                    CustomRoute(builder: (_) => LandingPage()), (r) => false);
              }),
        ],
      ),
      body: loading
          ? Center(
              child: Text("Loading..",
                  style: TextStyle(color: Color(0xFF1F4F99), fontSize: 19)))
          : Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: query.height * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Theme.of(context).accentColor.withOpacity(0.8),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 5),
                                Text(
                                    address == " "
                                        ? "Location not set"
                                        : address,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15)),
                              ],
                            ),
                            GestureDetector(
                              onPanDown: (var x) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    CustomRoute(
                                        builder: (_) => VendorLocation()),
                                    (r) => false);
                              },
                              child: CustomCard(
                                color: Theme.of(context).accentColor,
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 9),
                                radius: 10,
                                child: Text(address == " " ? "Set" : "Change",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 20, left: 20, right: 30, bottom: 10),
                        child: Text("Recent Bookings",
                            style: TextStyle(
                                color: Color(0xFF1F4F99), fontSize: 19)),
                      ),
                      if (list.length > 0)
                        Flexible(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CustomCard(
                                margin: EdgeInsets.only(
                                  top: 20,
                                  left: 20,
                                  right: 30,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        'to',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        list[index]["CN"],
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      )
                                    ]),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomCard(
                                          shadow: false,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 7),
                                          color: Color(0xff253199),
                                          child: Text(
                                              '\u{20B9} ${list[index]["Price"].toInt().toString()}',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                              )),
                                          radius: 15,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 15),
                                radius: 20.0,
                                color: Color(0xFF3847bf),
                              );
                            },
                          ),
                        )
                      else
                        Center(
                            child: Text("You have no bookings",
                                style: TextStyle(
                                    color: Color(0xFF1F4F99), fontSize: 19)))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  margin: EdgeInsets.only(top: query.height * 0.75),
                  height: query.height * 0.2,
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30))),
                  child: Center(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Price and Quantity",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Price : ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Flexible(
                              child: SizedBox(
                                width: query.width * 0.23,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) async {
                                    price = value;
                                    await FirebaseFirestore.instance
                                        .collection('Vendor')
                                        .doc(docId)
                                        .update({
                                      'Price': int.parse(value)
                                    }).catchError((error) => print(
                                            "Failed to update user: $error"));
                                  },
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                  cursorColor: Theme.of(context).accentColor,
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                      filled: false,
                                      hintText: '\u{20B9}$price',
                                      prefixText: '\u{20B9}'),
                                ),
                              ),
                            ),
                            Text(
                              "|",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onPanDown: (var x) async {
                                    setState(() {
                                      --qu;
                                    });
                                    await FirebaseFirestore.instance
                                        .collection('Vendor')
                                        .doc(docId)
                                        .update({
                                      'Quantity': qu
                                    }).catchError((error) => print(
                                        "Failed to update user: $error"));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text('-',style: TextStyle(
                                        color: Colors.white,
                                      fontSize: 40
                                    )),
                                  )
                                ),
                                SizedBox(width: 10,),
                                Text(qu.toString(),style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20
                                )),
                                SizedBox(width: 10,),
                                GestureDetector(
                                    onPanDown: (var x) async {
                                      setState(() {
                                        ++qu;
                                      });
                                      await FirebaseFirestore.instance
                                          .collection('Vendor')
                                          .doc(docId)
                                          .update({
                                        'Quantity': qu
                                      }).catchError((error) => print(
                                          "Failed to update user: $error"));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.add, color: Colors.white, size: 30,),
                                    )
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
