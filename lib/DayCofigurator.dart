import 'package:dailygoals_app/DataTypes/Goal.dart';
import 'package:dailygoals_app/Utils.dart';
import 'package:dailygoals_app/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DayConfiguratorPage extends StatefulWidget {
  @override
  _DayConfiguratorPageState createState() => _DayConfiguratorPageState();
}

class _DayConfiguratorPageState extends State<DayConfiguratorPage> {
  TextEditingController dayTitleController = TextEditingController();
  TextEditingController dayDescriptionController = TextEditingController();

  var _goal;
  var selectedDay;

  createGoalConfigDialog(BuildContext context, GoalObject goal, int index,
      bool enableEmptyCheckText, bool isNew) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(
              "goal number 'number'",
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
                      hintText:  'title of your goal',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.0),
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
                      color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0),

                        ),
                       child: Text("Use Description", style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w400),),
                        onPressed: () {
                      goal.hasDescription = true;
                      setState(() {
                        Navigator.of(context).pop();
                        createGoalConfigDialog(context, goal, index, false, isNew);
                      });
                    }),
                  if (goal.hasDescription)
                    TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: dayDescriptionController,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText:  'summary of your goal\n\n'
                            ,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 0.5)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.0),
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
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0,4, 0),
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
                      setState(() {
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
                            globals.activatedDays[getCurrentDay()].goals.add(
                                new GoalObject(dayTitleController.text,
                                    dayDescriptionController.text, goal.hasDescription));
                          } else {
                            globals.activatedDays[getCurrentDay()]
                                    .goals[index] =
                                new GoalObject(dayTitleController.text,
                                    dayDescriptionController.text, goal.hasDescription);
                          }
                        } else {
                          setState(() {
                            Navigator.of(context).pop();
                            createGoalConfigDialog(context, goal, index, true, isNew);
                          });
                        }
                      });
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
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(15, 60.0, 0, 0),
              child: Text(
                "Your goals for today",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: Theme.of(context).textTheme.headline4.fontSize,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount:
                      globals.activatedDays[getCurrentDay()].goals.length,
                  itemBuilder: (BuildContext context, int index) =>
                      buildGoalsList(context, index)),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
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
          createGoalConfigDialog(context, new GoalObject(null, null, false),
              null, false, true);
        },
      ),
    );
  }

  Widget buildGoalsList(BuildContext context, int index) {
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
          //setting the textFields of the input dialogue
          dayDescriptionController.text =
              globals.activatedDays[getCurrentDay()].goals[index].summary;
          dayTitleController.text =
              globals.activatedDays[getCurrentDay()].goals[index].title;

          //opening the dialogue
          createGoalConfigDialog(
              context,
              globals.activatedDays[getCurrentDay()].goals[index],
              index,
              false, false);
        },
        title: Text(globals.activatedDays[getCurrentDay()].goals[index].title),
      ),
    );
  }
}
