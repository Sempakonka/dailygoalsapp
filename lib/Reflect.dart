import 'package:dailygoals_app/globals.dart' as globals;
import 'package:flutter/material.dart';

class Reflect extends StatefulWidget {
  static const routeName = '/Reflect';

  @override
  _ReflectState createState() => _ReflectState();
}

class _ReflectState extends State<Reflect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: FlatButton(
          child: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor, size: 30),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "On What day do you want to reflect?",
              style: TextStyle(
                  fontSize: 22,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            RaisedButton(
                color: globals.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: Text(
                  "Today",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                onPressed: () {}),
            RaisedButton(
                color: globals.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: Text(
                  "Yesterday",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                onPressed: () {}),
            RaisedButton(
                color: globals.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: Text(
                  "I want to reflect on an other day",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                onPressed: () {})
          ],
        ),
      ),
    );
  }
}
