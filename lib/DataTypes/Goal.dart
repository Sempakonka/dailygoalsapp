import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

class GoalObject{
  GoalObject({this.title, this.summary, this.hasDescription, this.hasSucceeded, this.reflectionNotes});
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'summary')
  String summary;
  @JsonKey(name: 'hasDescription')
  bool hasDescription = false;
  @JsonKey(name: 'hasSucceeded')
  int hasSucceeded = 2;
  @JsonKey(name: 'reflectionNotes')
  String reflectionNotes;

  factory GoalObject.fromJson(Map<String, dynamic> parsedJson){
    return new GoalObject(title: parsedJson['title'], summary: parsedJson['summary'], hasDescription: parsedJson['hasDescription'], hasSucceeded: parsedJson['hasSucceeded'], reflectionNotes: parsedJson['reflectionNotes']);

  }


  Map toJson() => {
    'title' : title,
    'summary' : summary,
    'hasDescription' : hasDescription,
    'hasSucceeded' : hasSucceeded,
    'reflectionNotes' : reflectionNotes
  };
}