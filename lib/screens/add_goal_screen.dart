import 'package:flutter/material.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/models/tag.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/symbol_helper.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serene/viewmodels/add_goal_view_model.dart';

class AddGoalScreen extends StatefulWidget {
  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  DateTime selectedDate = DateTime.now();
  TextEditingController _textController;
  TextEditingController _dateFieldController;

  var inputModeSelected = [true, false];
  var _difficultySelected = [false, true, false];

  @override
  void initState() {
    super.initState();
    _textController = new TextEditingController(text: "");
    _dateFieldController = new TextEditingController(text: "");

    Future.delayed(Duration.zero, () {
      final appState = Provider.of<AddGoalViewModel>(context, listen: false);
      _textController.text = appState.currentGoal.goalText;

      inputModeSelected = [
        appState.currentGoal.progressIndicator ==
            GoalProgressIndicator.checkbox,
        appState.currentGoal.progressIndicator == GoalProgressIndicator.slider
      ];
    });
  }

  buildSubHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child:
          Text(title, style: TextStyle(fontSize: 16, color: Colors.grey[800])),
    );
  }

  _submitGoal() async {
    final vm = Provider.of<AddGoalViewModel>(context, listen: false);
    vm.currentGoal.goalText = _textController.text.toString();
    if (vm.state != ViewState.idle) return;
    if (vm.canSubmit()) {
      await vm.saveCurrentGoal();
      Navigator.pop(context);
    } else {}
  }

  _deleteGoal() async {
    final vm = Provider.of<AddGoalViewModel>(context, listen: false);
    vm.currentGoal.goalText = _textController.text.toString();
    if (vm.state != ViewState.idle) return;
    if (vm.canSubmit()) {
      await vm.deleteCurrentGoal();
      Navigator.pop(context);
    } else {}
  }

  Future<Null> _selectDate(BuildContext context) async {
    final appState = Provider.of<AddGoalViewModel>(context, listen: false);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      appState.currentGoal.deadline = picked;

    setState(() {});
  }

  Widget buildTextEntry() {
    final appState = Provider.of<AddGoalViewModel>(context);

    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10, bottom: 30, top: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        // borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(10),
        //     bottomRight: Radius.circular(10))
      ),
      child: Column(
        children: <Widget>[
          buildSubHeader("Ziel"),
          UIHelper.verticalSpaceSmall(),
          Container(
            padding:
                EdgeInsets.only(left: 10.0, right: 10, bottom: 10, top: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: TextField(
              controller: _textController,
              // decoration:
              //     InputDecoration(labelText: "Ziel", alignLabelWithHint: true),
              keyboardType: TextInputType.text,
              maxLines: null,
              textInputAction: TextInputAction.done,
              onChanged: (text) {
                setState(() {
                  appState.currentGoal.goalText = text.toString();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  buildDateInput() {
    var dateText = "";
    final addGoalState = Provider.of<AddGoalViewModel>(context);
    var date = addGoalState.currentGoal.deadline ?? DateTime.now();
    dateText = addGoalState.currentGoal.deadline != null
        ? DateFormat('dd.MM.yyy').format(date)
        : "";
    _dateFieldController.text = dateText;

    return Row(
      children: <Widget>[
        Icon(Icons.calendar_today),
        SizedBox(width: 10.0),
        Expanded(
          child: Stack(
            alignment: Alignment(1.0, 1.0),
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: "Deadline hinzufügen"),
                enabled: false,
                controller: _dateFieldController,
              ),
              IconButton(
                onPressed: () {
                  _dateFieldController.clear();
                  addGoalState.clearDeadline();
                },
                icon: Icon(Icons.clear),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDatePicker() {
    final appState = Provider.of<AddGoalViewModel>(context);

    // var date = appState.currentGoal.deadline ?? DateTime.now();
    // var dateText = DateFormat('dd.MM.yyy').format(date);
    // var timeText = DateFormat('kk:mm').format(date);

    bool hasDate = appState.currentGoal.deadline != null;

    return Column(
      children: <Widget>[
        InkWell(
            onTap: () {
              _selectDate(context);
              print("Clear");
            },
            child: Stack(
              children: <Widget>[
                if (hasDate) buildDateInput(),
                if (!hasDate)
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      decoration:
                          InputDecoration(labelText: "Deadline hinzufügen"),
                      textAlign: TextAlign.left,
                      enabled: false,
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
              ],
            )),
      ],
    );
  }

  _buildInputSelector() {
    return Container(
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(10),
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 3,
              ),
              Icon(Icons.check_box),
              Container(
                  width: MediaQuery.of(context).size.width * 0.5 - 12,
                  alignment: Alignment.center,
                  child: Text("Checkbox")),
              SizedBox(
                height: 3,
              ),
            ],
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: 3,
              ),
              Icon(Icons.settings_ethernet),
              Container(
                  width: MediaQuery.of(context).size.width * 0.5 - 12,
                  alignment: Alignment.center,
                  child: Text("Slider")),
              SizedBox(
                height: 3,
              ),
            ],
          ),
        ],
        onPressed: (int index) {
          setState(() {
            if (index == 0) {
              Provider.of<AddGoalViewModel>(context)
                  .currentGoal
                  .progressIndicator = GoalProgressIndicator.checkbox;
            } else if (index == 1) {
              Provider.of<AddGoalViewModel>(context)
                  .currentGoal
                  .progressIndicator = GoalProgressIndicator.slider;
            }

            for (int buttonIndex = 0;
                buttonIndex < inputModeSelected.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                inputModeSelected[buttonIndex] = true;
              } else {
                inputModeSelected[buttonIndex] = false;
              }
            }
          });
        },
        isSelected: inputModeSelected,
      ),
    );
  }

  _buildDifficultySelector() {
    var containerWidth = MediaQuery.of(context).size.width * 0.33 - 7;
    return Container(
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(10),
        children: <Widget>[
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: <Widget>[
          //     SizedBox(
          //       height: 5,
          //     ),
          //     Text("❖"),
          //     Container(
          //         width: MediaQuery.of(context).size.width * 0.25 - 7,
          //         alignment: Alignment.center,
          //         child: Text("Trivial")),
          //     SizedBox(
          //       height: 5,
          //     ),
          //   ],
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                height: 2,
              ),
              Text(SymbolHelper.getSymbolForDifficulty(GoalDifficulty.easy)),
              Container(
                  width: containerWidth,
                  alignment: Alignment.center,
                  child: Text("Einfach")),
              SizedBox(
                height: 2,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(SymbolHelper.getSymbolForDifficulty(GoalDifficulty.medium)),
              Container(
                  width: containerWidth,
                  alignment: Alignment.center,
                  child: Text("Mittel"))
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(SymbolHelper.getSymbolForDifficulty(GoalDifficulty.hard)),
              Container(
                  width: containerWidth,
                  alignment: Alignment.center,
                  child: Text("Schwer"))
            ],
          ),
        ],
        onPressed: (int index) {
          setState(() {
            if (index == 0) {
              Provider.of<AddGoalViewModel>(context, listen: false)
                  .currentGoal
                  .difficulty = GoalDifficulty.easy;
            } else if (index == 1) {
              Provider.of<AddGoalViewModel>(context, listen: false)
                  .currentGoal
                  .difficulty = GoalDifficulty.medium;
            } else if (index == 2) {
              Provider.of<AddGoalViewModel>(context, listen: false)
                  .currentGoal
                  .difficulty = GoalDifficulty.hard;
            }

            for (int buttonIndex = 0;
                buttonIndex < _difficultySelected.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                _difficultySelected[buttonIndex] = true;
              } else {
                _difficultySelected[buttonIndex] = false;
              }
            }
          });
        },
        isSelected: _difficultySelected,
      ),
    );
  }

  _buildTagSelectionList(AddGoalViewModel vm) {
    return Column(
      children: <Widget>[for (var tag in vm.tags) _buildTagSelection(vm, tag)],
    );
  }

  _buildTagSelection(AddGoalViewModel vm, TagModel tag) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(tag.name),
      onChanged: (bool value) {
        vm.toggleTag(tag, value);
      },
      value: false,
    );
  }

  _buildParentGoalSelection(AddGoalViewModel vm) {
    return DropdownButton(
        value: vm.selectedParentGoal,
        onChanged: (selectedParent) {
          print("Selected New Parent: $selectedParent");
          vm.selectedParentGoal = selectedParent;
        },
        items: vm.potentialParents.map<DropdownMenuItem>((og) {
          return DropdownMenuItem<Goal>(
            child: Text(og.goalText),
            value: og,
          );
        }).toList());
  }

  _buildSubmitButton() {
    var vm = Provider.of<AddGoalViewModel>(context);
    return SizedBox(
        width: double.infinity,
        height: 60,
        child: RaisedButton(
          onPressed: () => _submitGoal(),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          child: vm.state == ViewState.idle
              ? Text("Speichern", style: TextStyle(fontSize: 20))
              : CircularProgressIndicator(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<AddGoalViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        // title: Text('Neues Ziel'),
        centerTitle: true,
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
        actions: <Widget>[
          if (vm.mode == GoalScreenMode.edit)
            FlatButton(
                child: Text("Löschen"), onPressed: () async => _deleteGoal()),
          FlatButton(
              child: Text("Speichern"), onPressed: () async => _submitGoal())
        ],
      ),
      body: Container(
        // padding: EdgeInsets.all(10),
        // margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              buildTextEntry(),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: <Widget>[
                    UIHelper.verticalSpaceMedium(),
                    buildSubHeader("Zeitplan"),
                    UIHelper.verticalSpaceSmall(),
                    buildDatePicker(),
                    UIHelper.verticalSpaceMedium(),
                    buildSubHeader("Schwierigkeit"),
                    UIHelper.verticalSpaceSmall(),
                    _buildDifficultySelector(),
                    UIHelper.verticalSpaceMedium(),
                    // buildSubHeader("Eingabe des Zielfortschritts"),
                    // UIHelper.verticalSpaceSmall(),
                    // _buildInputSelector(),
                    // UIHelper.verticalSpaceSmall(),
                    // if (vm.tags.length > 0)
                    //   buildSubHeader("Tags"),
                    // _buildTagSelectionList(vm),
                    // buildSubHeader("Übergeordnetes Ziel"),
                    // _buildParentGoalSelection(vm),
                    UIHelper.verticalSpaceMedium(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildSubmitButton(),
                    ),

                    // // buildSubmitButton(),
                    // UIHelper.verticalSpaceLarge(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
