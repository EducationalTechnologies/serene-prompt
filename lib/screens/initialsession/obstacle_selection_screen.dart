import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/models/obstacle.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';

class ObstacleSelectionScreen extends StatefulWidget {
  ObstacleSelectionScreen({Key key}) : super(key: key);

  @override
  _ObstacleSelectionScreenState createState() =>
      _ObstacleSelectionScreenState();
}

class _ObstacleSelectionScreenState extends State<ObstacleSelectionScreen> {
  _buildHindranceItem(BuildContext context, Obstacle obstacle) {
    final vm = Provider.of<InitSessionViewModel>(context);
    return Card(
      color: obstacle.isSelected
          ? Theme.of(context).selectedRowColor
          : Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black54, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Image.asset(obstacle.iconPath),
        title: Text(obstacle.description),
        subtitle: Text(""),
        isThreeLine: true,
        onTap: () async {
          obstacle.isSelected = !obstacle.isSelected;
          vm.obstacleSelected(obstacle);
          setState(() => {});
        },
      ),
    );
  }

  buildObstacleList(BuildContext context) {
    var vm = Provider.of<InitSessionViewModel>(context);

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        UIHelper.verticalSpaceMedium(),
        Text(
          "Was sind Hindernisse, die dich davon abhalten, mit dem Vokabellernen anzufangen oder die dich während des Vokabellernens stören? Wähle alle Hindernisse aus, die auf dich zutreffen - auch wenn sie nur manchmal zutreffen.",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        UIHelper.verticalSpaceMedium(),
        for (var o in vm.obstacles) _buildHindranceItem(context, o),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: buildObstacleList(context));
  }
}
