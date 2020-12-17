import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';

class OutcomeEnterScreen extends StatefulWidget {
  OutcomeEnterScreen({Key key}) : super(key: key);

  @override
  _OutcomeEnterScreenState createState() => _OutcomeEnterScreenState();
}

class _OutcomeEnterScreenState extends State<OutcomeEnterScreen> {
  buildTextField(String index) {
    final vm = Provider.of<InitSessionViewModel>(context);

    return TextField(
        decoration: InputDecoration(hintText: 'Gib ein Hindernis ein'),
        key: Key(index),
        onChanged: (text) {
          vm.editCustomOutcome(index, text);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              "Wenn du in der vorherigen Liste nicht die Hindernisse gefunden hast, die dich am ehesten vom Vokabellernen abhalten, kannst du hier eigene eingeben.",
              style: Theme.of(context).textTheme.subtitle1),
          UIHelper.verticalSpaceMedium(),
          Text(
              "Falls du mehr als ein zusätzliches Hindernis aufschreiben möchtest, dann drücke das (+)-Symbol.",
              style: Theme.of(context).textTheme.subtitle1),
          UIHelper.verticalSpaceMedium(),
          buildTextField("1"),
          UIHelper.verticalSpaceMedium(),
        ],
      ),
    );
  }
}
