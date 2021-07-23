import 'dart:async';

import 'package:breathe/Classes/CustomCard.dart';
import 'package:breathe/Constants/Constants.dart';
import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Login.dart';

class MapView extends StatefulWidget {
  static String id = 'MapViewView';

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  bool infovis = false;
  int selIndex;
  double ratio = 0.87;

  void assignMarker() {
    setState(() {});
  }

  void _onMapViewCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void activeIndex(int index) {
    setState(() {
      setState(() {
        infovis = true;
        selIndex = index;
        ratio = 0.35;
      });
    });
  }

  List<Marker> makeSet() {
    List<Marker> list = [
      Marker(
        markerId: MarkerId('You'),
        onTap: () {
          setState(() {
            infovis = false;
            ratio = 0.87;
          });
        },
        position: userLoc,
        infoWindow: InfoWindow(
          title: 'You',
        ),
      ),
    ];
    for (int i = 0; i < vendorList.length; i++) {
      list.add(Marker(
        markerId: MarkerId('V$i'),
        onTap: () {
          activeIndex(i);
        },
        position: vendorList[i].location,
        infoWindow: InfoWindow(
            title: vendorList[i].name,
            snippet: "${vendorList[i].quantity} remaining"),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          infovis = false;
          ratio = 0.87;
        });
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: query.height * (1 - ratio)),
              child: GoogleMap(
                onMapCreated: _onMapViewCreated,
                markers: makeSet().toSet(),
                initialCameraPosition: CameraPosition(
                  target: userLoc,
                  zoom: 15.0,
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: query.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.all(Radius.circular(!infovis ? 0 : 40.0)),
              ),
              margin: EdgeInsets.only(
                  top: query.height * (infovis ? ratio - 0.01 : ratio)),
              padding: EdgeInsets.only(top: infovis ? 20 : 0),
              child: Center(
                child: !infovis
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Oxygen Supplies near you",
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Tap on a vendor to know more",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                vendorList[selIndex].name,
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 35,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                "${calculateDistance(vendorList[selIndex].location, userLoc).toStringAsFixed(2)} km",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomCard(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            child: Container(
                              padding: EdgeInsets.all(25),
                              child: Column(
                                children: [
                                  Text(
                                    vendorList[selIndex].quantity.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 40,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  Text(
                                    "Cylinders Available",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Text(
                                    "Rs ${vendorList[selIndex].price.toString()}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Column(
                            children: [
                              Text(
                                "Call ${vendorList[selIndex].name.split(' ')[0]}",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    vendorList[selIndex].phno.toString(),
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    child: Icon(
                                      Icons.phone_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              height: query.height * 0.08,
                              width: query.width,
                              color: Theme.of(context).accentColor,
                              child: Center(
                                child: Text(
                                  "Book Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 25,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ))
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
