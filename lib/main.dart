import 'package:dailygoals_app/DataTypes/Day.dart';
import 'package:dailygoals_app/DataTypes/Goal.dart';
import 'package:dailygoals_app/DayCofigurator.dart';
import 'package:dailygoals_app/GoalConfigurator.dart';
import 'package:dailygoals_app/Utils.dart';
import 'package:dailygoals_app/globals.dart' as globals;
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        routes: {
          '/': (context) => HomePage(),
          '/dayConfigurator': (context) => DayConfiguratorPage(),
          '/goalConfigurator': (context) => GoalConfigurator()
        },
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 0, 39, 57),
        ),
      ),
    );

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Container(
      child: Center(
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            activeCurrentDay();
            Navigator.pushNamed(context, '/dayConfigurator');
          },
        ),
      ),
    ));
  }

  void activeCurrentDay() {
    List<GoalObject> test = new List<GoalObject>();
    globals.activatedDays.putIfAbsent(
        getCurrentDay(), () => DayObject("title", "discription", test));
    print(getCurrentDay());
  }
}
