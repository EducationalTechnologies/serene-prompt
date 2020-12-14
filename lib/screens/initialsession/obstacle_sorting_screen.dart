import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/models/obstacle.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/goal_shielding_view_model.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';

class ObstacleSortingScreen extends StatefulWidget {
  ObstacleSortingScreen({Key key}) : super(key: key);

  @override
  _ObstacleSortingScreenState createState() => _ObstacleSortingScreenState();
}

class _ObstacleSortingScreenState extends State<ObstacleSortingScreen> {
  _reorderObstacleList(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    setState(() {
      final vm = Provider.of<InitSessionViewModel>(context, listen: false);
      final items = vm.selectedObstacles.removeAt(oldIndex);
      vm.selectedObstacles.insert(newIndex, items);
    });
  }

  _buildHindranceItem(BuildContext context, Obstacle obstacle) {
    final vm = Provider.of<InitSessionViewModel>(context);

    var buildUpDownArrow = Column(
      children: [
        Icon(Icons.keyboard_arrow_up),
        Icon(Icons.keyboard_arrow_down),
      ],
    );

    return Card(
      color: obstacle.isSelected
          ? Theme.of(context).selectedRowColor
          : Colors.white,
      key: ValueKey(obstacle.name),
      child: ListTile(
        leading: Image.asset(obstacle.iconPath),
        title: Text(obstacle.name),
        subtitle: Text(obstacle.description),
        isThreeLine: true,
        trailing: buildUpDownArrow,
        // onTap: () async {
        //   print("Do Something On Selected ");
        //   obstacle.isSelected = !obstacle.isSelected;
        //   setState(() => {});
        // },
      ),
    );
  }

  buildObstacleList(BuildContext context) {
    var vm = Provider.of<InitSessionViewModel>(context);

    var buildHeader = Column(
      children: [
        UIHelper.verticalSpaceLarge(),
        Text(
          "Sortiere die Hindernisse nach Wichtigkeit, indem du sie an die entsprechende Stelle verschiebst",
          style: Theme.of(context).textTheme.headline5,
        ),
      ],
    );

    return ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          _reorderObstacleList(oldIndex, newIndex);
        },
        header: buildHeader,
        children: List.generate(vm.selectedObstacles.length, (index) {
          return _buildHindranceItem(context, vm.selectedObstacles[index]);
        }));
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<InitSessionViewModel>(context, listen: false);
    return Container(child: buildObstacleList(context), height: 700);
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
          // buildObstacleDropdown(context),
          Expanded(
            child: buildObstacleList(context),
          ),
        ],
      ),
    );
  }
}
