import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/models/obstacle.dart';
import 'package:serene/shared/ui_helpers.dart';
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
    var buildUpDownArrow = Column(
      children: [
        Icon(Icons.keyboard_arrow_up),
        Icon(Icons.keyboard_arrow_down),
      ],
    );

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black54, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      key: ValueKey(obstacle.name),
      child: ListTile(
        leading: Image.asset(obstacle.iconPath),
        title: Text(obstacle.description),
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
          style: Theme.of(context).textTheme.subtitle1,
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
    return Container(child: buildObstacleList(context), height: 700);
  }
}
