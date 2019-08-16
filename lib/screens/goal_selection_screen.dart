import 'package:flutter/material.dart';
import 'package:implementation_intentions/shared/text_styles.dart';
import 'package:implementation_intentions/shared/ui_helpers.dart';
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

  bool _showText = false;

  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  buildNewGoalRow() {
    return TextField(
      autofocus: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onSubmitted: (term) {
        setState(() {
          _showText = false;
        });
      },
      onEditingComplete: () {
        setState(() {
          _showText = false;
        });
      },
      decoration: InputDecoration(icon: Icon(Icons.pages)),
    );
  }

  buildAddGoalButton() {
    return SizedBox(
        width: double.infinity,
        height: 60.0,
        // height: double.infinity,
        child: new RaisedButton(
          child: Text("Neues Ziel"),
          onPressed: () {
            setState(() {
              _showText = !_showText;
            });
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    var shieldingState = Provider.of<GoalShieldingState>(context);

    // if (MediaQuery.of(context).viewInsets.bottom == 0) {
    //   setState(() {
    //     _showText = false;
    //   });
    // }

    return Container(
        child: Column(
      children: <Widget>[
        // UIHelper.verticalSpaceMedium(),
        Text("Ziel auswählen", style: subHeaderStyle),
        Flexible(
          // fit: FlexFit.tight,
          child: ListView.builder(
              itemCount: Provider.of<GoalState>(context).goals.length,
              itemBuilder: (context, index) => Container(
                  // TODO: Change color to something more pretty
                  color: _selectedIndex == index
                      ? Colors.orange[200]
                      : Colors.transparent,
                  child: ListTile(
                    title:
                        Text(Provider.of<GoalState>(context).goals[index].goal),
                    onTap: () {
                      _onSelected(index);
                    },
                  ))),
        ),
        // buildNewGoalRow()
        Expanded(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(children: [
                // buildAddGoalButton()
                buildNewGoalRow()
                // this._showText ? buildNewGoalRow() : buildAddGoalButton()
              ])),
        ),
        // Flexible(
        //   child: Row(
        //     children: <Widget>[
        //       TextField(
        //           keyboardType: TextInputType.text,
        //           decoration:
        //               InputDecoration(fillColor: Colors.grey, filled: true),
        //           textInputAction: TextInputAction.done),
        //     ],
        //   ),
        // )
      ],
    ));
  }
}
