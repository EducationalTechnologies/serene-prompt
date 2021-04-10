import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/screens/assessment/multi_step_assessment.dart';
import 'package:serene/screens/assessment/questionnaire.dart';
import 'package:serene/screens/initialsession/initial_obstacle_display_screen.dart';
import 'package:serene/screens/initialsession/initial_outcome_display_screen.dart';
import 'package:serene/screens/initialsession/initial_obstacle_explanation_screen.dart';
import 'package:serene/screens/initialsession/initial_ldt_screen.dart';
import 'package:serene/screens/initialsession/initial_outcome_explanation_screen.dart';
import 'package:serene/screens/initialsession/initial_reward_screen_first.dart';
import 'package:serene/screens/initialsession/initial_reward_screen_second.dart';
import 'package:serene/screens/initialsession/obstacle_enter_screen.dart';
import 'package:serene/screens/initialsession/obstacle_selection_screen.dart';
import 'package:serene/screens/initialsession/obstacle_sorting_screen.dart';
import 'package:serene/screens/initialsession/outcome_enter_screen.dart';
import 'package:serene/screens/initialsession/outcome_selection_screen.dart';
import 'package:serene/screens/initialsession/outcome_sorting_screen.dart';
import 'package:serene/screens/initialsession/text_explanation_screen.dart';
import 'package:serene/screens/initialsession/video_screen.dart';
import 'package:serene/screens/initialsession/welcome_screen.dart';
import 'package:serene/screens/initialsession/cabuu_link_screen.dart';
import 'package:serene/screens/initialsession/initial_daily_learning_goal_screen.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';
import 'package:serene/widgets/serene_appbar.dart';
import 'package:serene/widgets/serene_drawer.dart';

class InitialSessionScreen extends StatefulWidget {
  InitialSessionScreen({Key key}) : super(key: key);

  @override
  _InitialSessionScreenState createState() => _InitialSessionScreenState();
}

class _InitialSessionScreenState extends State<InitialSessionScreen> {
  List<Widget> _pages = [];

  Map<int, Widget> pageMap = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var vm = Provider.of<InitSessionViewModel>(context, listen: false);

    _pages = [
      WelcomeScreen(key: ValueKey(vm.stepWelcomeScreen)),
      VideoScreen(
        'assets/videos/videoWelcome.mp4',
        key: ValueKey(vm.stepVideoWelcome),
        onVideoCompleted: vm.videoWelcomeCompleted,
      ), // Screen 2
      CabuuLinkScreen(key: ValueKey(vm.stepCabuuLink)), // Screen 3
      questionnaireFuture(
          AssessmentTypes.cabuuLearn, ValueKey(vm.stepQuestionsCabuuLearn)),
      VideoScreen('assets/videos/videoLdt.mp4',
          key: ValueKey(vm.stepVideoLdtInstruction),
          onVideoCompleted: vm.videoLdtCompleted),
      InitialLdtScreen("0_0", _onLdtFinished, key: ValueKey(vm.stepLdt00)),
      InitialLdtScreen("0_1", _onLdtFinished, key: ValueKey(vm.stepLdt01)),
      // TODO: REPLACE WITH ACTUAL LDTs 0_2 0_3
      InitialLdtScreen("0_1", _onLdtFinished, key: ValueKey(vm.stepLdt02)),
      InitialLdtScreen("0_1", _onLdtFinished, key: ValueKey(vm.stepLdt03)),
      InitialRewardScreenFirst(key: ValueKey(vm.stepRewardFirst)),
      VideoScreen('assets/videos/videoLearning.mp4',
          key: ValueKey(vm.stepVideoLearning),
          onVideoCompleted: vm.videoLearningInstructionsCompleted), //
      InitialDailyLearningGoalScreen(
          key: ValueKey(vm.stepInitialDailyLearningGoal)),
      questionnaireFuture(AssessmentTypes.learningGoals1,
          ValueKey(vm.stepQuestionsLearningGoals1)), // Screen 1
      questionnaireFuture(
          AssessmentTypes.regulation, ValueKey(vm.stepQuestionsRegulation)),
      InitialOutcomeExplanationScreen(
          key: ValueKey(vm.stepOutcomeExplanationScreen)),
      OutcomeSelectionScreen(key: ValueKey(vm.stepOutcomeSelectionScreen)),
      OutcomeEnterScreen(key: ValueKey(vm.stepOutcomeEnterScreen)),
      OutcomeSortingScreen(key: ValueKey(vm.stepOutcomeSortingScreen)),
      InitialOutcomeDisplayScreen(key: ValueKey(vm.stepOutcomeDisplayScreen)),
      InitialObstacleExplanationScreen(
          key: ValueKey(vm.stepObstacleExplanationScreen)),
      ObstacleSelectionScreen(key: ValueKey(vm.stepObstacleSelectionScreen)),
      ObstacleEnterScreen(key: ValueKey(vm.stepObstacleEnterScreen)),
      ObstacleSortingScreen(key: ValueKey(vm.stepObstacleSortingScreen)),
      InitialObstacleDisplayScreen(
          key: ValueKey(vm.stepObstacleDisplayScreen)), // Screen 16
      TextExplanationScreen(
          "So, jetzt kommt noch einmal die Wortaufgabe. Bist du bereit?"),
      // TODO: REPLACE WITH ACTUAL LDTs 0_4 0_5
      InitialLdtScreen("0_1", _onLdtFinished, key: ValueKey(vm.stepLdt04)),
      InitialLdtScreen("0_1", _onLdtFinished, key: ValueKey(vm.stepLdt05)),
      InitialRewardScreenSecond(key: ValueKey(vm.stepRewardSecond)),
      questionnaireFuture(AssessmentTypes.srl, ValueKey(vm.stepQuestionsSrl)),
      questionnaireFuture(AssessmentTypes.learningGoals2,
          ValueKey(vm.stepQuestionsLearningGoals2)),
      VideoScreen('assets/videos/videoFinished.mp4',
          key: ValueKey(vm.stepVideoFinish),
          onVideoCompleted: vm.videoFinishCompleted),
    ];
  }

  questionnaireFuture(AssessmentTypes assessmentTypes, Key key) {
    var vm = Provider.of<InitSessionViewModel>(context);
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

  _onLdtFinished() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<InitSessionViewModel>(context);
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: SereneAppBar(),
            drawer: SereneDrawer(),
            body: Container(
                child: MultiStepAssessment(
              vm,
              _pages,
              initialStep: vm.getPreviouslyCompletedStep(),
            ))));
  }
}
