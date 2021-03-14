import 'dart:convert';

import 'package:dailygoals_app/DataTypes/Goal.dart';
import 'package:dailygoals_app/Utils.dart';
import 'package:dailygoals_app/globals.dart' as globals;
import 'package:dailygoals_app/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class DayConfiguratorPage extends StatefulWidget {
  static const routeName = '/dayConfigurator';

  @override
  _DayConfiguratorPageState createState() => _DayConfiguratorPageState();
}

class _DayConfiguratorPageState extends State<DayConfiguratorPage> {
  TextEditingController dayTitleController = TextEditingController();
  TextEditingController dayDescriptionController = TextEditingController();

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  var ttt = globals.Globals();

  createGoalConfigDialog(BuildContext context, GoalObject goal, int index,
      bool enableEmptyCheckText, bool isNew, _selectedDay) {
    String goalNumber = isNew
        ? (ttt.activatedDays[_selectedDay].goals.length + 1).toString()
        : (ttt.activatedDays[_selectedDay].goals.indexOf(goal) + 1).toString();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(
              "goal number $goalNumber",
              style: Theme.of(context).textTheme.headline5,
            ),
            content: Container(
              width: MediaQuery.of(context).size.width / 1.2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextField(
                    controller: dayTitleController,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'title of your goal',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  if (enableEmptyCheckText && dayTitleController.text.isEmpty)
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red, size: 14),
                          Text("  The title field seems to be empty!",
                              style: TextStyle(color: Colors.red, fontSize: 13))
                        ],
                      ),
                    ),
                  SizedBox(height: 10),
                  if (!goal.hasDescription)
                    FlatButton(
                        color: globals.backgroundButtonBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                        child: Text(
                          "Also use Description",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                        onPressed: () {
                          goal.hasDescription = true;
                          setState(() {
                            Navigator.of(context).pop();
                            createGoalConfigDialog(context, goal, index, false,
                                isNew, _selectedDay);
                          });
                        }),
                  if (goal.hasDescription)
                    TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: dayDescriptionController,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'summary of your goal\n\n',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 0.5)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  if (enableEmptyCheckText &&
                      goal.hasDescription &&
                      dayDescriptionController.text.isEmpty)
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red, size: 14),
                          Text("  The description field seems to be empty!",
                              style: TextStyle(color: Colors.red, fontSize: 13))
                        ],
                      ),
                    ),
                ],
              ),
            ),
            actions: <Widget>[
              !isNew
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: MaterialButton(
                        onPressed: () {
                          ttt.activatedDays[_selectedDay].goals.removeAt(index);
                          _listKey.currentState.removeItem(
                            index,
                            (context, animation) => buildGoalsList(
                                context, index, _selectedDay, animation),
                          );
                          setState(() {
                            Navigator.of(context).pop();
                          });
                          String saveThisJson = jsonEncode(ttt);

                          UserPreferences().data = saveThisJson;
                        },
                        elevation: 5.0,
                        child: Text("delete",
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .fontSize,
                                color: globals.darkRed)),
                      ),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    elevation: 5.0,
                    child: Text("cancel",
                        style: Theme.of(context).textTheme.headline6)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: MaterialButton(
                    onPressed: () {
                      setState(
                        () {
                          //  data = UserPreferences().data;
                          // if user doesn't use a description the textfield will always be valid. If user does, and inputfield is not empty it will also be valid
                          bool isValidDescription;
                          if (!goal.hasDescription ||
                              dayDescriptionController.text.isNotEmpty) {
                            isValidDescription = true;
                          } else {
                            isValidDescription = false;
                          }

                          if (dayTitleController.text.isNotEmpty &&
                              isValidDescription) {
                            Navigator.of(context).pop();

                            if (isNew) {
                              ttt.activatedDays[_selectedDay].goals.add(
                                  new GoalObject(
                                      title: dayTitleController.text,
                                      summary: dayDescriptionController.text,
                                      hasDescription: goal.hasDescription,
                                      hasSucceeded: 2,
                                      reflectionNotes: null));
                              _listKey.currentState?.insertItem(
                                  ttt.activatedDays[_selectedDay].goals.length -
                                      1);
                            } else {
                              ttt.activatedDays[_selectedDay].goals[index] =
                                  new GoalObject(
                                      title: dayTitleController.text,
                                      summary: dayDescriptionController.text,
                                      hasDescription: goal.hasDescription,
                                      hasSucceeded: 2,
                                      reflectionNotes: null);
                            }
                          } else {
                            setState(() {
                              Navigator.of(context).pop();
                              createGoalConfigDialog(context, goal, index, true,
                                  isNew, _selectedDay);
                            });
                          }
                        },
                      );
                      String saveThisJson = jsonEncode(ttt);

                      UserPreferences().data = saveThisJson;
                    },
                    elevation: 5.0,
                    child: Text("submit",
                        style: Theme.of(context).textTheme.headline6)),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime _selectedDay = ModalRoute.of(context).settings.arguments;
    final String _selectedDayReadable = Jiffy(_selectedDay).format("MMM do");

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(15, 5.0, 0, 15),
              child: Text(
                _selectedDay == getCurrentDay()
                    ? "Your goals for today"
                    : "Your goals for $_selectedDayReadable",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            ttt.activatedDays[_selectedDay].goals.length == 0
                ? Expanded(
                    child: Center(
                    child: Text(
                      "You have no goals set yet for this day!",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ))
                : Expanded(
                    child: AnimatedList(
                        key: _listKey,
                        initialItemCount:
                            ttt.activatedDays[_selectedDay].goals.length,
                        itemBuilder: (BuildContext context, int index,
                                Animation<double> animation) =>
                            buildGoalsList(
                                context, index, _selectedDay, animation)),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: globals.backgroundButtonBlue,
        label: Text(
          "Add a goal",
          style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.headline6.fontSize),
        ),
        onPressed: () {
          //clearing the text in the dialogue
          dayDescriptionController.clear();
          dayTitleController.clear();
          //opening the dialogue to add a new goal.
          createGoalConfigDialog(
              context,
              new GoalObject(
                  title: null,
                  summary: null,
                  hasDescription: false,
                  hasSucceeded: 2,
                  reflectionNotes: null),
              null,
              false,
              true,
              _selectedDay);
        },
      ),
    );
  }

  Widget buildGoalsList(BuildContext context, int index, DateTime _selectedDay,
      Animation<double> animation) {
    print(index);
    return new SizeTransition(
      sizeFactor: animation,
      child: Container(
        key: ValueKey<int>(index),
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
            //setting the textFields of the input dialogue
            dayDescriptionController.text =
                ttt.activatedDays[_selectedDay].goals[index].summary;
            dayTitleController.text =
                ttt.activatedDays[_selectedDay].goals[index].title;

            //opening the dialogue
            createGoalConfigDialog(
                context,
                ttt.activatedDays[_selectedDay].goals[index],
                index,
                false,
                false,
                _selectedDay);
          },
          title: Text(ttt.activatedDays[_selectedDay]?.goals[index]?.title),
        ),
      ),
    );
  }
}
