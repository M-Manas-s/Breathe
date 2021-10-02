import 'package:flutter/material.dart';

class UserSettings extends StatefulWidget {

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Container(
        width: query.width,
        margin: EdgeInsets.only(top: query.height * 0.11),
        color: Colors.white,
        child : Column(
          children: [
            Text("Settings"),
          ],
        )
    );
  }
}
