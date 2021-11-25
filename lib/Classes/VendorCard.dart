import 'package:breathe/Constants/Constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CustomCard.dart';
import 'Vendor.dart';

class VendorCard extends StatelessWidget {
  final Vendor vendor;

  const VendorCard({this.vendor});

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Column(children: [
      IntrinsicHeight(
        child: Row(
          children: [
            Column(
              children: [
                SizedBox(
                  width: query.width * 0.33,
                  height: query.width * 0.33,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: userAvater(vendor.avatarCode, context, userImg, br: BorderRadius.circular(100.0)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  vendor.name,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Container(
                    padding: EdgeInsets.symmetric(horizontal: query.width * 0.04, vertical: query.height * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rating :",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Row(
                          children: [
                            Text(
                              "${vendor.rating.toStringAsFixed(1)}",
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          vendor.supplied.toString(),
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          vendor.quantity.toString(),
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "${calculateDistance(vendor.location, userLoc).toStringAsFixed(2)} km",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onPanDown: (var x) {
                      launch('tel:${vendor.phno}');
                    },
                    child: CustomCard(
                      margin: EdgeInsets.only(left: query.width*0.04),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      radius: 20,
                      color: Theme.of(context).accentColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Call ${vendor.name.split(' ')[0]} ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
      SizedBox(
        height: 0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.place, size: 28),
          SizedBox(
            width: 5,
          ),
          Text(
            vendor.address,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ],
      )
    ]);
  }
}
