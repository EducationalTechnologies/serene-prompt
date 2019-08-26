import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:implementation_intentions/screens/add_goal_screen.dart';
import 'package:implementation_intentions/screens/goal_shielding_screen.dart';
import 'package:implementation_intentions/screens/main_screen.dart';
import 'package:implementation_intentions/shared/route_names.dart';
import 'package:implementation_intentions/state/goal_state.dart';
import 'package:provider/provider.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.MAIN:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case RouteNames.GOAL_SHIELDING:
        return MaterialPageRoute(builder: (_) => GoalShieldingScreen());
      case RouteNames.ADD_GOAL:
        return MaterialPageRoute(builder: (_) => AddGoalScreen());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
              body: Center(
            child: Text('No route defined for ${settings.name}'),
          ));
        });
    }

    // TODO: Continue here. It is most likely not a great idea to wrap the provider stuff at this point. Should maybe be one level further down (Which would also give more control)
    // See here: https://www.filledstacks.com/post/flutter-architecture-my-provider-implementation-guide/
    // However, this requires some refactoring.
    // static Route<dynamic> generateRoute(RouteSettings settings) {
    //   switch(settings.name) {
    //               case RouteNames.MAIN: return ChangeNotifierProvider<GoalState>(
    //                 builder: (_) => GoalState(), child: MainScreen());
    //         case RouteNames.GOALS: (BuildContext context) => GoalMonitorScreen(),
    //         RouteNames.GOAL_SHIELDING: (BuildContext context) =>
    //             MultiProvider(providers: [
    //               ChangeNotifierProvider<GoalShieldingState>.value(
    //                 value: GoalShieldingState(),
    //               ),
    //               ChangeNotifierProvider<GoalState>.value(value: GoalState())
    //             ], child: GoalShieldingScreen()),
    //         RouteNames.ADD_GOAL: (BuildContext context) =>
    //             ChangeNotifierProvider<GoalState>(
    //                 builder: (_) => GoalState(), child: AddGoalScreen()),
    //         RouteNames.EDIT_GOAL: (BuildContext context) =>
    //             ChangeNotifierProvider<GoalState>(
    //                 builder: (_) => GoalState(), child: AddGoalScreen()),
    //   }
    // }
  }
}
