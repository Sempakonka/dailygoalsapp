import 'package:dailygoals_app/DataTypes/Day.dart';
import 'package:dailygoals_app/DataTypes/Goal.dart';
import 'package:dailygoals_app/DayCofigurator.dart';
import 'package:dailygoals_app/GoalConfigurator.dart';
import 'package:dailygoals_app/Utils.dart';
import 'package:dailygoals_app/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

void main() => runApp(
      MaterialApp(
        routes: {
          '/': (context) => HomePage(),
          '/dayConfigurator': (context) => DayConfiguratorPage(),
          '/goalConfigurator': (context) => GoalConfigurator()
        },
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 12, 21, 29),
        ),
      ),
    );

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentDay = getCurrentDay().weekday.toString();
  DateTime previousMonth = new DateTime(
      getCurrentDay().year, getCurrentDay().month - 1, getCurrentDay().day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 60,
          itemBuilder: (BuildContext context, index) =>
              buildGoalsList(context, previousMonth, index)),
    );
  }

  Widget buildGoalsList(BuildContext context, DateTime dateTime, index) {
    DateTime onClickDate =
        new DateTime(dateTime.year, dateTime.month, (dateTime.day + index));

    return new SizedBox(
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 70,
            child: () {
              if (onClickDate.weekday == 1) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Column(
                    children: [
                      Text(
                        "week",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Jiffy(onClickDate).week ==
                                  Jiffy(getCurrentDay()).week
                              ? Colors.greenAccent
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            () {
                              return Jiffy(onClickDate).week.toString();
                            }(),
                            textAlign: TextAlign.center,
                            style: Jiffy(onClickDate).week ==
                                    Jiffy(getCurrentDay()).week
                                ? TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)
                                : TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }(),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5, top: 0, right: 14, bottom: 12),
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
                  if (globals.activatedDays[onClickDate] == null) {
                    List<GoalObject> test = new List<GoalObject>();
                    globals.activatedDays.putIfAbsent(onClickDate,
                        () => DayObject("title", "discription", test));
                  }
                  Navigator.pushNamed(context, DayConfiguratorPage.routeName,
                      arguments: onClickDate);
                },
                title: Text(() {
                  return Jiffy(onClickDate).format("EEEE MMM do");
                }()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void activeCurrentDay() {
    List<GoalObject> test = new List<GoalObject>();
    globals.activatedDays.putIfAbsent(
        getCurrentDay(), () => DayObject("title", "discription", test));
    print(getCurrentDay());
  }
}
