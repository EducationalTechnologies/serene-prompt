import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/screens/assessment/free_text_question.dart';
import 'package:serene/screens/assessment/multi_step_assessment.dart';
import 'package:serene/screens/assessment/questionnaire.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/morning_assessment_view_model.dart';
import 'package:serene/widgets/serene_appbar.dart';
import 'package:serene/widgets/serene_drawer.dart';

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
      buildFinish(ValueKey(vm.stepFinish)),
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

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<MorningAssessmentViewModel>(context);
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: SereneAppBar(),
            drawer: SereneDrawer(),
            body: Container(child: MultiStepAssessment(vm, _pages))));
  }

  buildFinish(Key key) {
    return Container(
      key: key,
      margin: UIHelper.getContainerMargin(),
      child: Column(
        children: [
          Text(
              "Vielen Dank, dass du die Fragen beantwortet hast. Jetzt geht es weiter zu dem heutigen Merkspiel"),
          // FullWidthButton(
          //     text: "Abschicken",
          //     onPressed: () {
          //       var vm = Provider.of<MorningAssessmentViewModel>(context,
          //           listen: false);
          //       if (vm.state == ViewState.idle) {
          //         vm.submit();
          //       }
          //     })
        ],
      ),
    );
  }
}
