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

  _swapItems(int indexA, int indexB) {
    final vm = Provider.of<InitSessionViewModel>(context, listen: false);
    if (indexA < 0 || indexB < 0) return;
    if (indexA > (vm.selectedOutcomes.length - 1) ||
        indexB > (vm.selectedOutcomes.length - 1)) return;
    var tmpB = vm.selectedOutcomes[indexB];
    vm.selectedOutcomes[indexB] = vm.selectedOutcomes[indexA];
    vm.selectedOutcomes[indexA] = tmpB;
  }

  _outcomeUp(Outcome outcome) {
    final vm = Provider.of<InitSessionViewModel>(context, listen: false);
    var index = vm.selectedOutcomes.indexOf(outcome);
    setState(() {
      _swapItems(index, index - 1);
    });
  }

  _outcomeDown(Outcome outcome) {
    final vm = Provider.of<InitSessionViewModel>(context, listen: false);
    var index = vm.selectedOutcomes.indexOf(outcome);
    setState(() {
      _swapItems(index, index + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: buildOutcomeList(context), height: 700);
  }

  buildOutcomeList(BuildContext context) {
    var vm = Provider.of<InitSessionViewModel>(context);

    var buildHeader = Column(
      children: [
        UIHelper.verticalSpaceMedium(),
        Text(
          "Sortiere die schönen Vorstellungen nach Wichtigkeit, indem du sie an die entsprechende Stelle verschiebst. Das, was dir am wichtigsten ist, sollte ganz oben sein.",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        UIHelper.verticalSpaceMedium(),
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

  _buildHindranceItem(BuildContext context, Outcome outcome) {
    var upDownArrow = Column(
      children: [
        IconButton(
          icon: Icon(Icons.keyboard_arrow_up),
          onPressed: () {
            _outcomeUp(outcome);
          },
        ),
        IconButton(
          icon: Icon(Icons.keyboard_arrow_down),
          onPressed: () {
            _outcomeDown(outcome);
          },
        ),
      ],
    );

    var content = Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UIHelper.horizontalSpaceSmall(),
        Image.asset(
          outcome.iconPath,
          width: 64,
          height: 64,
        ),
        Flexible(child: Text(outcome.description)),
        upDownArrow
      ],
    ));

    return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black54, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        key: ValueKey("outcome ${outcome.name}"),
        child: content);
  }
}
