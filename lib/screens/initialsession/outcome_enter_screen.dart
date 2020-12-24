import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/shared/ui_helpers.dart';

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
    _customOutcomes.add(buildTextField());
  }

  buildTextField() {
    return TextField(
      decoration: InputDecoration(hintText: 'Gib ein Ziel ein'),
    );
  }

  buildAddButton() {
    return ElevatedButton.icon(
        onPressed: () {
          setState(() {
            if (_customOutcomes.length <= 3) {
              _customOutcomes.add(buildTextField());
            }
          });
        },
        icon: Icon(Icons.add),
        label: Text("Weiteres Ziel hinzufügen"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
