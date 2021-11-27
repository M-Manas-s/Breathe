import 'dart:async';

import 'package:breathe/Classes/CustomCard.dart';
import 'package:breathe/Classes/Vendor.dart';
import 'package:breathe/Classes/VendorCard.dart';
import 'package:breathe/Constants/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_icons/animate_icons.dart';

import 'Home.dart';

class MapView extends StatefulWidget {
  static String id = 'MapViewView';
  final Vendor selVendor;
  final bool preLoaded;

  const MapView({Key key, this.selVendor, this.preLoaded}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController _controller;
  AnimateIconController ic;
  bool infovis = false;
  int selIndex;
  bool spinner = false;
  bool booked = false;
  bool resizeMap = false;
  Image userImg;
  int rating = -1;

  @override
  void initState() {
    if (widget.preLoaded) activeIndex(vendorList.indexOf(widget.selVendor));
    super.initState();
    ic = AnimateIconController();
    userImg = Image.asset('assets/images/user.jpg');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(userImg.image, context);
  }

  void activeIndex(int index) {
    setState(() {
      setState(() {
        infovis = true;
        selIndex = index;
      });
    });
  }

  List<Marker> makeSet() {
    List<Marker> list = [];
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

  Widget cancelButton() {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    return cancelButton;
  }

  showCancelAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pushAndRemoveUntil(
            context, CustomRoute(builder: (_) => Home()), (r) => false);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Cancel Search?"),
      actions: [okButton, cancelButton()],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showConfirmationAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () async {
        Navigator.of(context).pop();
        setState(() {
          spinner = true;
        });

        String ve;
        double price;
        int qu;
        String id;
        int sup;

        SharedPreferences prefs = await SharedPreferences.getInstance();

        await FirebaseFirestore.instance
            .collection('Vendor')
            .where('Name', isEqualTo: vendorList[selIndex].name)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            id = doc.id;
            ve = doc['Email'];
            price = doc['Price'] * 1.00;
            qu = doc['Quantity'];
            sup = doc['Supplied'];
          });
        });

        await FirebaseFirestore.instance
            .collection('Vendor')
            .doc(id)
            .update({'Quantity': --qu})
            .catchError(
                (error) => print("Failed to update user: $error"));

        await FirebaseFirestore.instance
            .collection('Vendor')
            .doc(id)
            .update({'Supplied': ++sup})
            .catchError(
                (error) => print("Failed to update user: $error"));

        await FirebaseFirestore.instance.collection('DealsHistory').add({
          'VendorEmail': ve,
          'CustomerEmail': prefs.get('Email'),
          'Price': price,
          'DateTime': DateTime.now().toString(),
        });

        setState(() {
          spinner = false;
        });

        showRateAlertDialog(context);
      },
    );
    Size query = MediaQuery.of(context).size;

    AlertDialog alert = AlertDialog(
      titlePadding: EdgeInsets.symmetric(
          horizontal: query.width * 0.1, vertical: query.height * 0.02),
      contentPadding:
          EdgeInsets.symmetric(horizontal: query.width * 0.05, vertical: 10),
      actionsPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      title: Text("Book Oxygen Cylinder?"),
      content: Container(
        height: query.width * 0.31,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                CustomCard(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  radius: 10.0,
                  shadow: true,
                  boxShadow: BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: Offset(3, 0),
                  ),
                  child: Column(children: [
                    SizedBox(
                      width: query.width * 0.24,
                      height: query.width * 0.24,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: userAvater(
                          vendorList[selIndex].avatarCode,
                          context,
                          userImg,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(3),
                      child: Text(
                        vendorList[selIndex].name.split(' ')[0],
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
            Icon(Icons.swap_horiz, size: 45),
            Column(
              children: [
                CustomCard(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  radius: 10.0,
                  shadow: true,
                  boxShadow: BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: Offset(-3, 0), // changes position of shadow
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: query.width * 0.24,
                        height: query.width * 0.24,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: userAvater(
                            userAv,
                            context,
                            userImg,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(3),
                        child: Text(
                          username.split(' ')[0],
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
          ],
        ),
      ),
      actions: [okButton, cancelButton()],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showRateAlertDialog(BuildContext context) {

    Widget cancel = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
        setState(() {
          booked = true;
        });

        Timer(const Duration(milliseconds: 200), () {
          setState(() {
            ic.animateToEnd();
          });
        });

        Timer(const Duration(milliseconds: 1500), () {
          Navigator.pushAndRemoveUntil(
              context, CustomRoute(builder: (_) => Home()), (r) => false);
        });
      },
    );

    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () async {
        Navigator.of(context).pop();
        setState(() {
          spinner = true;
        });

        String id;
        int sup;
        double rat;

        await FirebaseFirestore.instance
            .collection('Vendor')
            .where('Name', isEqualTo: vendorList[selIndex].name)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            id = doc.id;
            sup = doc['Supplied'];
            rat = doc['Rating']*1.0;
          });
        });
        double nrating;
        if ( sup != 0 ) {
          nrating = rat * (sup - 1) + rating;
          nrating = nrating / (sup);
        }
        else
          nrating = (rat+rating)/2;

        if (rating != -1)
          await FirebaseFirestore.instance
              .collection('Vendor')
              .doc(id)
              .update({'Rating': nrating}).catchError(
                  (error) => print("Failed to update user: $error"));

        setState(() {
          spinner = false;
          booked = true;
        });

        Timer(const Duration(milliseconds: 200), () {
          setState(() {
            ic.animateToEnd();
          });
        });

        Timer(const Duration(milliseconds: 1500), () {
          Navigator.pushAndRemoveUntil(
              context, CustomRoute(builder: (_) => Home()), (r) => false);
        });
      },
    );
    Size query = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (BuildContext context)
    {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            titlePadding: EdgeInsets.symmetric(
                horizontal: query.width * 0.1, vertical: query.height * 0.02),
            contentPadding:
            EdgeInsets.symmetric(horizontal: query.width * 0.05, vertical: 10),
            actionsPadding: EdgeInsets.zero,
            buttonPadding: EdgeInsets.zero,
            title: Text("Rate the Vendor"),
            content: Container(
              height: query.height * 0.05,
              width: query.width * 0.9,
              child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Icon(
                          rating > 0 ? Icons.star : Icons.star_border,
                          color: rating > 0 ? Colors.yellow : Colors.black,
                          size: 45,
                        ),
                        onTap: () {
                          setState(() {
                            rating = 1;
                          });
                        },
                      ),
                      GestureDetector(
                        child: Icon(
                          rating > 1 ? Icons.star : Icons.star_border,
                          color: rating > 1 ? Colors.yellow : Colors.black,
                          size: 45,
                        ),
                        onTap: () {
                          setState(() {
                            rating = 2;
                          });
                        },
                      ),
                      GestureDetector(
                        child: Icon(
                          rating > 2 ? Icons.star : Icons.star_border,
                          color: rating > 2 ? Colors.yellow : Colors.black,
                          size: 45,
                        ),
                        onTap: () {
                          setState(() {
                            rating = 3;
                          });
                        },
                      ),
                      GestureDetector(
                        child: Icon(
                          rating > 3 ? Icons.star : Icons.star_border,
                          color: rating > 3 ? Colors.yellow : Colors.black,
                          size: 45,
                        ),
                        onTap: () {
                          setState(() {
                            rating = 4;
                          });
                        },
                      ),
                      GestureDetector(
                        child: Icon(
                          rating > 4 ? Icons.star : Icons.star_border,
                          color: rating > 4 ? Colors.yellow : Colors.black,
                          size: 45,
                        ),
                        onTap: () {
                          setState(() {
                            rating = 5;
                          });
                        },
                      ),
                    ],
                  )),
            ),
            actions: [okButton, cancel],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    var mapPadding = query.height * 0.05;

    return WillPopScope(
      onWillPop: () async {
        if (infovis)
          setState(() {
            infovis = false;
          });
        else
          showCancelAlertDialog(context);
        return false;
      },
      child: ModalProgressHUD(
        progressIndicator: SpinKitChasingDots(
          color: Color(0xFF1F4F99),
          size: 30.0,
        ),
        inAsyncCall: spinner,
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                height: query.height * 0.63,
                child: GoogleMap(
                  myLocationEnabled: true,
                  padding: EdgeInsets.only(bottom: mapPadding),
                  onMapCreated: (GoogleMapController controller) async {
                    _controller = controller;
                    Completer().complete(controller);
                    setState(() {
                      mapPadding = query.height * 0.05;
                    });
                  },
                  markers: makeSet().toSet(),
                  initialCameraPosition: CameraPosition(
                    target: userLoc,
                    zoom: 13.0,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: query.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0))),
                  height: query.height * 0.43,
                  child: Center(
                    child: !infovis
                        ? Column(
                            mainAxisAlignment: infovis
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      "Oxygen Vendors near you",
                                      style: TextStyle(
                                        color: Color(0xFF1F4F99),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 30),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.all(
                                          (Radius.circular(10)))),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: vendorList.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          _controller.moveCamera(
                                              CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                                target:
                                                    vendorList[index].location,
                                                zoom: 13.0),
                                          ));
                                          activeIndex(index);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 7),
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: Column(
                                              children: [
                                                userAvater(
                                                    vendorList[index]
                                                        .avatarCode,
                                                    context,
                                                    userImg,
                                                    br: BorderRadius.circular(
                                                        100.0)),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(vendorList[index]
                                                    .name
                                                    .split(' ')[0])
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      "Tap on a vendor to know more",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: query.width * 0.05,
                                vertical: query.height * 0.02),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                VendorCard(
                                  vendor: vendorList[selIndex],
                                ),
                                Container(
                                  height: query.height * 0.08,
                                  width: query.width,
                                  child: GestureDetector(
                                    onPanDown: (var x) {
                                      showConfirmationAlertDialog(context);
                                    },
                                    child: CustomCard(
                                      margin: EdgeInsets.zero,
                                      padding: EdgeInsets.only(
                                          left: 22,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                      radius: 20,
                                      color: Color(0xFF1F4F99),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Book Cylinder",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 21,
                                                  letterSpacing: 1),
                                            ),
                                            CustomCard(
                                              margin: EdgeInsets.zero,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 5),
                                              child: Text(
                                                "\u20B9 ${vendorList[selIndex].price.toStringAsFixed(0)}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 19),
                                              ),
                                              color: Colors.blue.shade600,
                                              radius: 14,
                                            )
                                          ]),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                  ),
                ),
              ),
              booked
                  ? Container(
                      width: query.width,
                      height: query.height,
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(300))),
                          width: query.height * 0.2,
                          height: query.height * 0.2,
                          child: Center(
                            child: AnimateIcons(
                              startIcon: Icons.circle,
                              endIcon: Icons.check_circle,
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
                              duration: Duration(milliseconds: 400),
                              startIconColor: Colors.green,
                              endIconColor: Colors.green,
                              clockwise: true,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(height: 0)
            ],
          ),
        ),
      ),
    );
  }
}
