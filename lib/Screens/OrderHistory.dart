import 'package:breathe/Classes/CustomCard.dart';
import 'package:breathe/Constants/Constants.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:intl/intl.dart';

class OrderHistory extends StatefulWidget {
  List<dynamic> list = [];
  bool loading;

  OrderHistory({this.list, this.loading});

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<dynamic> perList = [];

  @override
  void initState() {
    super.initState();
    perList =
        widget.list.where((element) => element["CN"] == username).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: query.height * 0.2),
      child: widget.loading
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
                highlightColor: Theme.of(context).accentColor.withAlpha(100),
                direction: SkeletonDirection.ltr,
              ),
            )
          : Container(
              child: ListView.builder(
                  itemCount: perList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomCard(
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.only(
                            bottom: query.height * 0.015,
                            top: query.height * (index == 0 ? 0.02 : 0.015),
                            left: query.width * 0.06,
                            right: query.width * 0.06),
                        radius: 10.0,
                        shadow: true,
                        boxShadow: BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                        color: Colors.white,
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
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
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: query.height * 0.15,
                                      child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: userAvater(perList[index]["VA"],
                                            context, userImg),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      child: Text(
                                        perList[index]["VN"],
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: query.width * 0.04,
                                              top: query.height * 0.02,
                                              right: query.width * 0.04),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Date :",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                  )),
                                              SizedBox(
                                                height: query.height * 0.005,
                                              ),
                                              Text(
                                                  " ${DateFormat('d/M/y').format(DateTime.parse(widget.list[index]["DateTime"]))}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: query.width * 0.04,
                                              vertical: query.height * 0.005),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text('Paid :',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  )),
                                              SizedBox(
                                                height: query.height * 0.005,
                                              ),
                                              Text(
                                                  ' \u{20B9}${widget.list[index]["Price"].toInt().toString()}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                  ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    CustomCard(
                                        radius: 20,
                                        padding: EdgeInsets.all(7),
                                        margin: EdgeInsets.only(
                                            left: query.width * 0.2,
                                            right: query.width * 0.04,
                                            top: query.height * 0.02,
                                            bottom: query.height * 0.02),
                                        color: Color(0xfffa6e64),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.file_download,
                                              size: 20,
                                            ),
                                            Text(
                                              " Invoice",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              width: query.width * 0.04,
                                            )
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ));
                  })),
    );
  }
}
