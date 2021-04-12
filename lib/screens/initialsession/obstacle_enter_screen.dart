import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:prompt/shared/ui_helpers.dart';
import 'package:prompt/viewmodels/init_session_view_model.dart';

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
  }

  buildTextField(String key) {
    var vm = Provider.of<InitSessionViewModel>(context, listen: false);
    return TextField(
      decoration: InputDecoration(hintText: 'Gib ein Hindernis ein'),
      onChanged: (String text) {
        setState(() {});
        vm.editCustomObstacle(key, text);
      },
    );
  }

  buildAddButton() {
    return ElevatedButton.icon(
        onPressed: () {
          setState(() {
            // Widget only rebuild on assignment, therefore we use a temp list to assign to
            List<TextField> temp = [];
            if (_customObstacles.length <= 3) {
              _customObstacles.add(
                  buildTextField((_customObstacles.length + 1).toString()));
            }
            for (var co in _customObstacles) {
              temp.add(co);
            }
            setState(() {
              _customObstacles = temp;
            });
          });
        },
        icon: Icon(Icons.add),
        label: Text("Weiteres Hindernis hinzufügen"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          UIHelper.verticalSpaceMedium(),
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
