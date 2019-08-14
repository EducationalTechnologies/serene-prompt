import 'package:flutter/material.dart';
import 'package:implementation_intentions/screens/goal_selection_screen.dart';
import 'package:implementation_intentions/screens/goal_shielding_internalisation_screen.dart';
import 'package:implementation_intentions/screens/goal_shielding_selection_screen.dart';
import 'package:implementation_intentions/state/goal_shielding_state.dart';
import 'package:implementation_intentions/widgets/serene_drawer.dart';
import 'package:provider/provider.dart';

class GoalShieldingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<GoalShieldingState>(context);
    state.fetchData();
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Goal Shielding"),
      ),
      drawer: SereneDrawer(),
      backgroundColor: Colors.amber,
      body: Container(
        child: PageView(
          children: <Widget>[
            GoalSelectionScreen(),
            GoalShieldingSelectionScreen(),
            GoalShieldingInternalisationScreen()
          ],
        ),
      ),
    );
  }
}
