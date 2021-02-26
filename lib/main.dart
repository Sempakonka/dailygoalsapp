import 'package:dailygoals_app/DataTypes/Day.dart';
import 'package:dailygoals_app/DataTypes/Goal.dart';
import 'package:dailygoals_app/DayCofigurator.dart';
import 'package:dailygoals_app/Reflect.dart';
import 'package:dailygoals_app/Utils.dart';
import 'package:dailygoals_app/globals.dart' as globals;
import 'package:dailygoals_app/reflectDay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:jiffy/jiffy.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

void main() => runApp(
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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isChoosingDayToReflect = false;
  bool isStartup = true;
  String currentDay = getCurrentDay().weekday.toString();
  DateTime previousMonth = new DateTime(
      getCurrentDay().year - 3, getCurrentDay().month, getCurrentDay().day);
  bool showDown = false, showUp = false;
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _positionListener =
      ItemPositionsListener.create();

  int currentDayIndex;

  int _calculateCurrentDayIndex(DateTime beginDate) {
    int index = 0;
    bool escape = false;
    DateTime curr = getCurrentDay();
    DateTime beginDateCopy = beginDate;
    while (!escape) {
      index++;
      beginDate = new DateTime(
          beginDateCopy.year, beginDateCopy.month, (beginDateCopy.day + index));

      if (beginDate == curr) {
        escape = true;
      }
      //   print(index);
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
                  currentDayIndex - 10) &&

              ///zolang de currentscroll niet boven het maximum zit
              !(_positionListener.itemPositions.value.first.index >
                  currentDayIndex + 10) &&

              ///to prevent infinite callback loop
              showUp ||
          showDown) {
        if (!(_positionListener.itemPositions.value.first.index >
                currentDayIndex + 10) &&
            !(_positionListener.itemPositions.value.first.index <
                currentDayIndex - 10)) {
          setState(() {
            showUp = false;
            showDown = false;
          });
        }
      } else if (!(_positionListener.itemPositions.value.first.index <
              currentDayIndex - 11) &&
          _positionListener.itemPositions.value.first.index >
              currentDayIndex + 11 &&

          ///to prevent infinite callback loop
          !showUp) {
        setState(() {
          showDown = false;
          showUp = true;
        });
      } else if (_positionListener.itemPositions.value.first.index <
              currentDayIndex - 11 &&
          !(_positionListener.itemPositions.value.first.index >
                  currentDayIndex + 11 &&
              !showDown)) {
        setState(() {
          showDown = true;
          showUp = false;
        });
      }
    });
//    print("$showUp $showDown");

    currentDayIndex = _calculateCurrentDayIndex(previousMonth);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (isStartup) {
        isStartup = false;
        _scrollController.jumpTo(index: currentDayIndex);
      }
    });
    if (isChoosingDayToReflect == null){
      isChoosingDayToReflect = false;
    }
    return Scaffold(
      appBar:  isChoosingDayToReflect ? AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(),
        centerTitle: true,
        title:

          Text("Select a day", style: TextStyle(color: Theme.of(context).primaryColor), textAlign: TextAlign.center,),

      ) : null,
      body: ScrollablePositionedList.builder(
        itemPositionsListener: _positionListener,
        itemScrollController: _scrollController,
        itemBuilder: (BuildContext context, index) =>
            buildGoalsList(context, previousMonth, index),
        itemCount: 4000,
      ),
      floatingActionButton: Stack(
        alignment: AlignmentDirectional.center,
        children: [
       !isChoosingDayToReflect ?   Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              heroTag: "btn1",
              backgroundColor: globals.buttonColor,
              label: Text("Reflect"),
              onPressed: () {
                Navigator.pushNamed(context, Reflect.routeName);
              },
            ),
          ) : Container(),
          showDown
              ? Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Container(
                      height: 75,
                      width: 150,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(25, 35, 0, 10),
                        child: FloatingActionButton.extended(
                          heroTag: "btn2",
                          label: Text("current day",
                              style: TextStyle(
                                color: globals.buttonColor,
                              )),
                          backgroundColor: Colors.white,
                          icon: Container(
                            height: 25,
                            width: 12,
                            child: Icon(
                              Icons.arrow_drop_down_rounded,
                              color: globals.buttonColor,
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
                  child: Container(
                      height: 75,
                      width: 150,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(25, 45, 0, 0),
                        child: FloatingActionButton.extended(
                          heroTag: "btn3",
                          label: Text("current day",
                              style: TextStyle(
                                color: globals.buttonColor,
                              )),
                          backgroundColor: Colors.white,
                          icon: Container(
                            height: 25,
                            width: 12,
                            child: Icon(
                              Icons.arrow_drop_up_rounded,
                              color: globals.buttonColor,
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
        ],
      ),
    );
  }

  Widget buildGoalsList(BuildContext context, DateTime dateTime, index) {
    DateTime onClickDate =
        new DateTime(dateTime.year, dateTime.month, (dateTime.day + index));
    String curr = getCurrentDay().toString();

    if (index > currentDayIndex + 30 || index < currentDayIndex - 30) {
      //  print("button  and $index");
    } else {
      //    print("not button and  $index");
    }

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
                                        color: globals.greenColor,
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
                                        ? globals.greenColor
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
                      if (isChoosingDayToReflect) {
                        Navigator.pushNamed(
                            context, reflectDay.routeName,
                            arguments: onClickDate);
                      } else {
                        if (globals.activatedDays[onClickDate] == null) {
                          List<GoalObject> test = new List<GoalObject>();
                          globals.activatedDays.putIfAbsent(onClickDate,
                              () => DayObject("title", "discription", test));
                        }
                        Navigator.pushNamed(
                            context, DayConfiguratorPage.routeName,
                            arguments: onClickDate);
                      }
                    },
                    title: Text(
                      () {
                        String date =
                            Jiffy(onClickDate).format("EEEE MMM do $index");

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
