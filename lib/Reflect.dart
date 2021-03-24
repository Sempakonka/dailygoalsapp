import 'package:dailygoals_app/Utils.dart' as utils;
import 'package:dailygoals_app/globals.dart' as globals;
import 'package:dailygoals_app/reflectDay.dart';
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
      backgroundColor: globals.lightBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
          child: TextButton(
            child: Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 0, 10),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => globals.backgroundButtonBlue),
              shape: MaterialStateProperty.resolveWith(
                  (states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
              child: Text(
                "On What day do you want to reflect?",
                style: TextStyle(
                    fontSize: 22,
                    color: globals.darkBlue,
                    fontWeight: FontWeight.bold),
              ),
            ),
            RaisedButton(
                color: globals.backgroundButtonBlue,
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
                onPressed: () {
                  Navigator.pushNamed(context, reflectDay.routeName,
                      arguments: utils.getCurrentDay());
                }),
            RaisedButton(
                color: globals.backgroundButtonBlue,
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
                onPressed: () {
                  Navigator.pushNamed(context, reflectDay.routeName,
                      arguments: new DateTime(
                          utils.getCurrentDay().year,
                          utils.getCurrentDay().month,
                          utils.getCurrentDay().day - 1));
                }),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
                child: RaisedButton(
                    color: globals.backgroundButtonBlue,
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
                    onPressed: () {
                      Navigator.pushNamed(context, '/', arguments: true);
                    }))
          ],
        ),
      ),
    );
  }
}
