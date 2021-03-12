import 'package:shared_preferences/shared_preferences.dart';
import 'package:dailygoals_app/globals.dart' as globals;


class UserPreferences{

  static final UserPreferences _instance  =UserPreferences._ctor();
  factory UserPreferences(){
    return _instance;
  }

  UserPreferences._ctor();

  SharedPreferences _prefs;

  init() async{
    _prefs = await SharedPreferences.getInstance();
  }


  get data{

    return _prefs.getString('data') ?? '';
  }


  set data(String value){
    _prefs.setString('data', value);
  }
}