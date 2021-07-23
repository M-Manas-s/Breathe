import 'dart:collection';
import 'dart:math';

import 'package:breathe/Classes/CirclePainter.dart';
import 'package:breathe/Classes/Vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:breathe/Constants/Constants.dart';
import 'package:geolocator/geolocator.dart';
import 'MapView.dart';

class Search extends StatefulWidget {

  static String id = 'Search';

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with TickerProviderStateMixin {
  AnimationController _controller;
  Color color = Colors.blue[700];
  double size = 90.0;

  Future<void> _getCurrentPosition() async {
    final GeolocatorPlatform _geolocationPlatform = GeolocatorPlatform.instance;
    final position = await _geolocationPlatform.getCurrentPosition();
    userLoc= LatLng(position.latitude, position.longitude);
    print(userLoc);
  }


  readData() async {

    await FirebaseFirestore.instance
        .collection('Vendor')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if ( doc['Location']!='null' && doc['Quantity']>0 )
        vendorList.add(
            Vendor(
                name: doc['Name'],
                phno: int.parse(doc['PhoneNumber']),
                email: doc['Email'],
                price: (doc['Price']* 1.00),
                location: stringToLatLng(doc['Location']),
                quantity: doc['Quantity']
            )
        );
      });
    });
    print(calculateDistance(vendorList[0].location, userLoc));
  }

  LatLng stringToLatLng(String str) {
    LatLng loc = LatLng(double.parse(str.split(',')[0]), double.parse(str.split(',')[1]));
    return loc;
  }

  closestTen() {
    vendorList.sort((a, b) =>
        (calculateDistance(a.location, userLoc)).compareTo(
            calculateDistance(b.location, userLoc)));
    while(vendorList.length > 10)
      vendorList.removeLast();
  }

  void loadPreRequisites () async {
    await _getCurrentPosition();
    await readData();
    closestTen();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MapView()
        ),
        ModalRoute.withName(MapView.id)
    );
  }

  @override
  void initState(){
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )
      ..repeat();
    loadPreRequisites();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _button() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                color,
                color.withOpacity(0.7)
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Icon(Icons.search, size: 70, color: Colors.white,),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          painter: CirclePainter(
            _controller,
            color: color,
          ),
          child: SizedBox(
            width: size * 3.8,
            height: size * 3.8,
            child: _button(),
          ),
        ),
      ),
    );
  }
}

