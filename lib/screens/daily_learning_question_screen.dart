import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/screen_args.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/daily_learning_question_view_model.dart';

class DailyLearningQuestionScreen extends StatelessWidget {
  _buildReasonButton(BuildContext context, String reason) {
    var vm = Provider.of<DailyLearningQuestionViewModel>(context);
    return RaisedButton(
      child: Text("Kein Bock"),
      onPressed: () {
        vm.selectedReason = "Keine Lust";
      },
    );
  }

  _buildReasonSelection(BuildContext context) {
    var vm = Provider.of<DailyLearningQuestionViewModel>(context);
    return Wrap(
      children: <Widget>[
        for (var reason in vm.reasons) _buildReasonButton(context, reason),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<DailyLearningQuestionViewModel>(context);

    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text(
            "Has du vor, heute zu Lernen?",
            style: Theme.of(context).textTheme.display1,
          ),
          UIHelper.verticalSpaceMedium(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(children: [Icon(Icons.check), Text("Ja")])),
                onPressed: () {
                  vm.willLearnToday = true;
                  Navigator.pushNamed(context, RouteNames.AMBULATORY_ASSESSMENT,
                      arguments: AssessmentScreenArguments(
                          AssessmentType.preLearning));
                },
              ),
              RaisedButton(
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(children: [Icon(Icons.clear), Text("Nein")])),
                onPressed: () {
                  vm.willLearnToday = false;
                },
              )
            ],
          ),
          if (!vm.willLearnToday)
            Text(
              "Warum?",
              style: Theme.of(context).textTheme.display1,
            ),
          if (!vm.willLearnToday) _buildReasonSelection(context)
        ],
      ),
    );
  }
}
