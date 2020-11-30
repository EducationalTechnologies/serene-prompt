import 'package:flutter/widgets.dart';
import 'package:serene/shared/ui_helpers.dart';

class HighlightInternalisationScreen extends StatefulWidget {
  HighlightInternalisationScreen({Key key}) : super(key: key);

  @override
  _HighlightInternalisationScreenState createState() =>
      _HighlightInternalisationScreenState();
}

class _HighlightInternalisationScreenState
    extends State<HighlightInternalisationScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          UIHelper.verticalSpaceMedium(),
          UIHelper.verticalSpaceMedium(),
          Text("meh"),
          UIHelper.verticalSpaceMedium(),
          // Text("Debug Stuff Counter: $_longPressCounter")
        ],
      ),
    );
  }
}
