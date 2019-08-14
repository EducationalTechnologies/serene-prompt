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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: new InputDecoration.collapsed(
                    hintText: "Neues Ziel", fillColor: Colors.tealAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
