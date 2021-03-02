import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/locator.dart';
import 'package:serene/screens/daily_learning_question_screen.dart';
import 'package:serene/screens/goal_monitor_screen.dart';
import 'package:serene/screens/initialsession/initial_session_screen.dart';
import 'package:serene/screens/initialsession/video_screen.dart';
import 'package:serene/screens/internalisation/emoji_story_screen.dart';
import 'package:serene/screens/internalisation/internalisation_recall_screen.dart';
import 'package:serene/screens/internalisation/internalisation_screen.dart';
import 'package:serene/screens/login_screen.dart';
import 'package:serene/screens/no_task_screen.dart';
import 'package:serene/screens/questionnaire/lexical_decision_task_screen.dart';
import 'package:serene/screens/settings_screen.dart';
import 'package:serene/screens/test_screen.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/services/navigation_service.dart';
import 'package:serene/services/settings_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/add_goal_view_model.dart';
import 'package:serene/viewmodels/ambulatory_assessment_view_model.dart';
import 'package:serene/viewmodels/consent_view_model.dart';
import 'package:serene/screens/add_goal_screen.dart';
import 'package:serene/screens/ambulatory_assessment_screen.dart';
import 'package:serene/screens/consent_screen.dart';
import 'package:serene/screens/main_screen.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/screen_args.dart';
import 'package:serene/viewmodels/daily_learning_question_view_model.dart';
import 'package:serene/viewmodels/goal_monitoring_view_model.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';
import 'package:serene/viewmodels/internalisation_recall_view_model.dart';
import 'package:serene/viewmodels/internalisation_view_model.dart';
import 'package:serene/viewmodels/lexical_decision_task_view_model.dart';
import 'package:serene/viewmodels/login_view_model.dart';
import 'package:provider/provider.dart';
import 'package:serene/viewmodels/settings_view_model.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.MAIN:
        return MaterialPageRoute(
            builder: (context) =>
                ChangeNotifierProvider<GoalMonitoringVielModel>(
                    create: (_) =>
                        GoalMonitoringVielModel(locator.get<DataService>()),
                    child: MainScreen()));
      // return MaterialPageRoute(builder: (_) => MainScreen());

      case RouteNames.INTERNALISATION:
        return MaterialPageRoute(
            builder: (context) =>
                ChangeNotifierProvider<InternalisationViewModel>(
                    create: (_) => InternalisationViewModel(
                        locator.get<DataService>(),
                        locator.get<ExperimentService>()),
                    child: InternalisationScreen()));

      case RouteNames.EMOJI_STORY:
        final InternalisationViewModel vm = settings.arguments;
        return MaterialPageRoute(
            builder: (context) =>
                ChangeNotifierProvider<InternalisationViewModel>(
                    create: (_) => vm, child: EmojiStoryScreen()));

      case RouteNames.ADD_GOAL:
        final GoalScreenArguments goalArgs = settings.arguments;
        return MaterialPageRoute(
            maintainState: false,
            builder: (context) => ChangeNotifierProvider<AddGoalViewModel>(
                create: (_) => AddGoalViewModel(
                    goal: goalArgs?.goal,
                    dataService: locator.get<DataService>()),
                child: AddGoalScreen()));

      case RouteNames.RECALL_TASK:
        return MaterialPageRoute(
            builder: (context) =>
                ChangeNotifierProvider<InternalisationRecallViewModel>(
                    create: (_) => InternalisationRecallViewModel(
                        locator.get<ExperimentService>()),
                    child: InternalisationRecallScreen()));

      case RouteNames.AMBULATORY_ASSESSMENT:
        final AssessmentScreenArguments assessmentArgs = settings.arguments;
        return MaterialPageRoute(
            builder: (_) =>
                ChangeNotifierProvider<AmbulatoryAssessmentViewModel>(
                    create: (_) => AmbulatoryAssessmentViewModel(
                        assessmentArgs.assessmentType,
                        locator.get<UserService>(),
                        locator.get<ExperimentService>()),
                    child: AmbulatoryAssessmentScreen()));

      case RouteNames.AMBULATORY_ASSESSMENT_USABILITY:
        return MaterialPageRoute(
            builder: (_) =>
                ChangeNotifierProvider<AmbulatoryAssessmentViewModel>(
                    create: (_) => AmbulatoryAssessmentViewModel(
                        Assessments.usability,
                        locator.get<UserService>(),
                        locator.get<ExperimentService>()),
                    child: AmbulatoryAssessmentScreen()));

      case RouteNames.AMBULATORY_ASSESSMENT_PRE_TEST:
        return MaterialPageRoute(
            builder: (_) =>
                ChangeNotifierProvider<AmbulatoryAssessmentViewModel>(
                    create: (_) => AmbulatoryAssessmentViewModel(
                        Assessments.preLearning,
                        locator.get<UserService>(),
                        locator.get<ExperimentService>()),
                    child: AmbulatoryAssessmentScreen()));

      case RouteNames.AMBULATORY_ASSESSMENT_PRE_II_INTERNALISATION:
        return MaterialPageRoute(
            builder: (_) =>
                ChangeNotifierProvider<AmbulatoryAssessmentViewModel>(
                    create: (_) => AmbulatoryAssessmentViewModel(
                        Assessments.preImplementationIntention,
                        locator.get<UserService>(),
                        locator.get<ExperimentService>()),
                    child: AmbulatoryAssessmentScreen()));

      case RouteNames.CONSENT:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<ConsentViewModel>(
                create: (_) => ConsentViewModel(
                    locator.get<DataService>(),
                    locator.get<UserService>(),
                    locator.get<NavigationService>()),
                child: ConsentScreen()));

      case RouteNames.OPEN_GOALS:
        return MaterialPageRoute(
            builder: (context) => MultiProvider(providers: [
                  ChangeNotifierProvider<GoalMonitoringVielModel>(
                      create: (_) =>
                          GoalMonitoringVielModel(Provider.of(context))),
                ], child: GoalMonitorScreen()));

      case RouteNames.LOG_IN:
        return MaterialPageRoute(
            builder: (_) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider<LoginViewModel>.value(
                          value: LoginViewModel(locator.get<UserService>())),
                    ],
                    child: LoginScreen(
                      backgroundColor1: Colors.orange[50],
                      backgroundColor2: Colors.orange[50],
                      highlightColor: Colors.blue,
                      foregroundColor: Colors.blue[300],
                    )));

      case RouteNames.SETTINGS:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<SettingsViewModel>(
                create: (_) =>
                    SettingsViewModel(locator.get<SettingsService>()),
                child: SettingsScreen()));

      case RouteNames.TEST:
        return MaterialPageRoute(builder: (_) => TestScreen());

      case RouteNames.NO_TASKS:
        return MaterialPageRoute(builder: (_) => NoTasksScreen());

      case RouteNames.DAILY_LEARNING_QUESTIONS:
        return MaterialPageRoute(
            builder: (_) =>
                ChangeNotifierProvider<DailyLearningQuestionViewModel>(
                  create: (_) => DailyLearningQuestionViewModel(),
                  child: DailyLearningQuestionScreen(),
                ));

      case RouteNames.INIT_START:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<InitSessionViewModel>(
                  create: (_) => InitSessionViewModel(
                      locator.get<DataService>(),
                      locator.get<ExperimentService>()),
                  child: InitialSessionScreen(),
                ));

      case RouteNames.LDT:
        final String trialName = settings.arguments;
        return MaterialPageRoute(
            builder: (_) =>
                ChangeNotifierProvider<LexicalDecisionTaskViewModel>(
                  create: (_) => LexicalDecisionTaskViewModel(
                      trialName, locator.get<ExperimentService>()),
                  child: LexicalDecisionTaskScren(),
                ));

      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
              body: Center(
            child: Text('No route defined for ${settings.name}'),
          ));
        });
    }
  }
}
