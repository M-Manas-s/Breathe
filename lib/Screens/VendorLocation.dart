import 'dart:async';

import 'package:animate_icons/animate_icons.dart';
import 'package:breathe/Classes/CustomCard.dart';
import 'package:breathe/Constants/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'VendorDashboard.dart';

class VendorLocation extends StatefulWidget {
  @override
  _VendorLocationState createState() => _VendorLocationState();
}

class _VendorLocationState extends State<VendorLocation> {
  Completer<GoogleMapController> _controller = Completer();
  bool confirmed = false;
  double ratio = 0.92;
  LatLng confirmedLoc;
  String ad1;
  String ad2;
  bool spinner = false;
  bool state = true;
  bool absorb = false;
  bool complete = false;
  AnimateIconController ic;

  @override
  void initState() {
    super.initState();
    ic = AnimateIconController();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  List<Marker> markersList = [
    Marker(
      markerId: MarkerId('You'),
      onTap: () {},
      position: userLoc,
      infoWindow: InfoWindow(
        title: 'You',
      ),
    ),
  ];

  saveLocation() async {
    setState(() {
      spinner = true;
    });

    String id;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await FirebaseFirestore.instance
        .collection('Vendor')
        .where('Email', isEqualTo: prefs.getString('Email'))
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        id = doc.id;
      });
    });

    await FirebaseFirestore.instance
        .collection('Vendor')
        .doc(id)
        .update({'Address1': ad1}).catchError(
            (error) => print("Failed to update user: $error"));

    await FirebaseFirestore.instance
        .collection('Vendor')
        .doc(id)
        .update({'Address2': ad2}).catchError(
            (error) => print("Failed to update user: $error"));

    await FirebaseFirestore.instance
        .collection('Vendor')
        .doc(id)
        .update({'Location': "${confirmedLoc.latitude},${confirmedLoc.longitude}"}).catchError(
            (error) => print("Failed to update user: $error"));

    setState(() {
      spinner=false;
      complete=true;
    });

    Timer(const Duration(milliseconds: 200), () {
      setState(() {
        ic.animateToEnd();
      });
    });

    Timer(const Duration(milliseconds: 1500), () {
      Navigator.pushAndRemoveUntil(context,
          CustomRoute(builder: (_) => VendorDashboard()), (r) => false);
    });

  }

  void _onMapViewCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ModalProgressHUD(
        progressIndicator: SpinKitChasingDots(
          color: Theme.of(context).accentColor,
          size: 30.0,
        ),
        inAsyncCall: spinner,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: size.height * (1 - ratio)),
              child: GoogleMap(
                onTap: (latlng) {
                  setState(() {
                    markersList.clear();
                    markersList.add(
                      Marker(
                        markerId: MarkerId('You'),
                        onTap: () {},
                        position: latlng,
                        infoWindow: InfoWindow(
                          title: 'You',
                        ),
                      ),
                    );
                  });
                },
                onMapCreated: _onMapViewCreated,
                markers: markersList.toSet(),
                initialCameraPosition: CameraPosition(
                  target: userLoc,
                  zoom: 15.0,
                ),
              ),
            ),
            !confirmed ? GestureDetector(
              onPanDown: (var x){
                setState(() {
                  confirmed = true;
                  confirmedLoc = markersList[0].position;
                });
              },
              child: Container(
                height: size.height*(1-ratio),
                  width: size.width,
                  margin: EdgeInsets.only(top: size.height * (ratio)),
                  color: Theme.of(context).accentColor,
                  child: Center(child: Text("Confirm Location", style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),))),
            ) :
                Container(
                  color: Colors.black.withOpacity(0.5),
                  padding: EdgeInsets.only(top: size.height*0.5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))
                    ),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Container(
                          height: size.height*0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.05,
                              ),
                              Text(
                                "Enter Your Complete Address",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.02,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Address1 Line ",
                                      style: TextStyle(
                                        color: Colors.blue[700],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                      ),
                                      child: TextFormField(
                                        onChanged: (value) {
                                          ad1 = value.trim();
                                        },
                                        cursorColor: Theme.of(context).accentColor,
                                        textAlign: TextAlign.start,
                                        decoration: InputDecoration(
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          fillColor: Color(0xFFD2D2D2),
                                          filled: true,
                                          hintText: "Building Number",
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                        ),
                                        validator: (String str) => null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Address Line 2",
                                      style: TextStyle(
                                        color: Colors.blue[700],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                      ),
                                      child: TextFormField(
                                        onChanged: (value) {
                                          ad2 = value.trim();
                                        },
                                        cursorColor: Theme.of(context).accentColor,
                                        textAlign: TextAlign.start,
                                        decoration: InputDecoration(
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          fillColor: Color(0xFFD2D2D2),
                                          filled: true,
                                          hintText: "Road/Locality",
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                        ),
                                        validator: (String str) => null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              GestureDetector(
                                onPanDown: (var x) {
                                    saveLocation();
                                },
                                child: CustomCard(
                                  child: Text(
                                    'Confirm',
                                    style: TextStyle(color: Colors.white, fontSize: 17),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 80,
                                  ),
                                  color: Color(0xFF1F4F99),
                                  radius: 30.0,
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.05,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            complete
                ? Container(
              width: size.width,
              height: size.height,
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30))
                  ),
                  width: size.height * 0.2,
                  height: size.height * 0.2,
                  child: Center(
                    child: AnimateIcons(
                      startIcon: Icons.location_on,
                      endIcon: Icons.done,
                      size: 100.0,
                      controller: ic,
                      // add this tooltip for the start icon
                      startTooltip: 'Icons.add_circle',
                      // add this tooltip for the end icon
                      endTooltip: 'Icons.add_circle_outline',
                      onStartIconPress: () {
                        print("Clicked on Add Icon");
                        return true;
                      },
                      onEndIconPress: () {
                        print("Clicked on Close Icon");
                        return true;
                      },
                      duration: Duration(milliseconds: 600),
                      startIconColor: Theme.of(context).accentColor,
                      endIconColor: Colors.green,
                      clockwise: false,
                    ),
                  ),
                ),
              ),
            )
                : SizedBox(height: 0)
          ],
        ),
      ),
    );
  }
}
