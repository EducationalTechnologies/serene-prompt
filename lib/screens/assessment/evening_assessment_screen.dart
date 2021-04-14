import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:prompt/models/assessment.dart';
import 'package:prompt/screens/assessment/free_text_question.dart';
import 'package:prompt/screens/assessment/multi_step_assessment.dart';
import 'package:prompt/screens/assessment/questionnaire.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/shared/ui_helpers.dart';
import 'package:prompt/viewmodels/evening_assessment_view_model.dart';

class EveningAssessmentScreen extends StatefulWidget {
  EveningAssessmentScreen({Key key}) : super(key: key);

  @override
  _EveningAssessmentScreenState createState() =>
      _EveningAssessmentScreenState();
}

class _EveningAssessmentScreenState extends State<EveningAssessmentScreen> {
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    var vm = Provider.of<EveningAssessmentViewModel>(context, listen: false);

    _pages = [
      _buildAssessmentFuture(
          AssessmentTypes.didLearnToday, ValueKey(vm.stepDidLearnToday)),
      FreeTextQuestion("Warum hast du heute nicht mit cabuu gelernt?",
          textChanged: vm.whyNotLearnReason, key: ValueKey(vm.stepWhyNotLearn)),
      _buildAssessmentFuture(
          AssessmentTypes.evening, ValueKey(vm.stepEveningAssessment)),
      _buildAssessmentFuture(AssessmentTypes.affect, ValueKey(vm.stepAffect)),
      buildFinish(),
    ];
  }

  _buildAssessmentFuture(AssessmentTypes assessmentTypes, Key key) {
    var vm = Provider.of<EveningAssessmentViewModel>(context, listen: false);
    return FutureProvider<Assessment>(
        key: key,
        initialData: Assessment(),
        create: (context) => vm.getAssessment(assessmentTypes),
        child: Consumer<Assessment>(builder: (context, asssessment, _) {
          return Questionnaire(asssessment, vm.setAssessmentResult);
        }));
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<EveningAssessmentViewModel>(context);
    return WillPopScope(
        onWillPop: () async => false,
        child:
            Scaffold(body: Container(child: MultiStepAssessment(vm, _pages))));
  }

  buildFinish() {
    return Container(
      margin: UIHelper.getContainerMargin(),
      child: Column(
        children: [
          Text(
            "Vielen Dank, dass du die Fragen beantwortet hast.",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
