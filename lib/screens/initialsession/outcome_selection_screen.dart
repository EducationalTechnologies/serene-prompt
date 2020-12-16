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
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black54, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Image.asset(
          outcome.iconPath,
          width: 50,
          height: 50,
        ),
        // title: Text(outcome.name),
        title: Text(outcome.description),
        subtitle: Text(""),
        isThreeLine: false,
        // trailing: Icon(Icons.help_outline),
        onTap: () async {
          print("Do Something On Selected ");
          outcome.isSelected = !outcome.isSelected;
          vm.outcomeSelected(outcome);
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
          "Was wäre gut daran, wenn du es schaffen würdest, regelmäßig Vokabeln zu lernen? Wähle die Dinge aus, die für dich am wichtigsten sind.",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        for (var o in vm.outcomes) _buildHindranceItem(context, o),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: buildOutcomeList(context));
  }
}
