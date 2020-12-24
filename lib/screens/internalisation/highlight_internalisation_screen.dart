import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/internalisation_view_model.dart';

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
        Provider.of<InternalisationViewModel>(context, listen: false);

    var intentionTextList =
        getIndividualChars(intention.implementationIntention);

    return Container(
      child: Column(
        children: <Widget>[
          UIHelper.verticalSpaceMedium(),
          UIHelper.verticalSpaceMedium(),
          Text(intention.implementationIntention),
          intentionTextList,
          UIHelper.verticalSpaceMedium(),
        ],
      ),
    );
  }
}
