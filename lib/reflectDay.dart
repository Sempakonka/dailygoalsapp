import 'package:flutter/material.dart';
import 'package:dailygoals_app/Reflect.dart';

class reflectDay extends StatefulWidget {
  static const routeName = "/reflectDayState";
  @override
  _reflectDayState createState() => _reflectDayState();
}

class _reflectDayState extends State<reflectDay> {
  DateTime selectedDay;
  @override
  Widget build(BuildContext context) {

   selectedDay = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: FlatButton(
          child: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor, size: 30),
          onPressed: () {
            Navigator.pushNamed(context, Reflect.routeName);
          },
        ),
      ),

      body: Center(
        child: Text(selectedDay.toString()),
      ),
    );
  }
}
