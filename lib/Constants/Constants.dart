import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

String passwordValidator(value) {

  if (value.isEmpty) {
    return 'Please Enter Text';
  } else if (value.length <= 7) {
    return 'Password Must Be Atleast 8 Characters Long';
  }
  else {
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