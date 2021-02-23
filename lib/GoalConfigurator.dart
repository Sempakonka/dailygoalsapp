import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GoalConfigurator extends StatefulWidget {
  @override
  _GoalConfiguratorState createState() => _GoalConfiguratorState();
}

class _GoalConfiguratorState extends State<GoalConfigurator> {
  var _title;

  final titleController = new TextEditingController();


  createGoalConfigDialog(BuildContext context){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("test"),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Container(
              child: IconButton(
                  icon: Icon(Icons.arrow_back_outlined),
                  //            color: Colors.black,
                  iconSize: 40,
                  onPressed: () {
                    Navigator.pushNamed(context, '/dayConfigurator');
                  }))),
      body: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "What is this goal Going to be?",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: "Title"),
                  ),
                  RaisedButton(onPressed: (){
                    setState(() {
                      _title = titleController.text;
                    });
                  }),
                  Text("your goal is $_title"),
                ]),
          ),
        ),
      ),
    );
  }
}
