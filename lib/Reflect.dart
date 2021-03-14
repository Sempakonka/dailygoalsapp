import 'package:dailygoals_app/globals.dart' as globals;
import 'package:dailygoals_app/reflectDay.dart';
import 'package:flutter/material.dart';
import 'package:dailygoals_app/Utils.dart' as utils;

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
                  Navigator.pushNamed(context, reflectDay.routeName, arguments: utils.getCurrentDay());
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
                  Navigator.pushNamed(context, reflectDay.routeName, arguments: new DateTime(utils.getCurrentDay().year, utils.getCurrentDay().month, utils.getCurrentDay().day - 1));
                }),
            RaisedButton(
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
                })
          ],
        ),
      ),
    );
  }
}
