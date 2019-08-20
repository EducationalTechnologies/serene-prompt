import 'package:flutter/material.dart';
import 'package:implementation_intentions/screens/goal_selection_screen.dart';
import 'package:implementation_intentions/screens/goal_shielding_internalisation_screen.dart';
import 'package:implementation_intentions/screens/goal_shielding_selection_screen.dart';
import 'package:implementation_intentions/widgets/serene_drawer.dart';

class GoalShieldingScreen extends StatefulWidget {
  @override
  _GoalShieldingScreenState createState() => _GoalShieldingScreenState();
}

class _GoalShieldingScreenState extends State<GoalShieldingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    // var state = Provider.of<GoalShieldingState>(context);
    // state.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Calling Build In Goal Shielding Screen");
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Goal Shielding"),
      ),
      drawer: SereneDrawer(),
      // backgroundColor: Colors.amber,
      body: Container(
        child: PageView(
          children: <Widget>[
            GoalSelectionScreen(),
            // GoalShieldingSelectionScreen(),
            // GoalShieldingInternalisationScreen()
          ],
        ),
      ),
    );
  }
}
