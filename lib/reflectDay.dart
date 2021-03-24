import 'dart:convert';

import 'package:dailygoals_app/globals.dart' as globals;
import 'package:dailygoals_app/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class reflectDay extends StatefulWidget {
  static const routeName = "/reflectDayState";

  @override
  _reflectDayState createState() => _reflectDayState();
}

class _reflectDayState extends State<reflectDay> with TickerProviderStateMixin {
  DateTime selectedDay;
  List<TextEditingController> _reflectionNotesController = [];
  var ttt = globals.Globals();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    selectedDay = ModalRoute.of(context).settings.arguments;
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("Assets/background.png"), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //Center Column contents vertically,
                crossAxisAlignment: CrossAxisAlignment.center,
                //Center Column contents horizontally,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      () {
                        String theReflectingDay =
                            Jiffy(selectedDay).format("EEEE MMM do ");
                        return "You're reflecting on $theReflectingDay";
                      }(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "So, did you reach these goals?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  ttt.activatedDays[selectedDay]?.goals?.length == 0 ||
                          ttt.activatedDays[selectedDay] == null
                      ? Expanded(
                          child: Center(
                          child: Text(
                            "You have no goals set yet for this day!",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ))
                      : Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: AnimatedList(
                                key: _listKey,
                                initialItemCount:
                                    ttt.activatedDays[selectedDay].goals.length,
                                itemBuilder: (BuildContext context, int index,
                                        Animation<double> animation) =>
                                    buildGoalsList(context, index, selectedDay,
                                        animation)),
                          ),
                        )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: Text("Done"),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            backgroundColor: globals.backgroundButtonBlue,
          ),
        ));
  }

  Widget buildGoalsList(BuildContext context, int index, DateTime _selectedDay,
      Animation<double> animation) {
    _reflectionNotesController.add(new TextEditingController());

    if (ttt.activatedDays[_selectedDay].goals[index].reflectionNotes != null) {
      _reflectionNotesController[index].text =
          ttt.activatedDays[_selectedDay].goals[index].reflectionNotes;
    }

    return new AnimatedContainer(
      curve: Curves.easeInOutCubic,
      duration: Duration(seconds: 1),
      height: getCorrectSize(index),
      margin: EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 12),
      decoration: BoxDecoration(
        color: getCorrectBackgroundColor(index),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.14),
            blurRadius: 7,
            spreadRadius: 6,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Center(
          child: Column(
            children: [
              Text(
                ttt.activatedDays[_selectedDay].goals[index].title,
                style: TextStyle(
                    fontSize: 18,
                    color: globals.darkBlue,
                    fontWeight: FontWeight.bold),
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
                        setState(
                          () {
                            ttt.activatedDays[selectedDay].goals[index]
                                .hasSucceeded = 1;
                          },
                        );
                        String saveThisJson = jsonEncode(ttt);

                        UserPreferences().data = saveThisJson;
                      },
                      child: Icon(
                        Icons.check,
                        color: ttt.activatedDays[selectedDay].goals[index]
                                    .hasSucceeded ==
                                1
                            ? Colors.white
                            : globals.backgroundButtonBlue,
                      ),
                      color: ttt.activatedDays[selectedDay].goals[index]
                                  .hasSucceeded ==
                              1
                          ? globals.backgroundButtonBlue
                          : Colors.white,
                      shape: CircleBorder(
                        side: BorderSide(color: globals.backgroundButtonBlue),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                          ttt.activatedDays[selectedDay].goals[index]
                              .hasSucceeded = 0;
                        });

                        String saveThisJson = jsonEncode(ttt);

                        UserPreferences().data = saveThisJson;
                      },
                      child: Icon(
                        Icons.clear,
                        color: ttt.activatedDays[selectedDay].goals[index]
                                    .hasSucceeded ==
                                0
                            ? Colors.white
                            : globals.darkRed,
                      ),
                      color: ttt.activatedDays[selectedDay].goals[index]
                                  .hasSucceeded ==
                              0
                          ? globals.darkRed
                          : Colors.white,
                      shape: CircleBorder(
                          side: BorderSide(color: globals.darkRed)),
                    ),
                  ],
                ),
              ),
              ttt.activatedDays[selectedDay].goals[index].hasSucceeded == 1 ||
                      ttt.activatedDays[selectedDay].goals[index]
                              .hasSucceeded ==
                          0
                  ? Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: _reflectionNotesController[index],
                          onChanged: (text) {
                            ttt.activatedDays[_selectedDay].goals[index]
                                .reflectionNotes = text;

                            String saveThisJson = jsonEncode(ttt);

                            UserPreferences().data = saveThisJson;
                          },
                          decoration: InputDecoration(
                            hintText: ttt.activatedDays[selectedDay]
                                        .goals[index].hasSucceeded ==
                                    0
                                ? 'So why did you not reach this goal? \n\n'
                                : 'Are there any lessons learned while \nachieving this goal? \n',
                            enabledBorder: ttt.activatedDays[selectedDay]
                                        .goals[index].hasSucceeded ==
                                    0
                                ? OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0.5, color: globals.darkRed))
                                : OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0.5, color: globals.darkBlue)),
                            focusedBorder: ttt.activatedDays[selectedDay]
                                        .goals[index].hasSucceeded ==
                                    0
                                ? OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3.2, color: globals.darkRed),
                                  )
                                : OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3.2, color: globals.darkBlue)),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  double getCorrectSize(int index) {
    if (ttt.activatedDays[selectedDay].goals[index].hasSucceeded == 1 ||
        ttt.activatedDays[selectedDay].goals[index].hasSucceeded == 0) {
      return 200;
    } else {
      return 90;
    }
    return null;
  }

  Color getCorrectBackgroundColor(int index) {
    if (ttt.activatedDays[selectedDay].goals[index].hasSucceeded == 1) {
      return globals.lightBlue;
    } else if (ttt.activatedDays[selectedDay].goals[index].hasSucceeded == 0) {
      return globals.lightRed;
    } else {
      return Colors.white;
    }
  }
}
