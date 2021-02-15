import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/models/outcome.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';

class OutcomeSortingScreen extends StatefulWidget {
  OutcomeSortingScreen({Key key}) : super(key: key);

  @override
  _OutcomeSortingScreenState createState() => _OutcomeSortingScreenState();
}

class _OutcomeSortingScreenState extends State<OutcomeSortingScreen> {
  _reorderOutcomeList(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    setState(() {
      final vm = Provider.of<InitSessionViewModel>(context, listen: false);
      final items = vm.selectedOutcomes.removeAt(oldIndex);
      vm.selectedOutcomes.insert(newIndex, items);
    });
  }

  _buildHindranceItem(BuildContext context, Outcome outcome) {
    var upDownArrow = Column(
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
      key: ValueKey("outcome ${outcome.name}"),
      child: ListTile(
        leading: Image.asset(outcome.iconPath),
        title: Text(outcome.description),
        subtitle: Text(""),
        isThreeLine: true,
        trailing: upDownArrow,
        // onTap: () async {
        //   print("Do Something On Selected ");
        //   Outcome.isSelected = !Outcome.isSelected;
        //   setState(() => {});
        // },
      ),
    );
  }

  buildOutcomeList(BuildContext context) {
    var vm = Provider.of<InitSessionViewModel>(context);

    var buildHeader = Column(
      children: [
        UIHelper.verticalSpaceLarge(),
        Text(
          "Sortiere die schönen Vorstellungen nach Wichtigkeit, indem du sie an die entsprechende Stelle verschiebst",
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );

    return ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          _reorderOutcomeList(oldIndex, newIndex);
        },
        header: buildHeader,
        children: List.generate(vm.selectedOutcomes.length, (index) {
          return _buildHindranceItem(context, vm.selectedOutcomes[index]);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: buildOutcomeList(context), height: 700);
  }
}
