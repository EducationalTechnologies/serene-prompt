import 'package:flutter/material.dart';
import 'package:implementation_intentions/screens/add_goal_screen.dart';
import 'package:implementation_intentions/screens/goal_monitor_screen.dart';
import 'package:implementation_intentions/screens/goal_shielding_screen.dart';
import 'package:implementation_intentions/screens/main_screen.dart';
import 'package:implementation_intentions/screens/reflect_screen.dart';
import 'package:implementation_intentions/shared/route_names.dart';
import 'package:implementation_intentions/state/goal_shielding_state.dart';
import 'package:implementation_intentions/state/goal_state.dart';
import 'package:provider/provider.dart';

// Currently following https://medium.com/flutter-community/flutter-architecture-provider-implementation-guide-d33133a9a4e8

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Serene',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryColor: Color(0xff003c7e),
          backgroundColor: Color(0xff344865),
          textTheme: TextTheme(
              body1: TextStyle(fontSize: 16.0, color: Colors.black),
              body2: TextStyle(fontSize: 14.0, color: Colors.blue)),
          primarySwatch: Colors.blue,
        ),
        routes: {
          NamedRoutes.MAIN: (BuildContext context) =>
              ChangeNotifierProvider<GoalState>(
                  builder: (_) => GoalState(), child: MainScreen()),
          NamedRoutes.GOALS: (BuildContext context) => GoalMonitorScreen(),
          NamedRoutes.GOAL_SHIELDING: (BuildContext context) =>
              MultiProvider(providers: [
                ChangeNotifierProvider<GoalShieldingState>.value(
                  value: GoalShieldingState(),
                ),
                ChangeNotifierProvider<GoalState>.value(value: GoalState())
              ], child: GoalShieldingScreen()),
          NamedRoutes.ADD_GOAL: (BuildContext context) =>
              ChangeNotifierProvider<GoalState>(
                  builder: (_) => GoalState(), child: AddGoalScreen()),
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
        }
        // home: ChangeNotifierProvider<ImplementationIntentionModel>(
        //     builder: (_) => ImplementationIntentionModel(),
        //     child: MyHomePage(title: 'Serene')),
        );
  }
}
