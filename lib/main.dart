import 'package:flutter/material.dart';
import 'package:implementation_intentions/screens/add_goal.dart';
import 'package:implementation_intentions/screens/add_goal_screen.dart';
import 'package:implementation_intentions/screens/goal_monitor_screen.dart';
import 'package:implementation_intentions/screens/goal_shielding.dart';
import 'package:implementation_intentions/screens/main_screen.dart';
import 'package:implementation_intentions/screens/shield_repetition.dart';
import 'package:implementation_intentions/shared/route_names.dart';
import 'package:implementation_intentions/state/goal_state.dart';
import 'package:implementation_intentions/state/implementation_intention_state.dart';
import 'package:implementation_intentions/widgets/serene_drawer.dart';
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
          "/": (BuildContext context) =>
              ChangeNotifierProvider<ImplementationIntentionState>(
                  builder: (_) => ImplementationIntentionState(),
                  child: MyHomePage(title: 'Serene')),
          NamedRoutes.GOALS: (BuildContext context) => GoalMonitorScreen(),
          NamedRoutes.GOAL_SHIELDING: (BuildContext context) =>
              ChangeNotifierProvider<ImplementationIntentionState>(
                  builder: (_) => ImplementationIntentionState(),
                  child: MyHomePage(title: 'Serene')),
          NamedRoutes.MAIN: (BuildContext context) =>
              ChangeNotifierProvider<GoalState>(
                  builder: (_) => GoalState(), child: MainScreen()),
          NamedRoutes.ADD_GOAL: (BuildContext context) =>
              ChangeNotifierProvider<GoalState>(
                  builder: (_) => GoalState(), child: AddGoalScreen()),
        }
        // home: ChangeNotifierProvider<ImplementationIntentionModel>(
        //     builder: (_) => ImplementationIntentionModel(),
        //     child: MyHomePage(title: 'Serene')),
        );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: SereneDrawer(),
      backgroundColor: Colors.amber,
      body: Container(
        child: PageView(
          children: <Widget>[AddGoal(), GoalShielding(), ShieldRepetition()],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
