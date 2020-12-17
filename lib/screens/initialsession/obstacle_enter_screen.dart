import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/shared/ui_helpers.dart';

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
    _customObstacles.add(buildTextField());
  }

  buildTextField() {
    return TextField(
      decoration: InputDecoration(hintText: 'Gib ein Hindernis ein'),
    );
  }

  buildAddButton() {
    return ElevatedButton.icon(
        onPressed: () {
          setState(() {
            if (_customObstacles.length <= 3) {
              _customObstacles.add(buildTextField());
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
          Container(
            height: 200,
            child: ListView(
              children: _customObstacles,
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
