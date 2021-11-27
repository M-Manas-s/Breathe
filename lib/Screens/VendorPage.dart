import 'package:breathe/Classes/CustomCard.dart';
import 'package:breathe/Classes/Vendor.dart';
import 'package:breathe/Constants/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'MapView.dart';

class VendorPage extends StatefulWidget {
  @override
  _VendorPageState createState() => _VendorPageState();
}

class _VendorPageState extends State<VendorPage> {
  bool loaded = false;
  String dropdownValue = 'Distance';
  bool increasingOrder = true;

  Future<void> _getCurrentPosition() async {
    final GeolocatorPlatform _geolocationPlatform = GeolocatorPlatform.instance;
    final position = await _geolocationPlatform.getCurrentPosition();
    userLoc = LatLng(position.latitude, position.longitude);
  }

  readData() async {
    vendorList.clear();

    await FirebaseFirestore.instance.collection('Vendor').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['Location'] != 'null' && doc['Quantity'] > 0)
          vendorList.add(Vendor(
              name: doc['Name'],
              phno: int.parse(doc['PhoneNumber']),
              email: doc['Email'],
              price: (doc['Price'] * 1.00),
              location: stringToLatLng(doc['Location']),
              quantity: doc['Quantity'],
              address: doc['Address1'] + " " + doc['Address2'],
              rating: doc['Rating'],
              totalRatings: doc['TotalRatings'],
              supplied: doc['Supplied'],
              avatarCode: doc['Avatar']));
      });
    });
  }

  LatLng stringToLatLng(String str) {
    LatLng loc = LatLng(double.parse(str.split(',')[0]), double.parse(str.split(',')[1]));
    return loc;
  }

  closestTen() {
    vendorList.sort((a, b) => (calculateDistance(a.location, userLoc)).compareTo(calculateDistance(b.location, userLoc)));
    while (vendorList.length > 10) vendorList.removeLast();
    print(vendorList.length - 1);
    for (int i = (vendorList.length - 1); i >= 0; i--) if (calculateDistance(vendorList[i].location, userLoc) > 100) vendorList.removeAt(i);
  }

  void loadPreRequisites() async {
    await _getCurrentPosition();
    await readData();
    closestTen();
    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPreRequisites();
  }

  void reloadList(String value, BuildContext context, {bool forceOrder = false}) {
    // 'Rating', 'Price', 'Supplied', 'Distance'

    setState(() {
      loaded = false;
    });
    switch (value) {
      case 'Rating':
        if (forceOrder && increasingOrder)
          vendorList.sort((a, b) => (a.rating).compareTo(b.rating));
        else {
          vendorList.sort((a, b) => (b.rating).compareTo(a.rating));
          increasingOrder = false;
        }
        break;

      case 'Price':
        if (forceOrder && !increasingOrder)
          vendorList.sort((a, b) => (b.price).compareTo(a.price));
        else {
          vendorList.sort((a, b) => (a.price).compareTo(b.price));
          increasingOrder = true;
        }
        break;

      case 'Supplied':
        if (forceOrder && increasingOrder)
          vendorList.sort((a, b) => (a.supplied).compareTo(b.supplied));
        else {
          vendorList.sort((a, b) => (b.supplied).compareTo(a.supplied));
          increasingOrder = false;
        }
        break;

      case 'Distance':
        if (forceOrder && !increasingOrder)
          vendorList.sort((a, b) => (calculateDistance(b.location, userLoc)).compareTo(calculateDistance(a.location, userLoc)));
        else {
          vendorList.sort((a, b) => (calculateDistance(a.location, userLoc)).compareTo(calculateDistance(b.location, userLoc)));
          increasingOrder = true;
        }
        break;
    }
    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.only(top: query.height * 0.2),
        color: Colors.white,
        child: Scaffold(
            body: !loaded
                ? SingleChildScrollView(
                    child: SkeletonLoader(
                      builder: Container(
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                          child: CustomCard(
                              color: Colors.white,
                              radius: 10.0,
                              child: Container(
                                width: query.width * 0.8,
                                height: query.height * 0.17,
                              ))),
                      items: 7,
                      period: Duration(seconds: 2),
                      highlightColor: Color(0xFF1F4F99).withAlpha(100),
                      direction: SkeletonDirection.ltr,
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(top: query.height * 0.04),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: query.width * 0.04, vertical: query.height * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: query.width * 0.05),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Filter by :",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    DropdownButton<String>(
                                      value: dropdownValue,
                                      elevation: 16,
                                      style: const TextStyle(color: Color(0xFF1F4F99)),
                                      underline: Container(
                                        height: 2,
                                        color: Color(0xFF1F4F99),
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          dropdownValue = newValue;
                                          reloadList(newValue, context);
                                        });
                                      },
                                      items: <String>['Rating', 'Price', 'Supplied', 'Distance'].map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
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
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: Icon(increasingOrder ? Icons.arrow_upward : Icons.arrow_downward, color: Colors.black),
                                    onPressed: () {
                                      increasingOrder = !increasingOrder;
                                      reloadList(dropdownValue, context, forceOrder: true);
                                    },
                                  ))
                            ],
                          ),
                        ),
                        Flexible(
                          child: MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: vendorList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      margin: EdgeInsets.only(
                                        bottom: query.width * 0.04,
                                        left: query.width * 0.04,
                                        right: query.width * 0.04,
                                      ),
                                      padding: EdgeInsets.all(query.width * 0.03),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.4),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(children: [
                                        IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              Column(
                                                children: [
                                                  SizedBox(
                                                    width: query.width * 0.3,
                                                    height: query.width * 0.3,
                                                    child: FittedBox(
                                                      fit: BoxFit.fill,
                                                      child: userAvater(vendorList[index].avatarCode, context, userImg, br: BorderRadius.circular(100.0)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    vendorList[index].name,
                                                    style: TextStyle(
                                                      color: Color(0xFF1F4F99),
                                                      fontWeight: FontWeight.w800,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(left: 10),
                                                  child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: query.width * 0.04, vertical: query.height * 0.01),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Rating :",
                                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "${vendorList[index].rating.toStringAsFixed(1)}",
                                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                                              ),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                              Icon(
                                                                Icons.star,
                                                                size: 18,
                                                                color: Colors.amber,
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(left: query.width * 0.04, bottom: query.width * 0.01, right: query.width * 0.04),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Supplied:",
                                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                                          ),
                                                          Text(
                                                            vendorList[index].supplied.toString(),
                                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(left: query.width * 0.04, bottom: query.width * 0.01, right: query.width * 0.04),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Available:",
                                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                                          ),
                                                          Text(
                                                            vendorList[index].quantity.toString(),
                                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(left: query.width * 0.04, bottom: query.width * 0.02, right: query.width * 0.04),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Distance:",
                                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                                          ),
                                                          Text(
                                                            "${calculateDistance(vendorList[index].location, userLoc).toStringAsFixed(2)} km",
                                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                            onPanDown: (var x) {},
                                                            child: CustomCard(
                                                              margin: EdgeInsets.symmetric(horizontal: query.width * 0.02),
                                                              padding: EdgeInsets.symmetric(horizontal: query.width * 0.03, vertical: 7),
                                                              radius: 20,
                                                              color: Color(0xFF1F4F99),
                                                              child: Text(
                                                                "\u20B9 ${vendorList[index].price.toStringAsFixed(0)}",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            )),
                                                        GestureDetector(
                                                            onPanDown: (var x) {
                                                              Navigator.pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => MapView(
                                                                            preLoaded: true,
                                                                            selVendor: vendorList[index],
                                                                          )),
                                                                  ModalRoute.withName(MapView.id));
                                                            },
                                                            child: CustomCard(
                                                              margin: EdgeInsets.symmetric(horizontal: query.width * 0.02),
                                                              padding: EdgeInsets.symmetric(horizontal: query.width * 0.03, vertical: 7),
                                                              radius: 20,
                                                              color: Color(0xFF1F4F99),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Icon(
                                                                    Icons.gps_fixed,
                                                                    color: Colors.white,
                                                                    size: 18,
                                                                  ),
                                                                  Text(
                                                                    " Locate",
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 15,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                      ],
                                                    )
                                                  ]),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(Icons.place, size: 28),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              vendorList[index].address,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        )
                                      ]));
                                }),
                          ),
                        )
                      ],
                    ))));
  }
}
