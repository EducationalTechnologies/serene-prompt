import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/screens/test_screen.dart';
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
import 'package:serene/state/goal_state.dart';
import 'package:serene/state/timer_state.dart';
import 'package:provider/provider.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.MAIN:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<GoalMonitoringState>(
                  builder: (_) => GoalMonitoringState(),
                  child: MainScreen(),
                ));
      case RouteNames.GOAL_SHIELDING:
        return MaterialPageRoute(
            builder: (_) => MultiProvider(providers: [
                  ChangeNotifierProvider<GoalShieldingState>.value(
                      value: GoalShieldingState()),
                  ChangeNotifierProvider<GoalMonitoringState>.value(
                      value: GoalMonitoringState()),
                ], child: GoalShieldingScreen()));
      case RouteNames.ADD_GOAL:
        final GoalScreenArguments goalArgs = settings.arguments;
        if (goalArgs?.goal != null) {
          return MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider<GoalState>(
                  builder: (_) => GoalState.fromGoal(goalArgs.goal),
                  child: AddGoalScreen()));
        }
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<GoalState>(
                builder: (_) => GoalState(), child: AddGoalScreen()));

      case RouteNames.AMBULATORY_ASSESSMENT:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<ConsentState>(
                builder: (_) => ConsentState(),
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
