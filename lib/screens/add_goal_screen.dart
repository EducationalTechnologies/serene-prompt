import 'package:flutter/material.dart';

class AddGoalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neues Ziel'),
        actions: <Widget>[
          FlatButton.icon(
              textColor: Colors.white,
              icon: const Icon(Icons.save),
              label: Text("Speichern"),
              onPressed: () {
                //TODO: SAve
              }),
        ],
      ),
      body: Container(
        child: Column(children: <Widget>[
          
        ],),
      ),
    );
  }
}
