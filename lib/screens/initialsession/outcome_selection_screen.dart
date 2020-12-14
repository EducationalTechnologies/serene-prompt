import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/models/outcome.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';

class OutcomeSelectionScreen extends StatefulWidget {
  OutcomeSelectionScreen({Key key}) : super(key: key);

  @override
  _OutcomeSelectionScreenState createState() => _OutcomeSelectionScreenState();
}

class _OutcomeSelectionScreenState extends State<OutcomeSelectionScreen> {
  _buildHindranceItem(BuildContext context, Outcome outcome) {
    final vm = Provider.of<InitSessionViewModel>(context);

    return Card(
      color: outcome.isSelected
          ? Theme.of(context).selectedRowColor
          : Colors.white,
      child: ListTile(
        leading: Image.asset(outcome.iconPath),
        title: Text(outcome.name),
        subtitle: Text(outcome.description),
        isThreeLine: true,
        trailing: Icon(Icons.help_outline),
        onTap: () async {
          print("Do Something On Selected ");
          outcome.isSelected = !outcome.isSelected;
          setState(() => {});
        },
      ),
    );
  }

  buildOutcomeList(BuildContext context) {
    var vm = Provider.of<InitSessionViewModel>(context);

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        UIHelper.verticalSpaceLarge(),
        Text(
          "Was sind Hindernisse, die dich davon abhalten, mit dem Vokabellernen anzufangen oder die dich während des Vokabellernens stören? Wähle alle Hindernisse aus, die auf dich zutreffen - auch wenn sie nur manchmal zutreffen.",
          style: (TextStyle(fontSize: 20)),
        ),
        for (var o in vm.outcomes) _buildHindranceItem(context, o),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<InitSessionViewModel>(context);
    return Container(child: buildOutcomeList(context));
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UIHelper.verticalSpaceLarge(),
          Text("Was könnte dich vom Erreichen deiner Ziele abhalten?",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.subtitle1),
          UIHelper.verticalSpaceSmall(),
          // buildOutcomeDropdown(context),
          Expanded(
            child: buildOutcomeList(context),
          ),
        ],
      ),
    );
  }
}
