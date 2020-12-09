import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/goal_shielding_view_model.dart';

class HighlightInternalisationScreen extends StatefulWidget {
  HighlightInternalisationScreen({Key key}) : super(key: key);

  @override
  _HighlightInternalisationScreenState createState() =>
      _HighlightInternalisationScreenState();
}

class _HighlightInternalisationScreenState
    extends State<HighlightInternalisationScreen> {
  Widget getIndividualChars(String input) {
    return Wrap(children: [for (var char in input.split("")) new Text(char)]);
  }

  @override
  Widget build(BuildContext context) {
    final intention =
        Provider.of<GoalShieldingViewModel>(context, listen: false);

    var intentionTextList = getIndividualChars(intention.shieldingSentence);

    return Container(
      child: Column(
        children: <Widget>[
          UIHelper.verticalSpaceMedium(),
          UIHelper.verticalSpaceMedium(),
          Text(intention.shieldingSentence),
          intentionTextList,
          UIHelper.verticalSpaceMedium(),
          // Text("Debug Stuff Counter: $_longPressCounter")
        ],
      ),
    );
  }
}
