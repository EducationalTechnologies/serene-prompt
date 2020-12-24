import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';

class ObstacleEnterScreen extends StatefulWidget {
  ObstacleEnterScreen({Key key}) : super(key: key);

  @override
  _ObstacleEnterScreenState createState() => _ObstacleEnterScreenState();
}

class _ObstacleEnterScreenState extends State<ObstacleEnterScreen> {
  List<TextField> _customObstacles = [];

  @override
  void initState() {
    super.initState();
    _customObstacles.add(buildTextField("0"));
  }

  buildTextField(String key) {
    return TextField(
      decoration: InputDecoration(hintText: 'Gib ein Hindernis ein'),
      onChanged: (String text) {
        Provider.of<InitSessionViewModel>(context)
            .editCustomObstacle(key, text);
      },
    );
  }

  buildAddButton() {
    return ElevatedButton.icon(
        onPressed: () {
          setState(() {
            if (_customObstacles.length < 3) {
              _customObstacles.add(
                  buildTextField((_customObstacles.length + 1).toString()));
            }
          });
        },
        icon: Icon(Icons.add),
        label: Text("Weiteres Hindernis hinzufügen"));
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
          // Text(
          //     "Falls du mehr als ein zusätzliches Hindernis aufschreiben möchtest, dann drücke das (+)-Symbol.",
          //     style: Theme.of(context).textTheme.subtitle1),
          // UIHelper.verticalSpaceMedium(),
          ..._customObstacles,
          // buildTextField(),
          UIHelper.verticalSpaceMedium(),
          buildAddButton()
        ],
      ),
    );
  }
}
