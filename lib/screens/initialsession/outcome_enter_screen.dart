import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:prompt/shared/ui_helpers.dart';
import 'package:prompt/viewmodels/init_session_view_model.dart';

class OutcomeEnterScreen extends StatefulWidget {
  OutcomeEnterScreen({Key key}) : super(key: key);

  @override
  _OutcomeEnterScreenState createState() => _OutcomeEnterScreenState();
}

class _OutcomeEnterScreenState extends State<OutcomeEnterScreen> {
  List<TextField> _customOutcomes = [];

  @override
  void initState() {
    super.initState();
  }

  buildTextField(String key) {
    var vm = Provider.of<InitSessionViewModel>(context, listen: false);
    return TextField(
      decoration: InputDecoration(hintText: 'Gib ein Ziel ein'),
      onChanged: (String text) {
        setState(() {});
        vm.editCustomOutcome(key, text);
      },
    );
  }

  buildAddButton() {
    return ElevatedButton.icon(
        onPressed: () {
          // Widget only rebuilds on assignment, therefore we use a temp list to assign to
          List<TextField> temp = [];
          if (_customOutcomes.length <= 3) {
            _customOutcomes
                .add(buildTextField((_customOutcomes.length + 1).toString()));
          }
          for (var co in _customOutcomes) {
            temp.add(co);
          }
          setState(() {
            _customOutcomes = temp;
          });
        },
        icon: Icon(Icons.add),
        label: Text("Weiteres Ziel hinzufügen"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          UIHelper.verticalSpaceMedium(),
          Text(
              "Wenn du in der vorherigen Liste nicht die Ziele gefunden hast, die dich am ehesten zum Vokabellernen motivieren, kannst du hier eigene eingeben.",
              style: Theme.of(context).textTheme.subtitle1),
          UIHelper.verticalSpaceMedium(),
          // Text(
          //     "Falls du mehr als ein zusätzliches Hindernis aufschreiben möchtest, dann drücke das (+)-Symbol.",
          //     style: Theme.of(context).textTheme.subtitle1),
          // UIHelper.verticalSpaceMedium(),
          Container(
            height: 200,
            child: ListView(
              children: _customOutcomes,
            ),
          ),
          // buildTextField(),
          UIHelper.verticalSpaceMedium(),
          buildAddButton()
        ],
      ),
    );
  }
}
