import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prompt/screens/assessment/free_text_question.dart';
import 'package:prompt/screens/assessment/multi_step_assessment.dart';
import 'package:prompt/screens/assessment/questionnaire.dart';
import 'package:prompt/screens/internalisation/help_screen.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/shared/ui_helpers.dart';
import 'package:prompt/viewmodels/morning_assessment_view_model.dart';

class MorningAssessmentScreen extends StatefulWidget {
  MorningAssessmentScreen({Key key}) : super(key: key);

  @override
  _MorningAssessmentScreenState createState() =>
      _MorningAssessmentScreenState();
}

class _MorningAssessmentScreenState extends State<MorningAssessmentScreen> {
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    var vm = Provider.of<MorningAssessmentViewModel>(context, listen: false);

    _pages = [
      questionnaireFuture(AssessmentTypes.dailyLearningIntention,
          ValueKey(vm.stepLearningIntention)),
      FreeTextQuestion("Warum möchtest du heute nicht mit cabuu lernen?",
          key: ValueKey(vm.stepReasonNotLearning),
          textChanged: vm.onNotLearningReasonChanged),
      questionnaireFuture(AssessmentTypes.success, ValueKey(vm.stepSuccess)),
      questionnaireFuture(AssessmentTypes.affect, ValueKey(vm.stepAffect)),
      questionnaireFuture(
          AssessmentTypes.dailyObstacle, ValueKey(vm.stepDailyObstacle)),
      buildHelp(ValueKey(vm.stepFinish)),
    ];
  }

  questionnaireFuture(AssessmentTypes assessmentTypes, Key key) {
    var vm = Provider.of<MorningAssessmentViewModel>(context, listen: false);
    return FutureBuilder(
        key: key,
        future: vm.getAssessment(assessmentTypes),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Questionnaire(snapshot.data, vm.setAssessmentResult,
                onLoaded: vm.onAssessmentLoaded, key: key);
          } else {
            return Container(child: CircularProgressIndicator());
          }
        });
  }

  buildHelp(Key key) {
    var vm = Provider.of<MorningAssessmentViewModel>(context, listen: false);
    return FutureBuilder(
        key: key,
        future: vm.getNextCondition(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HelpScreen(snapshot.data);
          } else {
            return Container(child: CircularProgressIndicator());
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<MorningAssessmentViewModel>(context);
    return WillPopScope(
        onWillPop: () async => false,
        child:
            Scaffold(body: Container(child: MultiStepAssessment(vm, _pages))));
  }

  buildFinish(Key key) {
    return Container(
      key: key,
      margin: UIHelper.getContainerMargin(),
      child: Column(
        children: [
          Text(
            "Vielen Dank, dass du die Fragen beantwortet hast. Jetzt geht es weiter zu dem heutigen Plan, den du dir merken sollst.",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
