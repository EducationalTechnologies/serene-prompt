import 'package:flutter/material.dart';
import 'package:prompt/screens/assessment/multi_step_assessment.dart';
import 'package:prompt/screens/assessment/questionnaire.dart';
import 'package:prompt/screens/initialsession/text_explanation_screen.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/viewmodels/usability_assessment_view_model.dart';
import 'package:provider/provider.dart';

class UsabilityAssessmentScreen extends StatefulWidget {
  UsabilityAssessmentScreen({Key key}) : super(key: key);

  @override
  _UsabilityAssessmentScreenState createState() =>
      _UsabilityAssessmentScreenState();
}

class _UsabilityAssessmentScreenState extends State<UsabilityAssessmentScreen> {
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    _pages = [
      questionnaireFuture(AssessmentTypes.usability, ValueKey(STEPS.questions)),
      TextExplanationScreen(
          'Gleich machst du wieder die Wortaufgabe. Denk daran: Drücke die Taste "Ja", wenn es sich um ein echtes Wort handelt, und die Taste "Nein", wenn es sich nicht um ein echtes Wort handelt. Drücke die richtige Taste so schnell wie möglich!')
    ];
  }

  questionnaireFuture(AssessmentTypes assessmentTypes, Key key) {
    var vm = Provider.of<UsabilityAssessmentViewModel>(context, listen: false);
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
    var vm = Provider.of<UsabilityAssessmentViewModel>(context);
    return WillPopScope(
        onWillPop: () async => false,
        child:
            Scaffold(body: Container(child: MultiStepAssessment(vm, _pages))));
  }
}
