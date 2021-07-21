import 'package:breathe/Classes/CustomCard.dart';
import 'package:breathe/Constants/Constants.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  static String id = 'Register';

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String errorText;
  String email;
  String password;
  bool spinner = false;
  bool state = true;
  bool absorb = false;

  //FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          //padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Breathe",
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Container(
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
                            hintText: "Full Name",
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                          validator: emailChecker,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Container(
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
                            hintText: "Your Email",
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                          validator: emailChecker,
                        ),
                      ),
                    ],
                  ),
                ),
                //SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Stack(
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
                                hintText: "Create a Password",
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
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Phone Number",
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Container(
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
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            filled: true,
                            //hintText: "+91 ",
                            prefixText: "+91 ",
                            prefixStyle: TextStyle(color: Colors.black),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                          validator: emailChecker,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                GestureDetector(
                  onPanDown: (var x) {
                    //Navigator.push(context, LoginPageRoute(builder: (_) => Login()));
                  },
                  child: CustomCard(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 80,
                    ),
                    color: Color(0xFF1F4F99),
                    radius: 30.0,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
