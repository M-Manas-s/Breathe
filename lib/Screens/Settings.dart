import 'package:breathe/Constants/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flash/flash.dart';

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  String localName = username;
  String localPhoneNumber = phno;
  int localAvatarCode = userAv;
  double localPrice = gprice;
  int localQuantity = gquantity;

  List<int> avlist = [11, 12, 13, 14, 21, 22, 23, 24, 31, 32, 33, 34, 41, 42, 43, 44];

  @override
  void initState() {
    super.initState();
  }

  void _showBasicsFlash({
    Duration duration,
    flashStyle = FlashBehavior.floating,
  }) {
    showFlash(
      context: context,
      duration: duration,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          behavior: flashStyle,
          position: FlashPosition.bottom,
          boxShadows: kElevationToShadow[4],
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          child: FlashBar(
            content: Text('Saved'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Container(
        width: query.width,
        margin: EdgeInsets.only(top: query.height * 0.2),
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(top: query.height * 0.07),
          height: query.height * 0.8,
          child: LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: query.width * 0.08),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name ",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                                ),
                                SizedBox(
                                  height: query.height * 0.01,
                                ),
                                SizedBox(
                                  width: query.width * 0.84,
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        localName = value;
                                      });
                                    },
                                    cursorColor: Color(0xFF1F4F99),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                      hintText: localName,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: query.height * 0.015,
                          ),
                          Divider(),
                          SizedBox(
                            height: query.height * 0.015,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: query.width * 0.08),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone Number ",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                                ),
                                SizedBox(
                                  height: query.height * 0.01,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: query.width * 0.14,
                                      child: Text("+91 ",
                                          style: TextStyle(
                                            fontSize: 22,
                                          )),
                                    ),
                                    SizedBox(
                                      width: query.width * 0.7,
                                      child: TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            localPhoneNumber = value.toString();
                                          });
                                        },
                                        cursorColor: Color(0xFF1F4F99),
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 22,
                                        ),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                          hintText: localPhoneNumber,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: query.height * 0.015,
                          ),
                          Divider(),
                          user == 'Vendor' ? Column(
                            children: [

                              SizedBox(
                                height: query.height * 0.015,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: query.width * 0.08),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Price ",
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                                        ),
                                        SizedBox(
                                          height: query.height * 0.01,
                                        ),
                                        SizedBox(
                                          width: query.width * 0.40,
                                          child: TextField(
                                            onChanged: (value) {
                                              setState(() {
                                                localPrice = double.parse(value);
                                              });
                                            },
                                            keyboardType: TextInputType.number,
                                            cursorColor: Color(0xFF1F4F99),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 22,
                                            ),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                              hintText: localPrice.toStringAsFixed(2),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: query.width*0.04,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Quantity ",
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                                        ),
                                        SizedBox(
                                          height: query.height * 0.01,
                                        ),
                                        SizedBox(
                                          width: query.width * 0.40,
                                          child: TextField(
                                            onChanged: (value) {
                                              setState(() {
                                                localQuantity = int.parse(value);
                                              });
                                            },
                                            cursorColor: Color(0xFF1F4F99),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 22,
                                            ),
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                              hintText: localQuantity.toString(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: query.height * 0.015,
                              ),
                              Divider(),
                            ],
                          ) : Container(),
                          SizedBox(
                            height: query.height * 0.015,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: query.width * 0.08),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Avatar ",
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: query.height * 0.01,
                                    ),
                                    Container(
                                      width: query.width * 0.84,
                                      height: query.width * 0.3,
                                      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2), borderRadius: BorderRadius.all((Radius.circular(10)))),
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: avlist.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                localAvatarCode = avlist[index];
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                              child: avlist[index] == localAvatarCode
                                                  ? Stack(
                                                      children: [
                                                        FittedBox(
                                                          fit: BoxFit.fill,
                                                          child: Stack(children: [
                                                            userAvater(avlist[index], context, userImg, br: BorderRadius.circular(100.0)),
                                                          ]),
                                                        ),
                                                        Positioned.fill(
                                                            left: 0,
                                                            right: 0,
                                                            top: 0,
                                                            bottom: 0,
                                                            child: Container(
                                                              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(300)),
                                                            )),
                                                        Positioned.fill(
                                                          child: Align(
                                                            alignment: Alignment.center,
                                                            child: Icon(
                                                              Icons.done,
                                                              color: Colors.white,
                                                              size: 40,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : FittedBox(
                                                      fit: BoxFit.fill,
                                                      child: userAvater(avlist[index], context, userImg, br: BorderRadius.circular(100.0)),
                                                    ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: query.height * 0.015,
                          ),
                          Divider(),
                          SizedBox(
                            height: query.height * 0.015,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          _showBasicsFlash(duration: Duration(seconds: 2), flashStyle: FlashBehavior.fixed);

                          String id;
                          await FirebaseFirestore.instance.collection(user).where('Email', isEqualTo: useremail).get().then((QuerySnapshot querySnapshot) {
                            querySnapshot.docs.forEach((doc) {
                              id = doc.id;
                            });
                          });

                          if (localAvatarCode != userAv)
                            await FirebaseFirestore.instance.collection(user).doc(id).update({'Avatar': localAvatarCode}).catchError((error) => print("Failed to update user: $error"));

                          if (localName != username)
                            await FirebaseFirestore.instance.collection(user).doc(id).update({'Name': localName}).catchError((error) => print("Failed to update user: $error"));

                          if (phno != localPhoneNumber)
                            await FirebaseFirestore.instance.collection(user).doc(id).update({'PhoneNumber': localPhoneNumber}).catchError((error) => print("Failed to update user: $error"));

                          if (gquantity != localQuantity)
                            await FirebaseFirestore.instance.collection(user).doc(id).update({'Quantity': localQuantity}).catchError((error) => print("Failed to update user: $error"));

                          if (gprice != localPrice)
                            await FirebaseFirestore.instance.collection(user).doc(id).update({'Price': localPrice}).catchError((error) => print("Failed to update user: $error"));

                          setState(() {
                            userAv = localAvatarCode;
                            username = localName;
                            phno = localPhoneNumber;
                          });
                        },
                        child: Container(
                          height: query.height * 0.08,
                          color: Color(0xFF1F4F99),
                          child: Center(
                            child: Text(
                              "UPDATE",
                              style: TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 1, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
