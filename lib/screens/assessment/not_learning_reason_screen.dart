import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/viewmodels/daily_learning_question_view_model.dart';

class NotLearningReasonScreen extends StatefulWidget {
  NotLearningReasonScreen({Key key}) : super(key: key);

  @override
  _NotLearningReasonScreenState createState() =>
      _NotLearningReasonScreenState();
}

class _NotLearningReasonScreenState extends State<NotLearningReasonScreen> {
  @override
  Widget build(BuildContext context) {
    var vm =
        Provider.of<DailyLearningQuestionViewModel>(context, listen: false);
    return Container(
      child: Column(
        children: [
          Text("Warum nicht?"),
          TextField(
            decoration: InputDecoration(hintText: 'Gib ein Hindernis ein'),
            onChanged: (String text) {
              setState(() {});
              vm.notLearningReason = text;
            },
          )
        ],
      ),
    );
  }
}
