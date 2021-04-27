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
import 'package:prompt/screens/initialsession/video_screen.dart';
import 'package:prompt/screens/initialsession/welcome_screen.dart';
import 'package:prompt/screens/initialsession/cabuu_link_screen.dart';
import 'package:prompt/screens/initialsession/initial_daily_learning_goal_screen.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/viewmodels/init_session_view_model.dart';

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
      WelcomeScreen(key: ValueKey(STEP.welcomeScreen)),
      VideoScreen(
        'assets/videos/videoWelcome.mp4',
        key: ValueKey(STEP.videoWelcome),
        onVideoCompleted: vm.videoWelcomeCompleted,
      ), // Screen 2
      CabuuLinkScreen(key: ValueKey(STEP.cabuuLink)), // Screen 3
      questionnaire(
          AssessmentTypes.itLiteracy, ValueKey(STEP.questionsItLiteracy)),
      questionnaire(
          AssessmentTypes.cabuuLearn, ValueKey(STEP.questionsCabuuLearn)),
      questionnaire(
          AssessmentTypes.regulation, ValueKey(STEP.questionsRegulation)),
      VideoScreen('assets/videos/videoLearning.mp4',
          key: ValueKey(STEP.videoLearning),
          onVideoCompleted: vm.videoLearningInstructionsCompleted), //
      InitialDailyLearningGoalScreen(
          key: ValueKey(STEP.initialDailyLearningGoal)),
      questionnaire(AssessmentTypes.learningGoals1,
          ValueKey(STEP.questionsLearningGoals1)),
      InitialRewardScreenFirst(key: ValueKey(STEP.rewardFirst)),
      InitialOutcomeExplanationScreen(
          key: ValueKey(STEP.outcomeExplanationScreen)),
      OutcomeSelectionScreen(key: ValueKey(STEP.outcomeSelectionScreen)),
      OutcomeEnterScreen(key: ValueKey(STEP.outcomeEnterScreen)),
      OutcomeSortingScreen(key: ValueKey(STEP.outcomeSortingScreen)),
      InitialOutcomeDisplayScreen(key: ValueKey(STEP.outcomeDisplayScreen)),
      InitialObstacleExplanationScreen(
          key: ValueKey(STEP.obstacleExplanationScreen)),
      ObstacleSelectionScreen(key: ValueKey(STEP.obstacleSelectionScreen)),
      ObstacleEnterScreen(key: ValueKey(STEP.obstacleEnterScreen)),
      ObstacleSortingScreen(key: ValueKey(STEP.obstacleSortingScreen)),
      InitialObstacleDisplayScreen(
          key: ValueKey(STEP.obstacleDisplayScreen)), // Screen 16
      questionnaire(AssessmentTypes.learningGoals2,
          ValueKey(STEP.questionsLearningGoals2)),
      VideoScreen('assets/videos/videoLdt.mp4',
          key: ValueKey(STEP.videoLdtInstruction),
          onVideoCompleted: vm.videoLdtCompleted),
      InitialLdtScreen("0_0", _onLdtFinished, key: ValueKey(STEP.ldt00)),
      InitialLdtScreen("0_1", _onLdtFinished, key: ValueKey(STEP.ldt01)),
      InitialRewardScreenSecond(key: ValueKey(STEP.rewardSecond)),
      questionnaire(AssessmentTypes.srl, ValueKey(STEP.questionsSrl)),
      VideoScreen('assets/videos/videoFinished.mp4',
          key: ValueKey(STEP.videoFinish),
          onVideoCompleted: vm.videoFinishCompleted),
    ];
  }

  questionnaire(AssessmentTypes assessmentTypes, Key key) {
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
            // appBar: SereneAppBar(),
            // drawer: SereneDrawer(),
            body: Container(
                child: MultiStepAssessment(
          vm,
          _pages,
          initialStep: vm.getPreviouslyCompletedStep(),
        ))));
  }
}
