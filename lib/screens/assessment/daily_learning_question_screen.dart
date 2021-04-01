import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/morning_assessment_view_model.dart';

class DailyLearningQuestionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<MorningAssessmentViewModel>(context);

    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text(
            "Has du vor, heute mit cabuu zu lernen?",
            style: Theme.of(context).textTheme.headline6,
          ),
          UIHelper.verticalSpaceMedium(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: Text("Ja"),
                onPressed: () {
                  vm.setAssessmentResult(
                      AssessmentTypes.dailyLearningGoal.toString(),
                      "dailyLearningGoal",
                      DailyLearningIntention.yes.toString());
                },
              ),
              ElevatedButton(
                child: Text("Nein"),
                onPressed: () {
                  vm.setAssessmentResult(
                      AssessmentTypes.dailyLearningGoal.toString(),
                      "dailyLearningGoal",
                      DailyLearningIntention.no.toString());
                },
              ),
              ElevatedButton(
                child: Text("Weiß noch nicht"),
                onPressed: () {
                  vm.setAssessmentResult(
                      AssessmentTypes.dailyLearningGoal.toString(),
                      "dailyLearningGoal",
                      DailyLearningIntention.unsure.toString());
                },
              ),
              ElevatedButton(
                child: Text("Ich habe schon gelernt"),
                onPressed: () {
                  vm.setAssessmentResult(
                      AssessmentTypes.dailyLearningGoal.toString(),
                      "dailyLearningGoal",
                      DailyLearningIntention.unsure.toString());
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
