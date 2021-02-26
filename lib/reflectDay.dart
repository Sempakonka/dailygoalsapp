import 'package:dailygoals_app/Reflect.dart';
import 'package:dailygoals_app/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //Center Column contents vertically,
          crossAxisAlignment: CrossAxisAlignment.center,
          //Center Column contents horizontally,
          children: [
            Text(
              () {
                String theReflectingDay =
                    Jiffy(selectedDay).format("EEEE MMM do ");
                return "You're reflecting on $theReflectingDay";
              }(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "So, did you reach your goals?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).primaryColor),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ListView.builder(
                    itemCount: globals.activatedDays[selectedDay].goals.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildGoalsList(context, index, selectedDay)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildGoalsList(
      BuildContext context, int index, DateTime _selectedDay) {
    return new Container(
        margin: EdgeInsets.only(left: 9, top: 0, right: 9, bottom: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 2),
              )
            ]),
        child: ListTile(
          onTap: () {
            ///TODO: expand to see the description, if no description than expand to show "no description"
          },
          title: Center(
            child: Column(children: [
              Text(
                globals.activatedDays[_selectedDay].goals[index].title,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //Center Row contents horizontally,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //Center Row contents vertically,

                  children: [
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                        globals.activatedDays[selectedDay].goals[index].hasSucceeded = 1;

                        });
                      },
                      child: Icon(
                        Icons.check,
                        color:     globals.activatedDays[selectedDay].goals[index].hasSucceeded == 1 ?    Colors.white : globals.greenColor,
                      ),
                      color: globals.activatedDays[selectedDay].goals[index].hasSucceeded == 1 ?  globals.greenColor : Colors.white,
                      shape: CircleBorder(
                        side: BorderSide(color: globals.greenColor),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                        globals.activatedDays[selectedDay].goals[index].hasSucceeded = 0;

                        });
                      },
                      child: Icon(
                        Icons.clear,
                        color:         globals.activatedDays[selectedDay].goals[index].hasSucceeded == 0 ?    Colors.white : globals.redColor,
                      ),
                      color:  globals.activatedDays[selectedDay].goals[index].hasSucceeded == 0 ?  globals.redColor : Colors.white ,
                      shape: CircleBorder(
                          side: BorderSide(color: globals.redColor)),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }
}
