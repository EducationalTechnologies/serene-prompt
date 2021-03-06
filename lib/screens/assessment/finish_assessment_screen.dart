import 'package:flutter/material.dart';
import 'package:prompt/screens/assessment/free_text_question.dart';
import 'package:prompt/screens/assessment/multi_step_assessment.dart';
import 'package:prompt/screens/assessment/questionnaire.dart';
import 'package:prompt/screens/initialsession/text_explanation_screen.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/viewmodels/finish_assessment_view_model.dart';
import 'package:provider/provider.dart';

class FinishAssessmentScreen extends StatefulWidget {
  FinishAssessmentScreen({Key key}) : super(key: key);

  @override
  _FinishAssessmentScreenState createState() => _FinishAssessmentScreenState();
}

class _FinishAssessmentScreenState extends State<FinishAssessmentScreen> {
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    var vm = Provider.of<FinishAssessmentViewModel>(context, listen: false);

    _pages = [
      TextExplanationScreen(
        "Wir sind am Ende der Studie angelangt. Noch einmal vielen Dank, dass du mitgemacht hast! Zum Schluss haben wir noch ein paar Fragen an dich, für die du die letzten 10💎 bekommst.",
        key: ValueKey(STEPS.instruction),
      ),
      questionnaireFuture(AssessmentTypes.visibilitySelection,
          ValueKey(STEPS.visibilitySelection)),
      questionnaireFuture(AssessmentTypes.visibilityCouldRead,
          ValueKey(STEPS.visibilityCouldRead)),
      questionnaireFuture(
          AssessmentTypes.finalAttitude, ValueKey(STEPS.questionsAttitude)),
      questionnaireFuture(
          AssessmentTypes.finalMotivation, ValueKey(STEPS.questionsMotivation)),
      FreeTextQuestion(
        "Das fand ich gut an der App:",
        key: ValueKey(STEPS.questionsFreePositive),
        textChanged: vm.setTextPositive,
      ),
      FreeTextQuestion("Das fand ich nicht so gut an der App:",
          key: ValueKey(STEPS.questionsFreeNegative),
          textChanged: vm.setTextNegative),
    ];
  }

  questionnaireFuture(AssessmentTypes assessmentTypes, Key key) {
    var vm = Provider.of<FinishAssessmentViewModel>(context, listen: false);
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

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<FinishAssessmentViewModel>(context);
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            // appBar: SereneAppBar(),
            // drawer: SereneDrawer(),
            body: Container(child: MultiStepAssessment(vm, _pages))));
  }
}
