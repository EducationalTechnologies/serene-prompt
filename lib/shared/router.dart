import 'package:flutter/widgets.dart';
import 'package:implementation_intentions/state/goal_state.dart';
import 'package:provider/provider.dart';

class Router {
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
