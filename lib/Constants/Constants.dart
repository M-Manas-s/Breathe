import 'dart:math';

import 'package:breathe/Classes/Vendor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<Vendor> vendorList = [];
LatLng userLoc;
int userAv;
String username;
String useremail;
String phno;
Image userImg;

class CustomRoute extends MaterialPageRoute {
  CustomRoute({WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => Duration(milliseconds: 800);
}

double calculateDistance(LatLng p1, LatLng p2) {
  double lat1 = p1.latitude;
  double lon1 = p1.longitude;
  double lat2 = p2.latitude;
  double lon2 = p2.longitude;

  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

String passwordValidator(value) {
  if (value.isEmpty) {
    return 'Please Enter Text';
  } else if (value.length <= 7) {
    return 'Password Must Be Atleast 8 Characters Long';
  } else {
    return null;
  }
}

String emailChecker(value) {
  String pattern = r'.+@.+[.].+';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty) {
    return 'Please Enter Text';
  } else if (!regex.hasMatch(value)) {
    return "Please Enter A Valid Email";
  }

  return null;
}

String nameValidator(value) {
  if (value.isEmpty) {
    return 'Please Enter Your Name';
  } else {
    return null;
  }
}

String phoneNumberChecker(value) {
  print(value);
  String pattern = r'^[0-9]{10}$';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty) {
    return 'Please Enter Text';
  } else if (!regex.hasMatch(value)) {
    return "Please Enter A Valid Email";
  }

  return null;
}

class buttonWidget extends StatelessWidget {
  final String title;
  final Function onpressed;

  const buttonWidget({
    Key key,
    this.title,
    this.onpressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        elevation: 2.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        minWidth: MediaQuery.of(context).size.width * 0.3,
        color: Theme.of(context).accentColor,
        onPressed: onpressed,
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ));
  }
}

//DONT HAVE ACCOUNT?
class signUpRichText extends StatelessWidget {
  final String title;
  final String text;
  final Function onTap;

  const signUpRichText({
    Key key,
    @required this.title,
    @required this.onTap,
    this.text = "Don't Have An Account? ",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: text,
          style: TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(
                recognizer: TapGestureRecognizer()..onTap = onTap,
                text: title,
                style: TextStyle(decoration: TextDecoration.underline))
          ]),
    );
  }
}

Alignment getAlign(int pos) {
  int x = (pos / 10).floor();
  int y = pos % 10;
  double posx, posy;
  switch (x) {
    case 1:
      posx = -1;
      break;
    case 2:
      posx = -1 / 3;
      break;
    case 3:
      posx = 1 / 3;
      break;
    case 4:
      posx = 1;
      break;
  }

  switch (y) {
    case 1:
      posy = 1;
      break;
    case 2:
      posy = 1 / 3;
      break;
    case 3:
      posy = -1 / 3;
      break;
    case 4:
      posy = -1;
      break;
  }

  return Alignment(posx, posy);
}

Widget userAvater(int avatarCode, BuildContext context, Image userImg,
    {double width = 1.2,
    BorderRadius br = const BorderRadius.only(
      topRight: Radius.circular(10.0),
      topLeft: Radius.circular(10.0),
    )}) {
  return ClipRRect(
    borderRadius: br,
    child: Align(
      alignment: getAlign(avatarCode),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * width,
        child: userImg,
      ),
      widthFactor: 0.25,
      heightFactor: 0.25,
    ),
  );
}
