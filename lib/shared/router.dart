import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:implementation_intentions/screens/add_goal_screen.dart';
import 'package:implementation_intentions/screens/ambulatory_assessment_screen.dart';
import 'package:implementation_intentions/screens/goal_shielding_screen.dart';
import 'package:implementation_intentions/screens/main_screen.dart';
import 'package:implementation_intentions/shared/route_names.dart';
import 'package:implementation_intentions/shared/screen_args.dart';
import 'package:implementation_intentions/state/goal_monitoring_state.dart';
import 'package:implementation_intentions/state/goal_state.dart';
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
        return MaterialPageRoute(builder: (_) => GoalShieldingScreen());
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
        return MaterialPageRoute(builder: (_) => AmbulatoryAssessmentScreen());
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
