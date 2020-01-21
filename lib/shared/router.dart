import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/locator.dart';
import 'package:serene/screens/daily_learning_question_screen.dart';
import 'package:serene/screens/edit_tags_screen.dart';
import 'package:serene/screens/goal_monitor_screen.dart';
import 'package:serene/screens/login_screen.dart';
import 'package:serene/screens/settings_screen.dart';
import 'package:serene/screens/test_screen.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/settings_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/add_goal_view_model.dart';
import 'package:serene/viewmodels/ambulatory_assessment_view_model.dart';
import 'package:serene/viewmodels/consent_state.dart';
import 'package:serene/screens/add_goal_screen.dart';
import 'package:serene/screens/ambulatory_assessment_screen.dart';
import 'package:serene/screens/consent_screen.dart';
import 'package:serene/screens/goal_shielding/goal_shielding_screen.dart';
import 'package:serene/screens/main_screen.dart';
import 'package:serene/screens/timer_screen.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/screen_args.dart';
import 'package:serene/viewmodels/daily_learning_question_view_model.dart';
import 'package:serene/viewmodels/edit_tags_view_model.dart';
import 'package:serene/viewmodels/goal_monitoring_view_model.dart';
import 'package:serene/viewmodels/goal_shielding_view_model.dart';
import 'package:serene/viewmodels/login_view_model.dart';
import 'package:provider/provider.dart';
import 'package:serene/viewmodels/settings_view_model.dart';
import 'package:serene/viewmodels/timer_view_model.dart';

class Router {
  static getRoutes() {
    // return {
    //   RouteNames.ADD_GOAL: (context) => ChangeNotifierProvider<GoalState>(
    //       builder: (_) => AddGoalState(null), child: AddGoalScreen())
    // };
  }

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

      case RouteNames.GOAL_SHIELDING:
        return MaterialPageRoute(
            builder: (context) =>
                ChangeNotifierProvider<GoalShieldingViewModel>(
                    create: (_) =>
                        GoalShieldingViewModel(locator.get<DataService>(), locator.get<UserService>()),
                    child: GoalShieldingScreen()));

      case RouteNames.ADD_GOAL:
        final GoalScreenArguments goalArgs = settings.arguments;
        return MaterialPageRoute(
            maintainState: false,
            builder: (context) => ChangeNotifierProvider<AddGoalViewModel>(
                create: (_) => AddGoalViewModel(
                    goal: goalArgs?.goal,
                    dataService: locator.get<DataService>()),
                child: AddGoalScreen()));

      case RouteNames.AMBULATORY_ASSESSMENT:
        final AssessmentScreenArguments assessmentArgs = settings.arguments;
        return MaterialPageRoute(
            builder: (_) =>
                ChangeNotifierProvider<AmbulatoryAssessmentViewModel>(
                    create: (_) => AmbulatoryAssessmentViewModel(
                        assessmentArgs.assessmentType,
                        locator.get<UserService>(),
                        locator.get<DataService>()),
                    child: AmbulatoryAssessmentScreen()));

      case RouteNames.AMBULATORY_ASSESSMENT_DAILY:
        final AssessmentScreenArguments assessmentArgs = settings.arguments;
        return MaterialPageRoute(
            builder: (_) =>
                ChangeNotifierProvider<AmbulatoryAssessmentViewModel>(
                    create: (_) => AmbulatoryAssessmentViewModel(
                        AssessmentType.dailyQuestion,
                        locator.get<UserService>(),
                        locator.get<DataService>()),
                    child: AmbulatoryAssessmentScreen()));

      case RouteNames.AMBULATORY_ASSESSMENT_PRE_TEST:
        return MaterialPageRoute(
            builder: (_) =>
                ChangeNotifierProvider<AmbulatoryAssessmentViewModel>(
                    create: (_) => AmbulatoryAssessmentViewModel(
                        AssessmentType.preLearning,
                        locator.get<UserService>(),
                        locator.get<DataService>()),
                    child: AmbulatoryAssessmentScreen()));

      case RouteNames.AMBULATORY_ASSESSMENT_SRL:
        return MaterialPageRoute(
            builder: (_) =>
                ChangeNotifierProvider<AmbulatoryAssessmentViewModel>(
                    create: (_) => AmbulatoryAssessmentViewModel(
                        AssessmentType.srl,
                        locator.get<UserService>(),
                        locator.get<DataService>()),
                    child: AmbulatoryAssessmentScreen()));

      case RouteNames.AMBULATORY_ASSESSMENT_POST_TEST:
        return MaterialPageRoute(
            builder: (_) =>
                ChangeNotifierProvider<AmbulatoryAssessmentViewModel>(
                    create: (_) => AmbulatoryAssessmentViewModel(
                        AssessmentType.postLearning,
                        locator.get<UserService>(),
                        locator.get<DataService>()),
                    child: AmbulatoryAssessmentScreen()));

      case RouteNames.CONSENT:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<ConsentState>(
                create: (_) => ConsentState(), child: ConsentScreen()));

      case RouteNames.TIMER:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<TimerViewModel>(
                  create: (_) => TimerViewModel(locator.get<SettingsService>()),
                  child: TimerScreen(),
                ));

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

      case RouteNames.EDIT_TAGS:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<EditTagsViewModel>(
                create: (_) => EditTagsViewModel(locator.get<DataService>()),
                child: EditTagsScreen()));

      case RouteNames.TEST:
        return MaterialPageRoute(builder: (_) => TestScreen());

      case RouteNames.DAILY_LEARNING_QUESTIONS:
        return MaterialPageRoute(
            builder: (_) =>
                ChangeNotifierProvider<DailyLearningQuestionViewModel>(
                  create: (_) => DailyLearningQuestionViewModel(),
                  child: DailyLearningQuestionScreen(),
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
