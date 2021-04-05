import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/screens/assessment/free_text_question.dart';
import 'package:serene/screens/assessment/multi_step_assessment.dart';
import 'package:serene/screens/assessment/questionnaire.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/evening_assessment_view_model.dart';
import 'package:serene/widgets/full_width_button.dart';
import 'package:serene/widgets/serene_appbar.dart';
import 'package:serene/widgets/serene_drawer.dart';

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
      _buildAssessmentFuture(AssessmentTypes.didLearnToday),
      FreeTextQuestion("Warum möchtest du heute nicht mit cabuu lernen?",
          textChanged: vm.whyNotLearnReason),
      _buildAssessmentFuture(AssessmentTypes.evening),
      _buildAssessmentFuture(AssessmentTypes.affect),
      buildFinish(),
    ];
  }

  _buildAssessmentFuture(AssessmentTypes assessmentTypes) {
    var vm = Provider.of<EveningAssessmentViewModel>(context, listen: false);
    return FutureProvider<Assessment>(
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
        child: Scaffold(
            appBar: SereneAppBar(),
            drawer: SereneDrawer(),
            body: Container(child: MultiStepAssessment(vm, _pages))));
  }

  buildFinish() {
    return Container(
      margin: UIHelper.getContainerMargin(),
      child: Column(
        children: [
          Text(
            "Vielen Dank, dass du die Fragen beantwortet hast. Jetzt geht es weiter zu dem heutigen Merkspiel",
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
