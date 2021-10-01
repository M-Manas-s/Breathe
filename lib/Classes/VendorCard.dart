import 'package:breathe/Constants/Constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CustomCard.dart';
import 'Vendor.dart';

class VendorCard extends StatelessWidget {
  final Vendor vendor;
  final Image userImg;
  const VendorCard({this.vendor, this.userImg}) ;

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: query.width * 0.38,
                    height: query.width * 0.38,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: userAvater(
                          vendor.avatarCode,
                          context,
                          userImg,
                          br: BorderRadius.circular(
                              100.0)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    vendor.name,
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .accentColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Rating :      "+vendor.rating.toStringAsFixed(1),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight.w700),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Icon(
                            Icons.star,
                            size: 20,
                            color: Colors.amber,
                          )
                        ],
                      ),
                      Text(
                        "Supplied: \t "+vendor.supplied.toString(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.w700),
                      ),
                      Text(
                        "Available: \t" +
                            vendor
                                .quantity
                                .toString(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.w700),
                      ),
                      Text(
                        "Distance: \t ${calculateDistance(
                            vendor.location, userLoc).toStringAsFixed(
                            2)} km",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.w700),
                      ),
                      GestureDetector(
                        onPanDown: (var x) {
                          launch(
                              'tel:${vendor.phno}');
                        },
                        child: CustomCard(
                          margin: EdgeInsets.zero,
                          padding:
                          EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10),
                          radius: 20,
                          color: Theme
                              .of(context)
                              .accentColor,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .center,
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
                                  fontWeight:
                                  FontWeight.w600,
                                  fontSize: 19,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              )
            ],
          ),
        ),
        SizedBox(height: 10,),
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
    ]
    );
  }
}
