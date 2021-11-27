import 'package:breathe/Classes/CustomCard.dart';
import 'package:breathe/Constants/Constants.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  final List<dynamic> list;
  final bool loading;

  Dashboard({@required this.list, @required this.loading});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: query.height * 0.2),
      color: Colors.white,
      child: Scaffold(
        body: widget.loading
            ? SingleChildScrollView(
                child: SkeletonLoader(
                  builder: Container(
                      margin: EdgeInsets.only(top: 5),
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: widget.list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: query.width*0.08, vertical: 15),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3.0),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${DateFormat.MMMEd().format(DateTime.parse(widget.list[index]["DateTime"]))}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    )),
                                Row(
                                  children: [
                                    Text(
                                        'Paid : \u{20B9}${widget.list[index]["Price"].toInt().toString()}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        )),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(2),
                                      child: Icon(Icons.done,
                                          color: Colors.white, size: 15),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          CustomCard(
                            padding: EdgeInsets.all(0),
                            margin: EdgeInsets.zero,
                            radius: 10.0,
                            shadow: true,
                            boxShadow: BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                            color: Colors.white,
                            child: Container(
                                child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    CustomCard(
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.zero,
                                      color: Colors.white,
                                      radius: 10.0,
                                      shadow: true,
                                      boxShadow: BoxShadow(
                                        color:
                                            Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 8,
                                        offset: Offset(3, 0),
                                      ),
                                      child: Column(children: [
                                        userAvater(
                                            widget.list[index]["VA"],
                                            context,
                                            userImg),
                                        Container(
                                          padding: EdgeInsets.all(3),
                                          child: Text(
                                            widget.list[index]["VN"],
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ]),
                                    )
                                  ],
                                ),
                                Expanded(
                                    child:
                                        Icon(Icons.swap_horiz, size: 55)),
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
                                    offset: Offset(-3,
                                        0), // changes position of shadow
                                  ),
                                  child: Column(
                                    children: [
                                      userAvater(widget.list[index]["CA"],
                                          context, userImg),
                                      Container(
                                        padding: EdgeInsets.all(3),
                                        child: Text(
                                          widget.list[index]["CN"],
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
