import 'package:dailygoals_app/DataTypes/Goal.dart';

class DayObject{
  DayObject(this.title, this.description, this.goals);
  final String title;
  final String description;
  List<GoalObject> goals = new List();
}