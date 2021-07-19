import 'package:breathe/Classes/CustomCard.dart';
import "package:flutter/material.dart";

import 'Login.dart';
import 'Register.dart';

class LoginPageRoute extends MaterialPageRoute {
  LoginPageRoute({WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => Duration(milliseconds: 1300);
}

class RegisterPageRoute extends MaterialPageRoute {
  RegisterPageRoute({WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => Duration(milliseconds: 1100);
}

class LandingPage extends StatefulWidget {
  static String id = 'LandingPage';

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag : 'icon',
                child: Container(
                    child: Image.asset('Assets/Images/icon.png'), width: 250),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onPanDown: (var x) {
                  Navigator.push(context, LoginPageRoute(builder: (_) => Login()));
                },
                child: CustomCard(
                  child: Text('Log In', style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),),
                  color: Color(0xFF42A3F3),
                  radius: 30.0,
                ),
              ),
              SizedBox(height: 5,),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, RegisterPageRoute(builder: (_) => Register()));
                },
                child: CustomCard(
                  child: Text('Register', style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),),
                  color: Colors.blue,
                  radius: 30.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
