import 'package:dailygoals_app/DataTypes/Goal.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DayObject {
  DayObject({this.title, this.description, this.goals});

  final String title;
  final String description;
  final List<GoalObject> goals;

  factory DayObject.fromJson(Map<String, dynamic> json) {
    var goalsFromJson = json['goals'];
    List<GoalObject> goalsList = goalsFromJson.cast<GoalObject>();
    return new DayObject(
        title: json['title'],
        description: json['description'],
        goals: goalsList);
  }

  Map<String, dynamic> toJson() =>
      {'title': title, 'description': description, 'goals': goals};
}
