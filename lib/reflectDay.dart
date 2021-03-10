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
  List<TextEditingController> _reflectionNotesController = [];

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    selectedDay = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Done"),
        onPressed: () {
          Navigator.pushNamed(context, '/');
        },
      ),
    );
  }

  Widget buildGoalsList(BuildContext context, int index, DateTime _selectedDay,
      Animation<double> animation) {
    _reflectionNotesController.add(new TextEditingController());

    if (globals.activatedDays[_selectedDay].goals[index].reflectionNotes !=
        null) {
      _reflectionNotesController[index].text =
          globals.activatedDays[_selectedDay].goals[index].reflectionNotes;
    }

    return new AnimatedContainer(
      curve: Curves.easeInOutCubic,
      duration: Duration(seconds: 1),
      height: getCorrectSize(index),
      margin: EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 12),
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
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Center(
          child: Column(
            children: [
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
                        setState(
                          () {
                            globals.activatedDays[selectedDay].goals[index]
                                .hasSucceeded = 1;
                          },
                        );
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
                      shape: CircleBorder(
                          side: BorderSide(color: globals.redColor)),
                    ),
                  ],
                ),
              ),
              globals.activatedDays[selectedDay].goals[index].hasSucceeded ==
                          1 ||
                      globals.activatedDays[selectedDay].goals[index]
                              .hasSucceeded ==
                          0
                  ? Expanded(child: Padding(

                      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: _reflectionNotesController[index],
                        onChanged: (text) {
                          globals.activatedDays[_selectedDay].goals[index]
                              .reflectionNotes = text;
                        },
                        decoration: InputDecoration(

                          hintText: 'So why did you not reach this goal? \n\n',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 0.5)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),
              )  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  double getCorrectSize(int index) {
    if (globals.activatedDays[selectedDay].goals[index].hasSucceeded == 1 ||
        globals.activatedDays[selectedDay].goals[index].hasSucceeded == 0) {
      return 200;
    } else {
      return 90;
    }
    return null;
  }
}
