import 'package:flutter/material.dart';
import 'package:implementation_intentions/models/goal.dart';

List<Goal> goalList = [
  new Goal(
      id: 0,
      goal: "My Goal Number one",
      deadline: DateTime.now(),
      progress: 80),
  new Goal(
      id: 1,
      goal: "This is the second goal",
      deadline: DateTime.now(),
      progress: 20),
  new Goal(
      id: 2, goal: "Goal number three", deadline: DateTime.now(), progress: 40),
  new Goal(id: 3, goal: "Goal four", deadline: DateTime.now(), progress: 60),
  new Goal(
      id: 4,
      goal: "My Goal Number one",
      deadline: DateTime.now(),
      progress: 80),
  new Goal(
      id: 5,
      goal: "My Goal Number one",
      deadline: DateTime.now(),
      progress: 80),
  new Goal(
      id: 6,
      goal: "My Goal Number one",
      deadline: DateTime.now(),
      progress: 80),
  new Goal(
      id: 7,
      goal: "My Goal Number one",
      deadline: DateTime.now(),
      progress: 80),
];

class ReflectScreen extends StatefulWidget {
  @override
  _ReflectScreenState createState() => _ReflectScreenState();
}

class _ReflectScreenState extends State<ReflectScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Reflect!!!!"));
  }
}

class ProgressBarListItem extends StatefulWidget {
  @override
  _ProgressBarListItemState createState() => _ProgressBarListItemState();
}

class _ProgressBarListItemState extends State<ProgressBarListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Reflect!!!!"));
  }
}
