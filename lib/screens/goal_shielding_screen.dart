import 'package:flutter/material.dart';
import 'package:implementation_intentions/screens/goal_selection_screen.dart';
import 'package:implementation_intentions/screens/goal_shielding_internalisation_screen.dart';
import 'package:implementation_intentions/screens/goal_shielding_selection_screen.dart';
import 'package:implementation_intentions/state/goal_monitoring_state.dart';
import 'package:implementation_intentions/state/goal_shielding_state.dart';
import 'package:implementation_intentions/widgets/serene_drawer.dart';
import 'package:provider/provider.dart';

class GoalShieldingScreen extends StatefulWidget {
  @override
  _GoalShieldingScreenState createState() => _GoalShieldingScreenState();
}

class _GoalShieldingScreenState extends State<GoalShieldingScreen> {
  @override
  Widget build(BuildContext context) {
    List<Widget> _goalShieldingPages = [
      GoalSelectionScreen(),
      GoalShieldingSelectionScreen(),
      GoalShieldingInternalisationScreen()
    ];
    final _controller = new PageController();
    const _kDuration = const Duration(milliseconds: 300);
    const _kCurve = Curves.ease;

    print("Calling Build In Goal Shielding Screen");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GoalShieldingState>.value(
            value: GoalShieldingState()),
        ChangeNotifierProvider<GoalMonitoringState>.value(
            value: GoalMonitoringState()),
      ],
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Goal Shielding"),
        ),
        drawer: SereneDrawer(),
        // backgroundColor: Colors.amber,
        body: Column(
          children: [
            Flexible(
              child: PageView.builder(
                controller: _controller,
                itemCount: _goalShieldingPages.length,
                itemBuilder: (context, index) {
                  return _goalShieldingPages[index];
                },
              ),
            ),
            Container(
              color: Colors.lightBlue[50],
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    child: Text("Prev"),
                    onPressed: () {
                      _controller.previousPage(
                          duration: _kDuration, curve: _kCurve);
                    },
                  ),
                  FlatButton(
                    child: Text("Next"),
                    onPressed: () {
                      _controller.nextPage(
                          duration: _kDuration, curve: _kCurve);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
