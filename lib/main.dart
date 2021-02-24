import 'package:dailygoals_app/DataTypes/Day.dart';
import 'package:dailygoals_app/DataTypes/Goal.dart';
import 'package:dailygoals_app/DayCofigurator.dart';
import 'package:dailygoals_app/GoalConfigurator.dart';
import 'package:dailygoals_app/Reflect.dart';
import 'package:dailygoals_app/Utils.dart';
import 'package:dailygoals_app/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

void main() => runApp(
      MaterialApp(
        routes: {
          '/': (context) => HomePage(),
          '/dayConfigurator': (context) => DayConfiguratorPage(),
          '/goalConfigurator': (context) => GoalConfigurator(),
          Reflect.routeName: (context) => Reflect()
        },
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 0, 71, 119),
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

  final ItemScrollController _scrollController = ItemScrollController();
  int _currentDayIndex;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentDayIndex != null)
        _scrollController.jumpTo(index: _currentDayIndex - 3);
    });
    return Scaffold(
      body: ScrollablePositionedList.builder(
        itemScrollController: _scrollController,
        itemCount: 60,
        itemBuilder: (BuildContext context, index) =>
            buildGoalsList(context, previousMonth, index),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: globals.buttonColor,
        label: Text("Reflect"),
        onPressed: (){
          Navigator.pushNamed(context, Reflect.routeName);
        },
      ),
    );
  }

  Widget buildGoalsList(BuildContext context, DateTime dateTime, index) {
    DateTime onClickDate =
        new DateTime(dateTime.year, dateTime.month, (dateTime.day + index));
    if (onClickDate == getCurrentDay()) {
      _currentDayIndex = index;
    }
    String curr = getCurrentDay().toString();
    print("$curr and $onClickDate");

    /// The Whole Card
    return new SizedBox(
      child: Column(
        children: [
          /// The Line At the current day card
          onClickDate == getCurrentDay()
              ? Padding(
                  padding: EdgeInsets.fromLTRB(0, 23, 0, 12),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.grey),
                    height: 1.0,
                    width: 400,
                  ),
                )
              : Container(),

          /// The info text above the card at the beginning of every week
          onClickDate.weekday == 1
              ? Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                  child: Text(() {
                    String infoText = Jiffy(onClickDate).format('MMM d');
                    String infoTextPt2 = (onClickDate.day + 7).toString();
                    return "$infoText - $infoTextPt2";
                  }(), style: TextStyle(color: Colors.grey, fontSize: 13)),
                )
              : Container(),

          /// The row containing the left section of the card and the card itself.
          Row(
            children: [
              /// The left section
              SizedBox(
                width: 60,
                height: 70,
                child: () {
                  if (onClickDate.weekday == 1 ||
                      onClickDate == getCurrentDay()) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Column(
                        children: [
                          /// The info text that marks which day today is
                          onClickDate == getCurrentDay()
                              ? Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    "Today",
                                    style: TextStyle(
                                        color: globals.accentColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                )
                              : Container(),

                          /// The info text at the left section where every week begins
                          onClickDate.weekday == 1
                              ? Text(
                                  "week",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: Colors.grey),
                                )
                              : Container(),

                          /// the circle around the week number if the week is equal to this week
                          onClickDate.weekday == 1
                              ? Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Jiffy(onClickDate).week ==
                                            Jiffy(getCurrentDay()).week
                                        ? globals.accentColor
                                        : Colors.transparent,
                                  ),

                                  /// the week number itself
                                  child: Center(
                                    child: Text(() {
                                      return Jiffy(onClickDate).week.toString();
                                    }(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Jiffy(onClickDate).week ==
                                                    Jiffy(getCurrentDay()).week
                                                ? Colors.white
                                                : Theme.of(context)
                                                    .primaryColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                }(),
              ),

              /// the card itself (at the right)
              Expanded(
                child: Container(
                  ///decorations
                  margin:
                      EdgeInsets.only(left: 5, top: 0, right: 14, bottom: 12),
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

                  /// the list tile with the onclick and the title and subtitle
                  child: ListTile(
                    onTap: () {
                      if (globals.activatedDays[onClickDate] == null) {
                        List<GoalObject> test = new List<GoalObject>();
                        globals.activatedDays.putIfAbsent(onClickDate,
                            () => DayObject("title", "discription", test));
                      }
                      Navigator.pushNamed(
                          context, DayConfiguratorPage.routeName,
                          arguments: onClickDate);
                    },
                    title: Text(
                      () {
                        String date = Jiffy(onClickDate).format("EEEE MMM do");

                        return date;
                      }(),
                      style: TextStyle(
                          fontWeight: onClickDate == getCurrentDay()
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                    subtitle: Text(() {
                      int amountOfGoals =
                          globals.activatedDays[onClickDate] == null
                              ? 0
                              : globals.activatedDays[onClickDate].goals.length;

                      return amountOfGoals == 0
                          ? "You have no goals set for this day"
                          : "You have $amountOfGoals goals set for this day!";
                    }()),
                  ),
                ),
              ),
            ],
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
