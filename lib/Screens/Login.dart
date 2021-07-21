import 'package:breathe/Classes/CustomCard.dart';
import 'package:breathe/Constants/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'Dashboard.dart';
import 'LandingPage.dart';
import 'Register.dart';

class RegisterPageRoute extends MaterialPageRoute {
  RegisterPageRoute({WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => Duration(milliseconds: 800);
}

class DashboardRoute extends MaterialPageRoute {
  DashboardRoute({WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => Duration(milliseconds: 1100);
}

class Login extends StatefulWidget {
  static String id = 'Login';

  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String errorText;
  String email;
  String password;
  bool spinner = false;
  bool state = true;
  bool absorb = false;

  //FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  void login() async {
    //
    //   if (_formKey.currentState.validate()) {
    //     setState(() {
    //       spinner = true;
    //     });
    //     try {
    //       var user = await auth.signInWithEmailAndPassword(
    //           email: email, password: password);
    //       await FirebaseFirestore.instance
    //           .collection('Student')
    //           .where('Email', isEqualTo: email)
    //           .get()
    //           .then((QuerySnapshot querySnapshot) {
    //         if ( querySnapshot.docs.length==0 ) {
    //           print("Not a Student");
    //           throw Exception(
    //               "Not a Student");
    //         }
    //       });
    //
    //
    //       SharedPreferences prefs = await SharedPreferences.getInstance();
    //       prefs.setString('email', '$email');
    //       prefs.setString('user','Student');
    //       if (user != null) {
    //         Navigator.pushAndRemoveUntil(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (context) => LandingPage()
    //             ),
    //             ModalRoute.withName(LandingPage.id)
    //         );
    //       }
    //     }
    //     on Exception{
    //       setState(() {
    //         spinner = false;
    //         errorText = "Wrong Email/Password";
    //       });
    //     }
    //   }
    // },
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        "Assets/Images/bk.jpg",
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
      ),
      Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.07,
                ),
                Hero(
                  tag: 'icon',
                  child: Container(
                      child: Image.asset('Assets/Images/icon.png'),
                      width: MediaQuery.of(context).size.height*0.25),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.01,
                ),
                Text(
                  'Breathe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.05,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFD2D2D2),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: TextFormField(
                      onChanged: (value) {
                        email = value.trim();
                      },
                      cursorColor: Theme.of(context).accentColor,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: false,
                        hintText: "Email",
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                      validator: emailChecker,
                    ),
                  ),
                ),
                //SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFD2D2D2),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: TextFormField(
                          onChanged: (value) {
                            password = value.trim();
                          },
                          obscureText: state,
                          cursorColor: Theme.of(context).accentColor,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            filled: false,
                            hintText: "Password",
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                          validator: passwordValidator,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 20,
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (state == false) {
                                  setState(() {
                                    state = true;
                                  });
                                } else if (state == true) {
                                  setState(() {
                                    state = false;
                                  });
                                }
                              });
                            },
                            child: Icon(Icons.remove_red_eye)),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.05,
                ),
                GestureDetector(
                  onPanDown: (var x) {
                    //Navigator.push(context, LoginPageRoute(builder: (_) => Login()));
                  },
                  child: CustomCard(
                    child: Text(
                      'Log In',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 80,),
                    color: Color(0xFF1F4F99),
                    radius: 30.0,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.02,
                ),
                signUpRichText(
                  title: "Sign Up!",
                  onTap: () {
                    Navigator.push(context,
                        RegisterPageRoute(builder: (_) => Register()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
