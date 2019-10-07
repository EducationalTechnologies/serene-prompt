import 'package:flutter/material.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/text_styles.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/state/app_state.dart';
import 'package:serene/state/goal_state.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddGoalScreen extends StatefulWidget {
  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  DateTime selectedDate = DateTime.now();
  TextEditingController _textController;
  TextEditingController _dateFieldController;

  var inputModeSelected = [true, false];
  var _difficultySelected = [false, true, false, false];

  @override
  void initState() {
    super.initState();
    _textController = new TextEditingController(text: "");
    _dateFieldController = new TextEditingController(text: "");

    Future.delayed(Duration.zero, () {
      final appState = Provider.of<GoalState>(context);
      _textController.text = appState.currentGoal.goalText;

      inputModeSelected = [
        appState.currentGoal.progressIndicator ==
            GoalProgressIndicator.checkbox,
        appState.currentGoal.progressIndicator == GoalProgressIndicator.slider
      ];
    });
  }

  _canSubmit() {
    final appState = Provider.of<GoalState>(context);
    if (appState.currentGoal.goalText != "") {
      return true;
    }
    return false;
  }

  _submitGoal() async {
    final goalState = Provider.of<GoalState>(context);
    final appState = Provider.of<AppState>(context);
    if (_canSubmit()) {
      await goalState.saveCurrentGoal();
      await appState.reloadGoals();
      Navigator.pop(context);
    } else {}
  }

  Future<Null> _selectDate(BuildContext context) async {
    final appState = Provider.of<GoalState>(context);
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
    final appState = Provider.of<GoalState>(context);

    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(5)),
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(labelText: "Gib dein Lernziel ein"),
        keyboardType: TextInputType.text,
        maxLines: null,
        textInputAction: TextInputAction.done,
        onChanged: (text) {
          setState(() {
            appState.currentGoal.goalText = text.toString();
          });
        },
      ),
    );
  }

  Widget buildDatePicker() {
    final appState = Provider.of<GoalState>(context);

    var date = appState.currentGoal.deadline ?? DateTime.now();
    var dateText = DateFormat('dd.MM.yyy').format(date);
    var timeText = DateFormat('kk:mm').format(date);

    bool hasDate = appState.currentGoal.deadline != null;
    return Column(
      children: <Widget>[
        InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: Stack(
              children: <Widget>[
                if (hasDate)
                  Container(
                    padding: EdgeInsets.all(15.0),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.black),
                        UIHelper.horizontalSpaceSmall(),
                        Text(
                          "$dateText",
                          style: pickerStyle,
                        ),
                        UIHelper.horizontalSpaceMedium(),
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                  ),
                if (!hasDate)
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(15.0),
                    alignment: Alignment.center,
                    color: Color(0x11000000),
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
        children: <Widget>[
          Column(
            children: <Widget>[
              Icon(Icons.check_box),
              Container(
                  width: MediaQuery.of(context).size.width * 0.5 - 12,
                  alignment: Alignment.center,
                  child: Text("Checkbox"))
            ],
          ),
          Column(
            children: <Widget>[
              Icon(Icons.settings_ethernet),
              Container(
                  width: MediaQuery.of(context).size.width * 0.5 - 12,
                  alignment: Alignment.center,
                  child: Text("Slider"))
            ],
          ),
        ],
        onPressed: (int index) {
          setState(() {
            if (index == 0) {
              Provider.of<GoalState>(context).currentGoal.progressIndicator =
                  GoalProgressIndicator.checkbox;
            } else if (index == 1) {
              Provider.of<GoalState>(context).currentGoal.progressIndicator =
                  GoalProgressIndicator.slider;
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
    return Container(
      child: ToggleButtons(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("💡"),
              Container(
                  width: MediaQuery.of(context).size.width * 0.25 - 7,
                  alignment: Alignment.center,
                  child: Text("Trivial"))
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("💡💡"),
              Container(
                  width: MediaQuery.of(context).size.width * 0.25 - 7,
                  alignment: Alignment.center,
                  child: Text("Einfach"))
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("💡💡💡"),
              Container(
                  width: MediaQuery.of(context).size.width * 0.25 - 7,
                  alignment: Alignment.center,
                  child: Text("Mittel"))
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("💡💡💡💡"),
              Container(
                  width: MediaQuery.of(context).size.width * 0.25 - 7,
                  alignment: Alignment.center,
                  child: Text("Schwer"))
            ],
          ),
        ],
        onPressed: (int index) {
          setState(() {
            if (index == 0) {
              Provider.of<GoalState>(context).currentGoal.progressIndicator =
                  GoalProgressIndicator.checkbox;
            } else if (index == 1) {
              Provider.of<GoalState>(context).currentGoal.progressIndicator =
                  GoalProgressIndicator.slider;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neues Ziel'),
        actions: <Widget>[
          FlatButton.icon(
              textColor: Colors.white,
              icon: const Icon(Icons.save),
              label: Text("Speichern"),
              onPressed: () async {
                _submitGoal();
              }),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        // margin: EdgeInsets.only(left: 10.0, right: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              UIHelper.verticalSpaceMedium(),
              buildTextEntry(),
              UIHelper.verticalSpaceMedium(),
              Text(
                "Zeitplan",
                style: Theme.of(context).textTheme.subhead,
                textAlign: TextAlign.left,
              ),
              buildDatePicker(),
              UIHelper.verticalSpaceMedium(),
              Text(
                "Schwierigkeit",
                style: Theme.of(context).textTheme.subhead,
                textAlign: TextAlign.left,
              ),
              UIHelper.verticalSpaceSmall(),
              _buildDifficultySelector(),
              UIHelper.verticalSpaceMedium(),
              Text(
                "Eingabe",
                style: Theme.of(context).textTheme.subhead,
                textAlign: TextAlign.left,
              ),
              UIHelper.verticalSpaceSmall(),
              _buildInputSelector(),
              UIHelper.verticalSpaceLarge(),
              SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: RaisedButton(
                    onPressed: () {
                      _submitGoal();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    child: Text("Speichern", style: TextStyle(fontSize: 20)),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
