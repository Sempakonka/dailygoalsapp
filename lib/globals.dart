import 'dart:convert';

import 'package:dailygoals_app/DataTypes/Day.dart';
import 'package:dailygoals_app/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class Globals {
  static final Globals _instance = Globals._internal();

  fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> activatedDaysFromJsonString =
        jsonDecode(json['activatedDays']);

    Map<DateTime, DayObject> activatedDaysFromJsonMap =
        Map.from(activatedDaysFromJsonString).map((key, value) =>
            MapEntry<DateTime, DayObject>(DateTime.parse(key), () {

          return   DayObject.fromJson(value);

            }()));

    _instance.activatedDays = activatedDaysFromJsonMap;
    return _instance;
  }

  factory Globals() {
    return _instance;
  }

  Globals._internal();

  Map<DateTime, DayObject> activatedDays = new Map();

  Map<String, DayObject> toJsonSerializableObject(
      Map<DateTime, DayObject> _activatedDays) {
    final jsonSerializableObject = new Map<String, DayObject>();
    _activatedDays.forEach((key, value) {
      jsonSerializableObject.putIfAbsent(key.toString(), () => value);
    });
    return jsonSerializableObject;
  }

  Map<String, dynamic> toJson() =>
      {'activatedDays': jsonEncode(toJsonSerializableObject(activatedDays))};
}

Color greenColor = new Color.fromARGB(255, 8, 217, 102);
Color redColor = new Color.fromARGB(255, 240, 100, 73);
Color buttonColor = new Color.fromARGB(255, 0, 180, 216);
