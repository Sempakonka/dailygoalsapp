import 'dart:convert';

import 'package:dailygoals_app/DataTypes/Day.dart';
import 'package:dailygoals_app/DataTypes/Goal.dart';
import 'package:dailygoals_app/DayCofigurator.dart';
import 'package:dailygoals_app/Reflect.dart';
import 'package:dailygoals_app/Utils.dart';
import 'package:dailygoals_app/globals.dart' as globals;
import 'package:dailygoals_app/reflectDay.dart';
import 'package:dailygoals_app/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jiffy/jiffy.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tuple/tuple.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await UserPreferences().init();

  runApp(
    MaterialApp(
      routes: {
        '/': (context) => HomePage(),
        '/dayConfigurator': (context) => DayConfiguratorPage(),
        //  '/goalConfigurator': (context) => GoalConfigurator(),
        Reflect.routeName: (context) => Reflect(),
        reflectDay.routeName: (context) => reflectDay()
      },
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 72, 86, 150),
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var ttt = globals.Globals();
  bool isChoosingDayToReflect = false;
  bool isStartup = true;
  String currentDay = getCurrentDay().weekday.toString();
  DateTime previousMonth = new DateTime(
      getCurrentDay().year - 3, getCurrentDay().month, getCurrentDay().day);
  bool showDown = false, showUp = false;
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _positionListener =
      ItemPositionsListener.create();

  String data;

  void initState() {
    ///We get the string containing Json
    data = UserPreferences().data;

    Map activatedDaysMap = jsonDecode(data);
    ttt = ttt.fromJson(activatedDaysMap);
    super.initState();
  }

  int currentDayIndex;

  int _calculateCurrentDayIndex(DateTime beginDate) {
    int index = 0;
    bool escape = false;
    DateTime curr = getCurrentDay();
    curr = curr.subtract(Duration(days: curr.weekday - 1));
    DateTime beginDateCopy = beginDate;
    while (!escape) {
      index++;
      beginDate = new DateTime(
          beginDateCopy.year, beginDateCopy.month, (beginDateCopy.day + index));

      if (beginDate == curr) {
        escape = true;
      }
      if (index > 4000) {
        escape = true;
      }
    }

    return index;
  }

  @override
  Widget build(BuildContext context) {
    isChoosingDayToReflect = ModalRoute.of(context).settings.arguments;
    _positionListener.itemPositions.addListener(() {
      /// currentday + en - markeert de bovengrens en ondergrens
      if (!(_positionListener.itemPositions.value.first.index <
                  currentDayIndex - 5) &&

              ///zolang de currentscroll niet boven het maximum zit
              !(_positionListener.itemPositions.value.first.index >
                  currentDayIndex + 10) &&

              ///to prevent infinite callback loop
              showUp ||
          showDown) {
        if (!(_positionListener.itemPositions.value.first.index >
                currentDayIndex + 10) &&
            !(_positionListener.itemPositions.value.first.index <
                currentDayIndex - 5)) {
          setState(() {
            showUp = false;
            showDown = false;
          });
        }
      } else if (!(_positionListener.itemPositions.value.first.index <
              currentDayIndex - 5) &&
          _positionListener.itemPositions.value.first.index >
              currentDayIndex + 11 &&

          ///to prevent infinite callback loop
          !showUp) {
        setState(() {
          showDown = false;
          showUp = true;
        });
      } else if (_positionListener.itemPositions.value.first.index <
              currentDayIndex - 5 &&
          !(_positionListener.itemPositions.value.first.index >
                  currentDayIndex + 11 &&
              !showDown)) {
        setState(() {
          showDown = true;
          showUp = false;
        });
      }
    });

    currentDayIndex = _calculateCurrentDayIndex(previousMonth);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (isStartup) {
        isStartup = false;
        _scrollController.jumpTo(index: currentDayIndex);
      }
    });
    if (isChoosingDayToReflect == null) {
      isChoosingDayToReflect = false;
    }
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("Assets/background.png"), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: isChoosingDayToReflect
              ? AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: Container(),
                  centerTitle: true,
                  title: Text(
                    "Select a day",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )
              : AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  title: Text(
                    "Goals Buddy",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                  ///TODO: implement about button
                  /*      leading:
                     TextButton(
                      child: Icon(
                        Icons.,
                        color: Colors.white,
                        size: 26,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      style: ButtonStyle(

                        shape: MaterialStateProperty.resolveWith(
                            (states) => RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )),
                      ),
                    ),*/
                ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 35),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 13,
                        spreadRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  width: 340,
                  height: 70,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ttt.activatedDays[getCurrentDay()] == null ||
                                ttt.activatedDays[getCurrentDay()].goals
                                        .length ==
                                    0
                            ? Text("You have not set any goals today!",
                                style: TextStyle(fontSize: 13))
                            : Text(
                                "You have set ${ttt.activatedDays[getCurrentDay()].goals.length} goals today!",
                                style: TextStyle(fontSize: 13)),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, DayConfiguratorPage.routeName,
                                arguments: getCurrentDay());
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => globals.darkRed),
                            shape: MaterialStateProperty.resolveWith(
                                (states) => RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    )),
                          ),
                          child:
                          ttt.activatedDays[getCurrentDay()] == null ||
                              ttt.activatedDays[getCurrentDay()].goals
                                  .length ==
                                  0
                              ?

                          Text(
                            "Set Goals",
                            style: TextStyle(color: Colors.white),
                          ) :  Text(
                            "See Them",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ]),
                ),
              ),
              Expanded(
                child: ScrollablePositionedList.builder(
                  itemPositionsListener: _positionListener,
                  itemScrollController: _scrollController,
                  itemBuilder: (BuildContext context, index) =>
                      buildGoalsList(context, previousMonth, index),
                  itemCount: 4000,
                ),
              )
            ],
          ),
          floatingActionButton: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              !isChoosingDayToReflect
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton.extended(
                        heroTag: "btn1",
                        backgroundColor: globals.backgroundButtonBlue,
                        label: Text("Reflect"),
                        onPressed: () {
                          Navigator.pushNamed(context, Reflect.routeName);
                        },
                      ),
                    )
                  : Container(),
              showDown
                  ? Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Container(
                          height: 84,
                          width: 150,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(25, 35, 0, 10),
                            child: FloatingActionButton.extended(
                              heroTag: "btn2",
                              label: Text("current day",
                                  style: TextStyle(
                                    color: globals.darkBlue,
                                  )),
                              backgroundColor: Colors.white,
                              icon: Container(
                                height: 25,
                                width: 12,
                                child: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: globals.darkBlue,
                                  size: 28,
                                ),
                              ),
                              onPressed: () {
                                _scrollController.scrollTo(
                                    index: currentDayIndex,
                                    duration: Duration(milliseconds: 1000),
                                    curve: Curves.easeInOutCubic);
                              },
                            ),
                          )),
                    )
                  : Container(),
              showUp
                  ? Align(
                      alignment: AlignmentDirectional.topStart,
                      child:Padding(
                        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Container(
                          height: 83,
                          width: 150,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(25, 45, 0, 0),
                            child: FloatingActionButton.extended(
                              heroTag: "btn3",
                              label: Text("current day",
                                  style: TextStyle(
                                    color: globals.darkBlue,
                                  )),
                              backgroundColor: Colors.white,
                              icon: Container(
                                height: 25,
                                width: 12,
                                child: Icon(
                                  Icons.arrow_drop_up_rounded,
                                  color: globals.darkBlue,
                                  size: 28,
                                ),
                              ),
                              onPressed: () {
                                _scrollController.scrollTo(
                                    index: currentDayIndex,
                                    duration: Duration(milliseconds: 1000),
                                    curve: Curves.easeInOutCubic);
                              },
                            ),
                          )),
                    ))
                  : Container(),
            ],
          ),
        ));
  }

  Widget buildGoalsList(BuildContext context, DateTime dateTime, index) {
    DateTime onClickDate =
        new DateTime(dateTime.year, dateTime.month, (dateTime.day + index));

    Tuple2<int, int> goalsReflectedOn = checkForReflectedGoals(onClickDate);

    /// The Whole item
    return new SizedBox(
      child: Column(
        children: [
          /// The Line At the current day card
          onClickDate == getCurrentDay()
              ? Padding(
                  padding: EdgeInsets.fromLTRB(30, 23, 30, 12),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: globals.darkBlue),
                    height: 1.0,
                    width: double.infinity,
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

          SizedBox(
            height: goalsReflectedOn == null ||
                    (goalsReflectedOn.item1 == 0 && goalsReflectedOn.item2 == 0)
                ? 80
                : 105,
            child: Row(
              children: [
                /// The row containing the left section of the card and the card itself.

                /// The left section
                Expanded(
                  flex: 1,
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
                                          color: globals.green,
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
                                          ? globals.green
                                          : Colors.transparent,
                                    ),

                                    /// the week number itself
                                    child: Center(
                                      child: Text(() {
                                        return Jiffy(onClickDate)
                                            .week
                                            .toString();
                                      }(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Jiffy(onClickDate).week ==
                                                      Jiffy(getCurrentDay())
                                                          .week
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
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 15, 12),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.14),
                            blurRadius: 7,
                            spreadRadius: 6,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: RaisedButton(
                        ///decorations
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,

                        /// the list tile with the onclick and the title and subtitle
                        onPressed: () {
                          if (isChoosingDayToReflect) {
                            Navigator.pushNamed(context, reflectDay.routeName,
                                arguments: onClickDate);
                          } else {
                            if (ttt.activatedDays[onClickDate] == null) {
                              List<GoalObject> test = new List<GoalObject>();
                              ttt.activatedDays.putIfAbsent(
                                  onClickDate,
                                  () => DayObject(
                                      title: "titleeeeeeeeeeeeee",
                                      description: "discription",
                                      goals: test));
                            }

                            String saveThisJson = jsonEncode(ttt);

                            UserPreferences().data = saveThisJson;

                            setState(() {
                              data = UserPreferences().data;
                            });
                            Navigator.pushNamed(
                                context, DayConfiguratorPage.routeName,
                                arguments: onClickDate);
                          }
                        },

                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                () {
                                  String date =
                                      Jiffy(onClickDate).format("EEEE MMM do");

                                  return date;
                                }(),
                                style: TextStyle(
                                    fontWeight: onClickDate == getCurrentDay()
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: globals.darkBlue),
                                textAlign: TextAlign.start,
                              ),
                              goalsReflectedOn == null ||
                                      (goalsReflectedOn.item1 == 0 &&
                                          goalsReflectedOn.item2 == 0)
                                  ? Text(
                                      () {
                                        int amountOfGoals =
                                            ttt.activatedDays[onClickDate] ==
                                                    null
                                                ? 0
                                                : ttt.activatedDays[onClickDate]
                                                    .goals.length;

                                        return amountOfGoals == 0
                                            ? "You have no goals set for this day"
                                            : "You have $amountOfGoals goals set for this day";
                                      }(),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: globals.grey,
                                          fontWeight: FontWeight.normal),
                                    )
                                  : Container(),
                              goalsReflectedOn == null ||
                                      (goalsReflectedOn.item1 == 0 &&
                                          goalsReflectedOn.item2 == 0)
                                  ? Container()
                                  : Text(
                                      "You have reached ${goalsReflectedOn.item2} of you own goals ",
                                      style: TextStyle(color: globals.green),
                                    ),
                              goalsReflectedOn == null ||
                                      (goalsReflectedOn.item1 == 0 &&
                                          goalsReflectedOn.item2 == 0)
                                  ? Container()
                                  : Text(
                                      "${goalsReflectedOn.item1} goals you didn't.",
                                      style: TextStyle(color: globals.darkRed),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Tuple2<int, int> checkForReflectedGoals(DateTime dateTime) {
    if (ttt.activatedDays[dateTime]?.goals == null) {
      return null;
    } else {
      Tuple2<int, int> reachedTuple = new Tuple2<int, int>(0, 0);
      ttt.activatedDays[dateTime]?.goals?.forEach(
        (element) {
          if (element.hasSucceeded == 0) {
            reachedTuple = new Tuple2<int, int>(
                reachedTuple.item1 + 1, reachedTuple.item2);
          } else if (element.hasSucceeded == 1) {
            reachedTuple = new Tuple2<int, int>(
                reachedTuple.item1, reachedTuple.item2 + 1);
          }
        },
      );
      return reachedTuple;
    }
  }

  void activeCurrentDay() {
    List<GoalObject> test = new List<GoalObject>();
    ttt.activatedDays.putIfAbsent(
        getCurrentDay(),
        () => DayObject(
            title: "titleeeeeeeeeeeeee",
            description: "discription",
            goals: test));
  }

  void setData() {}
}
