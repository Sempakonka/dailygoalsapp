import 'dart:ffi';

DateTime getCurrentDay(){
  DateTime now = new DateTime.now();
  DateTime date = new DateTime(now.year, now.month, now.day);
  return date;
}