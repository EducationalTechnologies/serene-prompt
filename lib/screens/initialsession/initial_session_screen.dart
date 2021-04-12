import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:prompt/screens/assessment/multi_step_assessment.dart';
import 'package:prompt/screens/assessment/questionnaire.dart';
import 'package:prompt/screens/initialsession/initial_obstacle_display_screen.dart';
import 'package:prompt/screens/initialsession/initial_outcome_display_screen.dart';
import 'package:prompt/screens/initialsession/initial_obstacle_explanation_screen.dart';
import 'package:prompt/screens/initialsession/initial_ldt_screen.dart';
import 'package:prompt/screens/initialsession/initial_outcome_explanation_screen.dart';
import 'package:prompt/screens/initialsession/initial_reward_screen_first.dart';
import 'package:prompt/screens/initialsession/initial_reward_screen_second.dart';
import 'package:prompt/screens/initialsession/obstacle_enter_screen.dart';
import 'package:prompt/screens/initialsession/obstacle_selection_screen.dart';
import 'package:prompt/screens/initialsession/obstacle_sorting_screen.dart';
import 'package:prompt/screens/initialsession/outcome_enter_screen.dart';
import 'package:prompt/screens/initialsession/outcome_selection_screen.dart';
import 'package:prompt/screens/initialsession/outcome_sorting_screen.dart';
import 'package:prompt/screens/initialsession/text_explanation_screen.dart';
import 'package:prompt/screens/initialsession/video_screen.dart';
import 'package:prompt/screens/initialsession/welcome_screen.dart';
import 'package:prompt/screens/initialsession/cabuu_link_screen.dart';
import 'package:prompt/screens/initialsession/initial_daily_learning_goal_screen.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/viewmodels/init_session_view_model.dart';
import 'package:prompt/widgets/serene_appbar.dart';
import 'package:prompt/widgets/serene_drawer.dart';

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
      WelcomeScreen(key: ValueKey(STEP.stepWelcomeScreen)),
      VideoScreen(
        'assets/videos/videoWelcome.mp4',
        key: ValueKey(STEP.stepVideoWelcome),
        onVideoCompleted: vm.videoWelcomeCompleted,
      ), // Screen 2
      CabuuLinkScreen(key: ValueKey(STEP.stepCabuuLink)), // Screen 3
      questionnaireFuture(
          AssessmentTypes.cabuuLearn, ValueKey(STEP.stepQuestionsCabuuLearn)),
      VideoScreen('assets/videos/videoLdt.mp4',
          key: ValueKey(STEP.stepVideoLdtInstruction),
          onVideoCompleted: vm.videoLdtCompleted),
      InitialLdtScreen("0_0", _onLdtFinished, key: ValueKey(STEP.ldt00)),
      InitialLdtScreen("0_1", _onLdtFinished, key: ValueKey(STEP.stepLdt01)),
      // TODO: REPLACE WITH ACTUAL LDTs 0_2 0_3
      InitialLdtScreen("0_1", _onLdtFinished, key: ValueKey(STEP.stepLdt02)),
      InitialLdtScreen("0_1", _onLdtFinished, key: ValueKey(STEP.stepLdt03)),
      InitialRewardScreenFirst(key: ValueKey(STEP.stepRewardFirst)),
      VideoScreen('assets/videos/videoLearning.mp4',
          key: ValueKey(STEP.stepVideoLearning),
          onVideoCompleted: vm.videoLearningInstructionsCompleted), //
      InitialDailyLearningGoalScreen(
          key: ValueKey(STEP.stepInitialDailyLearningGoal)),
      questionnaireFuture(AssessmentTypes.learningGoals1,
          ValueKey(STEP.stepQuestionsLearningGoals1)), // Screen 1
      questionnaireFuture(
          AssessmentTypes.regulation, ValueKey(STEP.stepQuestionsRegulation)),
      InitialOutcomeExplanationScreen(
          key: ValueKey(STEP.stepOutcomeExplanationScreen)),
      OutcomeSelectionScreen(key: ValueKey(STEP.stepOutcomeSelectionScreen)),
      OutcomeEnterScreen(key: ValueKey(STEP.stepOutcomeEnterScreen)),
      OutcomeSortingScreen(key: ValueKey(STEP.stepOutcomeSortingScreen)),
      InitialOutcomeDisplayScreen(key: ValueKey(STEP.stepOutcomeDisplayScreen)),
      InitialObstacleExplanationScreen(
          key: ValueKey(STEP.stepObstacleExplanationScreen)),
      ObstacleSelectionScreen(key: ValueKey(STEP.stepObstacleSelectionScreen)),
      ObstacleEnterScreen(key: ValueKey(STEP.stepObstacleEnterScreen)),
      ObstacleSortingScreen(key: ValueKey(STEP.stepObstacleSortingScreen)),
      InitialObstacleDisplayScreen(
          key: ValueKey(STEP.stepObstacleDisplayScreen)), // Screen 16
      TextExplanationScreen(
          "So, jetzt kommt noch einmal die Wortaufgabe. Bist du bereit?",
          key: ValueKey(STEP.readyForNextLdtRound)),
      // TODO: REPLACE WITH ACTUAL LDTs 0_4 0_5
      InitialLdtScreen("0_1", _onLdtFinished, key: ValueKey(STEP.stepLdt04)),
      InitialLdtScreen("0_1", _onLdtFinished, key: ValueKey(STEP.stepLdt05)),
      InitialRewardScreenSecond(key: ValueKey(STEP.stepRewardSecond)),
      questionnaireFuture(AssessmentTypes.srl, ValueKey(STEP.stepQuestionsSrl)),
      questionnaireFuture(AssessmentTypes.learningGoals2,
          ValueKey(STEP.stepQuestionsLearningGoals2)),
      VideoScreen('assets/videos/videoFinished.mp4',
          key: ValueKey(STEP.stepVideoFinish),
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
