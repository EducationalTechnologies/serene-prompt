import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/locator.dart';
import 'package:serene/screens/goal_monitor_screen.dart';
import 'package:serene/screens/login_screen.dart';
import 'package:serene/screens/test_screen.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/state/add_goal_view_model.dart';
import 'package:serene/state/ambulatory_assessment_state.dart';
import 'package:serene/state/consent_state.dart';
import 'package:serene/screens/add_goal_screen.dart';
import 'package:serene/screens/ambulatory_assessment_screen.dart';
import 'package:serene/screens/consent_screen.dart';
import 'package:serene/screens/goal_shielding_screen.dart';
import 'package:serene/screens/main_screen.dart';
import 'package:serene/screens/timer_screen.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/screen_args.dart';
import 'package:serene/state/goal_monitoring_state.dart';
import 'package:serene/state/goal_shielding_state.dart';
import 'package:serene/state/login_state.dart';
import 'package:serene/state/timer_state.dart';
import 'package:provider/provider.dart';

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
        return MaterialPageRoute(builder: (_) => MainScreen());

      case RouteNames.GOAL_SHIELDING:
        return MaterialPageRoute(
            builder: (context) =>
                ChangeNotifierProvider<GoalShieldingState>.value(
                    value: GoalShieldingState(locator.get<DataService>()),
                    child: GoalShieldingScreen()));

      case RouteNames.ADD_GOAL:
        final GoalScreenArguments goalArgs = settings.arguments;
        return MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<AddGoalViewModel>.value(
                value: AddGoalViewModel(
                    goal: goalArgs?.goal,
                    dataService: locator.get<DataService>()),
                child: AddGoalScreen()));

      case RouteNames.AMBULATORY_ASSESSMENT:
        final AssessmentScreenArguments assessmentArgs = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<AmbulatoryAssessmentState>(
                builder: (_) =>
                    AmbulatoryAssessmentState(assessmentArgs.assessmentType),
                child: AmbulatoryAssessmentScreen()));

      case RouteNames.CONSENT:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<ConsentState>(
                builder: (_) => ConsentState(), child: ConsentScreen()));

      case RouteNames.TIMER:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<TimerState>(
                  builder: (_) => TimerState(),
                  child: TimerScreen(),
                ));

      case RouteNames.OPEN_GOALS:
        return MaterialPageRoute(
            builder: (context) => MultiProvider(providers: [
                  ChangeNotifierProvider<GoalMonitoringState>.value(
                      value: GoalMonitoringState(Provider.of(context))),
                ], child: GoalMonitorScreen()));

      case RouteNames.LOG_IN:
        return MaterialPageRoute(
            builder: (_) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider<LoginState>.value(
                          value: LoginState(locator.get<UserService>())),
                    ],
                    child: LoginScreen(
                      backgroundColor1: Colors.orange[50],
                      backgroundColor2: Colors.orange[50],
                      highlightColor: Colors.blue,
                      foregroundColor: Colors.blue[300],
                    )));

      case RouteNames.TEST:
        return MaterialPageRoute(builder: (_) => TestScreen());

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
