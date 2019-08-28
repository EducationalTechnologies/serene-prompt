import 'package:flutter/material.dart';
import 'package:implementation_intentions/shared/router.dart';
import 'package:implementation_intentions/state/app_state.dart';
import 'package:provider/provider.dart';

// Currently following https://medium.com/flutter-community/flutter-architecture-provider-implementation-guide-d33133a9a4e8

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      builder: (_) => AppState(),
      child: MaterialApp(
        title: 'Serene',
        theme: ThemeData(
          primaryColor: Color(0xff003c7e),
          backgroundColor: Color(0xff344865),
          textTheme: TextTheme(
              body1: TextStyle(fontSize: 16.0, color: Colors.black),
              body2: TextStyle(fontSize: 14.0, color: Colors.blue)),
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: Router.generateRoute,
        // routes: {
        //   RouteNames.MAIN: (BuildContext context) =>
        //       ChangeNotifierProvider<GoalState>(
        //           builder: (_) => GoalState(), child: MainScreen()),
        //   RouteNames.GOALS: (BuildContext context) => GoalMonitorScreen(),
        //   RouteNames.GOAL_SHIELDING: (BuildContext context) =>
        //       MultiProvider(providers: [
        //         ChangeNotifierProvider<GoalShieldingState>.value(
        //           value: GoalShieldingState(),
        //         ),
        //         ChangeNotifierProvider<GoalState>.value(value: GoalState())
        //       ], child: GoalShieldingScreen()),
        //   RouteNames.ADD_GOAL: (BuildContext context) =>
        //       ChangeNotifierProvider<GoalState>(
        //           builder: (_) => GoalState(), child: AddGoalScreen()),
        //   RouteNames.EDIT_GOAL: (BuildContext context) =>
        //       ChangeNotifierProvider<GoalState>(
        //           builder: (_) => GoalState(), child: AddGoalScreen()),
        // NamedRoutes.MAIN: (BuildContext context) =>
        //     ChangeNotifierProvider<GoalState>(
        //         builder: (_) => GoalState(), child: ReflectScreen()),
        // NamedRoutes.GOALS: (BuildContext context) => ReflectScreen(),
        // NamedRoutes.GOAL_SHIELDING: (BuildContext context) =>
        //     MultiProvider(providers: [
        //       ChangeNotifierProvider<GoalShieldingState>.value(
        //         value: GoalShieldingState(),
        //       ),
        //       ChangeNotifierProvider<GoalState>.value(value: GoalState())
        //     ], child: ReflectScreen()),
        // NamedRoutes.ADD_GOAL: (BuildContext context) =>
        //     ChangeNotifierProvider<GoalState>(
        //         builder: (_) => GoalState(), child: ReflectScreen()),
        // }
        // home: ChangeNotifierProvider<ImplementationIntentionModel>(
        //     builder: (_) => ImplementationIntentionModel(),
        //     child: MyHomePage(title: 'Serene')),
      ),
    );
  }
}
