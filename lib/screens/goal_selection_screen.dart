import 'package:flutter/material.dart';
import 'package:implementation_intentions/state/goal_shielding_state.dart';
import 'package:implementation_intentions/state/goal_state.dart';
import 'package:implementation_intentions/state/implementation_intention_state.dart';
import 'package:provider/provider.dart';

class GoalSelectionScreen extends StatefulWidget {
  @override
  _GoalSelectionScreenState createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  int _selectedIndex;

  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var shieldingState = Provider.of<GoalShieldingState>(context);
    return Container(
      child: ListView.builder(
        itemCount: Provider.of<GoalState>(context).goals.length,
        itemBuilder: (context, index) => Container(
          // TODO: Change color to something more pretty
          color: _selectedIndex == index ? Colors.red : Colors.white,
          child: ListTile(
            title: Text(Provider.of<GoalState>(context).goals[index].goal),
            onTap: () {
              _onSelected(index);
            },
          ),
        ),
      ),
    );
  }
}
