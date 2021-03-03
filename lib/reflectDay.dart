import 'package:dailygoals_app/Reflect.dart';
import 'package:dailygoals_app/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class reflectDay extends StatefulWidget {
  static const routeName = "/reflectDayState";

  @override
  _reflectDayState createState() => _reflectDayState();
}

class _reflectDayState extends State<reflectDay> with TickerProviderStateMixin {
  DateTime selectedDay;
  List<double> _tileSize = [];


  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

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
              "So, did you reach these goals?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).primaryColor),
            ),
            globals.activatedDays[selectedDay]?.goals?.length == 0 ||
                    globals.activatedDays[selectedDay] == null
                ? Expanded(
                    child: Center(
                    child: Text(
                      "You have no goals set yet for this day!",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ))
                : Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: AnimatedList(
                          key: _listKey,
                          initialItemCount:
                              globals.activatedDays[selectedDay].goals.length,
                          itemBuilder: (BuildContext context, int index,
                                  Animation<double> animation) =>
                              buildGoalsList(
                                  context, index, selectedDay, animation)),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget buildGoalsList(BuildContext context, int index, DateTime _selectedDay,
      Animation<double> animation) {

    return new AnimatedContainer(        key: UniqueKey(),

        curve: Curves.easeInOutCubic,
        duration: Duration(seconds: 1),
        height: getCorrectSize(index),
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
        child: Center(
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
                      globals.activatedDays[selectedDay].goals[index]
                          .hasSucceeded = 1;

                            });
                    },
                    child: Icon(
                      Icons.check,
                      color: globals.activatedDays[selectedDay].goals[index]
                                  .hasSucceeded ==
                              1
                          ? Colors.white
                          : globals.greenColor,
                    ),
                    color: globals.activatedDays[selectedDay].goals[index]
                                .hasSucceeded ==
                            1
                        ? globals.greenColor
                        : Colors.white,
                    shape: CircleBorder(
                      side: BorderSide(color: globals.greenColor),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        globals.activatedDays[selectedDay].goals[index]
                            .hasSucceeded = 0;
                  
                      });
                    },
                    child: Icon(
                      Icons.clear,
                      color: globals.activatedDays[selectedDay].goals[index]
                                  .hasSucceeded ==
                              0
                          ? Colors.white
                          : globals.redColor,
                    ),
                    color: globals.activatedDays[selectedDay].goals[index]
                                .hasSucceeded ==
                            0
                        ? globals.redColor
                        : Colors.white,
                    shape:
                        CircleBorder(side: BorderSide(color: globals.redColor)),
                  ),
                ],
              ),
            ),
            globals.activatedDays[selectedDay].goals[index].hasSucceeded == 1 ||
                    globals.activatedDays[selectedDay].goals[index]
                            .hasSucceeded ==
                        0
                ? Padding(padding: EdgeInsets.fromLTRB(15, 10, 15, 10), child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: null,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'So why did you not reach this goal? \n\n',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 0.5)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2, color: Theme.of(context).primaryColor),
                ),
              ),
            ))
                : Container(),
          ]),
        ),

    );
  }
  
  double getCorrectSize(int index) {
    if ( globals.activatedDays[selectedDay].goals[index].hasSucceeded == 1 ||
        globals.activatedDays[selectedDay].goals[index]
            .hasSucceeded == 0){
      return 180;
    } else {
      return 70;
    }
    return null;
  }
}
